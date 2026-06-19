import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:othello/extensions/nested_list.dart';
import 'package:othello/objects/flip_piece_state/flip_piece_state.dart';
import 'package:othello/objects/game_state/game_state.dart' as gso;
import 'package:othello/objects/piece_state/piece_state.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data/room_data.dart' as rp;
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:othello/providers/user/users.dart';
import 'package:othello/utils/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_state.g.dart';

@Riverpod(keepAlive: true)
class GameState extends _$GameState {
  bool _flipping = false;
  bool _stopped = false;
  RoomData? _pendingRoom;
  void Function(int status)? onEndGame;

  @override
  gso.GameState build(String id) {
    // Watch existence (not roomData). This bool is stable during gameplay, so
    // build re-runs only on room create/delete, never per move. On deletion
    // (e.g. reset), stop reacting and return the stale state so this keepAlive
    // provider becomes inert. roomDataProvider throws once the room is gone, so
    // this guard must come before reading/listening to it.
    final exists = ref.watch(roomExistsProvider(id));
    if (!exists) {
      stop();
      try {
        return state;
      } catch (_) {
        throw StateError('RoomData not found for id: $id');
      }
    }
    final room = ref.read(rp.roomDataProvider(id));

    // Single reactive entry point: every move (local, bot, online opponent)
    // lands here as a roomData change and is rendered by [_onRoomChanged].
    ref.listen(rp.roomDataProvider(id), (_, next) => _onRoomChanged(next));

    final previous = stateOrNull;
    if (previous == null) return gso.GameState(roomData: room);
    return previous.copyWith(roomData: room);
  }

  /// Reacts to a roomData change by diffing move history against the last
  /// rendered state. A single new move animates forward; anything else
  /// (undo, reset, multi-step jump) snaps the board without animation.
  void _onRoomChanged(RoomData next) {
    if (_stopped) return;
    // UI not initialized yet (no piece states); just track the latest room.
    if (state.pieceStates.isEmpty) {
      state = state.copyWith(roomData: next);
      return;
    }
    // An animation is in flight; remember the latest room and process it once
    // the current animation completes.
    if (_flipping) {
      _pendingRoom = next;
      return;
    }
    final current = state.roomData;
    final delta = next.lastMoves.length - current.lastMoves.length;
    if (delta == 1) {
      _animateForwardMove(current, next);
    } else if (delta == 0) {
      // Metadata-only change (e.g. opponent joined); no board re-render needed.
      state = state.copyWith(roomData: next);
    } else {
      _snapTo(next);
    }
  }

  /// Renders a single new move with the flip animation. [pre] is the board
  /// before the move (used to compute the pieces to flip), [next] is the new
  /// logical state from the DB.
  void _animateForwardMove(RoomData pre, RoomData next) {
    final last = next.lastMoves.last;
    final i = last.moveI, j = last.moveJ;
    final piecesToFlip = pre.getPiecesToFlip(i, j, pre.currentPlayerMove);

    final pStates = state.pieceStates.deepUnlock;
    pStates[i][j] = pStates[i][j].updateFromBoardValue(pre.currentPlayerMove);
    state = state.copyWith(roomData: next, pieceStates: pStates.deepLock);

    _startFlipAnimation(piecesToFlip, false);
  }

  /// Adopts [next] and renders the board directly, without animation. Used for
  /// undo, reset, and catch-up jumps.
  void _snapTo(RoomData next) {
    state = state.copyWith(roomData: next);
    _syncEachPiece(false, false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markPossibleMovesOrEndGame();
    });
  }

  void _drainPending() {
    final pending = _pendingRoom;
    if (pending == null) return;
    _pendingRoom = null;
    _onRoomChanged(pending);
  }

  RoomData get _roomData => state.roomData;

  int get boardHeight => _roomData.height;

  int get boardLength => _roomData.length;

  IList<IList<int>> get board => _roomData.currentBoard;

  double get cellWidth => state.cellWidth;

  rp.RoomData get _roomNotifier => ref.read(rp.roomDataProvider(id).notifier);

  /// Call once from the widget after the provider is created to set callbacks
  /// and initialize layout/UI state.
  void initGameState({
    required void Function(int status) onEndGame,
    bool autoReset = false,
  }) {
    state = state.copyWith(autoReset: autoReset);
    this.onEndGame = onEndGame;
    _initValues(_roomData);
    WidgetsBinding.instance.addPostFrameCallback((_) => _markPossibleMoves());
  }

  void stop() {
    _stopped = true;
  }

  void _initValues(RoomData room) {
    final margin = 50;
    double _boardWidth;
    if (Globals.screenWidth < Globals.screenHeight) {
      _boardWidth = Globals.screenWidth - margin;
      final hasEnoughHeight = Globals.screenHeight > Globals.screenWidth * 1.5;
      if (!hasEnoughHeight) _boardWidth -= Globals.screenWidth * 0.2;
    } else {
      const appBarHeight = 100;
      _boardWidth = Globals.screenHeight - margin - 100;
      if (!kIsWeb) _boardWidth -= appBarHeight;
    }

    double _cellWidth = _boardWidth / room.length;

    List<IList<FlipPieceState>> fStates = [];
    List<IList<PieceState>> pStates = [];
    for (int i = 0; i < room.height; i++) {
      List<FlipPieceState> fRow = List.filled(
        room.length,
        const FlipPieceState(),
      );
      List<PieceState> pRow = List.generate(
        room.length,
        (j) => PieceState.fromBoardvalue(boardValue: room.currentBoard[i][j]),
      );
      fStates.add(fRow.lock);
      pStates.add(pRow.lock);
    }

    state = state.copyWith(
      boardWidth: _boardWidth,
      cellWidth: _cellWidth,
      flipPieceStates: fStates.lock,
      pieceStates: pStates.lock,
    );
  }

  /// Triggers an undo on the DB. Rendering is handled reactively by
  /// [_onRoomChanged] (delta < 0 -> snap).
  Future<void> undo() async {
    await _roomNotifier.undo();
  }

  /// Handles a human tap. Only validates whose turn it is, then writes the move
  /// to the DB. The resulting roomData change is rendered by [_onRoomChanged].
  Future<void> Function() onTapOnPiece(int i, int j) => () async {
    final room = _roomData;
    if (room.roomType == RoomType.onlinePvP) {
      final currentUser = ref.read(currentUserProvider);
      if (room.playerIdTurn != currentUser.id) return;
    } else {
      if (!room.isManualTurn) return;
    }
    await _roomNotifier.makeMove(i, j);
  };

  bool _markPossibleMovesOrEndGame({bool callEndGame = true}) {
    if (!_markPossibleMoves() && callEndGame) {
      _endGame();
      return true;
    }
    return false;
  }

  void _endGame() async {
    if (_stopped) return;
    if (state.autoReset) {
      // Show the finished board briefly, then reset. The resetBoard change is
      // rendered (and the CvC preview restarted) reactively via _onRoomChanged.
      await Future.delayed(const Duration(seconds: 2));
      if (_stopped) return;
      await _roomNotifier.resetBoard();
      return;
    }
    final status = _roomData.getStatus();
    onEndGame?.call(status);
  }

  bool _markPossibleMoves() {
    final room = _roomData;
    var possibleMoves = room.getPossibleMovesList();
    bool havePossibleMove = false;
    final currentPStates = state.pieceStates.deepUnlock;

    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        if (currentPStates[i][j].possibleMove) {
          currentPStates[i][j] = currentPStates[i][j].copyWith(
            possibleMove: false,
          );
        }
      }
    }
    for (var possibleMove in possibleMoves) {
      int i = possibleMove[0], j = possibleMove[1];
      currentPStates[i][j] = currentPStates[i][j].copyWith(possibleMove: true);
      havePossibleMove = true;
    }
    state = state.copyWith(pieceStates: currentPStates.deepLock);
    return havePossibleMove;
  }

  Future<void> _startFlipAnimation(
    List<List<List<int>>?> piecesToFlip,
    bool debug,
  ) async {
    if (_stopped) return;
    bool gameEnded = _markPossibleMovesOrEndGame();
    if (_flipping) return;
    _flipping = true;
    for (var levelPieces in piecesToFlip) {
      if (levelPieces != null) {
        for (var pair in levelPieces) {
          int i = pair.first;
          int j = pair.last;
          flip(i, j);
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
      if (_stopped) {
        _flipping = false;
        return;
      }
    }
    await Future.delayed(const Duration(milliseconds: 400));
    if (_stopped) {
      _flipping = false;
      return;
    }
    _syncEachPiece(gameEnded, debug);
    _flipping = false;
    _drainPending();
  }

  void _syncEachPiece(bool gameEnded, bool debug) {
    if (_stopped) return;
    var newPStates = state.pieceStates.deepUnlock;
    var newFStates = state.flipPieceStates.deepUnlock;
    for (int i = 0; i < _roomData.height; i++) {
      for (int j = 0; j < _roomData.length; j++) {
        newPStates[i][j] = newPStates[i][j].updateFromBoardValue(board[i][j]);
        newFStates[i][j] = newFStates[i][j].reset();
      }
    }
    state = state.copyWith(
      pieceStates: newPStates.deepLock,
      flipPieceStates: newFStates.deepLock,
    );
    makeNextTurn(gameEnded, debug: debug);
  }

  void set(int i, int j) {
    state = state.set(i, j);
  }

  void flip(int i, int j) {
    state = state.flip(i, j);
  }

  Future<void> makeNextTurn(bool gameEnded, {bool debug = false}) async {
    if (_stopped) return;
    final room = _roomData;
    if (debug) {
      log(
        "whiteTurn: ${room.isWhiteTurn}, manualTurn: ${room.isManualTurn}, gameEnded: $gameEnded",
        name: "makeNextTurn",
      );
    }
    if (!room.isManualTurn && !gameEnded) {
      var nextMove = await room.nextTurn;
      if (_stopped) return;
      if (nextMove != null && nextMove.length >= 2) {
        // Bots write directly to the DB; the move is rendered via _onRoomChanged.
        await _roomNotifier.makeMove(nextMove[0], nextMove[1]);
      }
    }
  }
}

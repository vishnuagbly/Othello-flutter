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
  bool _replayingOnlineMove = false;
  bool _stopped = false;
  (int, int)? _lastMove = null;
  void Function(int status)? onEndGame;

  @override
  gso.GameState build(String id) {
    // Check existence with ref.read (non-reactive) first.
    // If the room was deleted, return stale state WITHOUT calling ref.watch,
    // so this keepAlive provider stops reacting to future DB changes and
    // becomes inert (no ongoing rebuild cycles from DB mutations).
    final roomExists = ref.read(roomExistsProvider(id));
    if (!roomExists) {
      try {
        return state;
      } catch (_) {
        throw StateError('RoomData not found for id: $id');
      }
    }
    final room = ref.watch(rp.roomDataProvider(id));

    // Auto-update room data but preserve the UI state if already initialized
    final previous = stateOrNull;
    if (previous == null) return gso.GameState(roomData: room);

    if (room.roomType == RoomType.onlinePvP &&
        room.lastMoves.length > previous.roomData.lastMoves.length &&
        !_replayingOnlineMove) {
      final move = _detectOnlineOpponentMove(
        previous.roomData.currentBoard,
        room.currentBoard,
      );
      if (move != null && move != _lastMove) {
        final (mi, mj) = move;
        _replayingOnlineMove = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ref.read(rp.roomDataProvider(id).notifier).undo(true);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await onTapOnPiece(mi, mj, false, false, true)();
            _replayingOnlineMove = false;
          });
        });
        return previous;
      }
    }
    return previous.copyWith(roomData: room);
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

  void undo({bool debug = false}) async {
    if (debug) print("performing undo");
    final didUndo = await _roomNotifier.undo();
    if (!didUndo) return;
    if (!_flipping) _syncEachPiece(false, debug);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (debug) print("marking possible moves");
      _markPossibleMovesOrEndGame();
    });
  }

  Future<void> Function() onTapOnPiece(
    int i,
    int j, [
    bool moveFromBot = false,
    bool debug = false,
    bool moveFromOnlinePlayer = false,
  ]) => () async {
    final room = _roomData;
    if (!moveFromBot && !moveFromOnlinePlayer) {
      if (room.roomType == RoomType.onlinePvP) {
        final currentUser = ref.read(currentUserProvider);
        if (room.playerIdTurn != currentUser.id) {
          return;
        }
      } else {
        if (!room.isManualTurn) {
          return;
        }
      }
    }

    _lastMove = (i, j);

    // Set the piece on the UI immediately
    final currentPStates = state.pieceStates.deepUnlock;
    currentPStates[i][j] = currentPStates[i][j].updateFromBoardValue(
      room.currentPlayerMove,
    );
    // For online replay, we sync roomData from DB while reusing the same UI path.
    state = state.copyWith(
      pieceStates: currentPStates.deepLock,
      roomData: room,
    );

    // Skip DB update when replaying opponent move already persisted from sync.
    final piecesToFlip = await _roomNotifier.makeMove(
      i,
      j,
      noDbUpdate: moveFromOnlinePlayer,
    );
    if (piecesToFlip != null) await _startFlipAnimation(piecesToFlip, debug);
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
    final room = _roomData;
    if (state.autoReset) {
      await _roomNotifier.resetBoard();
      if (_stopped) return;
      await Future.delayed(const Duration(seconds: 2));
      if (_stopped) return;
      _markPossibleMovesOrEndGame();
      _syncEachPiece(false, false);
      return;
    }
    final status = room.getStatus();
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

  static (int, int)? _detectOnlineOpponentMove(
    IList<IList<int>> oldBoard,
    IList<IList<int>> newBoard,
  ) {
    for (int i = 0; i < oldBoard.length; i++) {
      for (int j = 0; j < oldBoard[i].length; j++) {
        if (oldBoard[i][j] == -1 && newBoard[i][j] != -1) {
          return (i, j);
        }
      }
    }
    return null;
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
        await onTapOnPiece(nextMove[0], nextMove[1], true, debug)();
      }
    }
  }
}

import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:othello/components/flip_piece.dart';
import 'package:othello/components/piece.dart';
import 'package:othello/objects/room_data/room_data.dart' as models;
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:othello/utils/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_data.g.dart';

@Riverpod(keepAlive: true)
class RoomData extends _$RoomData {
  // TODO: Ideally will split this provider into a GameState Object and
  // GameStateProvider later. For that, will also have to update the rest of the
  // implementation of PieceState and FlipPieceState — instead of having state
  // objects stored, we will store the actual state values, and do operations on
  // the state with listeners. But that is for the future.
  late double _boardWidth;
  late double cellWidth;
  List<List<FlipPieceState?>> flipPieceStates = [];
  List<List<PieceState?>> pieceStates = [];
  bool _flipping = false;
  void Function(int status)? onEndGame;
  bool autoReset = false;

  @override
  models.RoomData build(String id) {
    final ds = ref.watch(roomDataDbProvider);
    final room = ds[id];
    if (room == null) throw StateError('RoomData not found for id: $id');
    return room;
  }

  models.RoomData get _roomData => state;

  int get boardHeight => _roomData.height;

  int get boardLength => _roomData.length;

  IList<IList<int>> get board => _roomData.currentBoard;

  /// Call once from the widget after the provider is created to set callbacks
  /// and initialize layout/UI state.
  void initGameState({
    required void Function(int status) onEndGame,
    bool autoReset = false,
  }) {
    this.onEndGame = onEndGame;
    this.autoReset = autoReset;
    _initValues(_roomData);
    WidgetsBinding.instance.addPostFrameCallback((_) => _markPossibleMoves());
  }

  void _initValues(models.RoomData room) {
    final margin = 50;
    if (Globals.screenWidth < Globals.screenHeight) {
      _boardWidth = Globals.screenWidth - margin;
      final hasEnoughHeight =
          Globals.screenHeight > Globals.screenWidth * 1.5;
      if (!hasEnoughHeight) _boardWidth -= Globals.screenWidth * 0.2;
    } else {
      const appBarHeight = 100;
      _boardWidth = Globals.screenHeight - margin - 100;
      if (!kIsWeb) _boardWidth -= appBarHeight;
    }

    cellWidth = _boardWidth / room.length;
    for (int i = 0; i < room.height; i++) {
      flipPieceStates.add([]);
      flipPieceStates[i].length = room.length;
      pieceStates.add([]);
      pieceStates[i].length = room.length;
    }
  }

  void undo({bool debug = false}) async {
    if (debug) print("performing undo");
    final dbNotifier = ref.read(roomDataDbProvider.notifier);
    final didUndo = await dbNotifier.undo(id);
    if (!didUndo) return;
    if (!_flipping) _syncEachPiece(false, debug);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (debug) print("marking possible moves");
      _markPossibleMovesOrEndGame();
    });
  }

  Future<void> Function(PieceState state) onTapOnPiece(int i, int j,
          [bool moveFromBot = false, bool debug = false]) =>
      (state) async {
        final room = _roomData;
        if (!moveFromBot && !room.isManualTurn) return;
        if (state.mounted) state.set(room.currentPlayerMove);
        final dbNotifier = ref.read(roomDataDbProvider.notifier);
        final piecesToFlip = await dbNotifier.makeMove(id, i, j);
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
    final room = _roomData;
    if (autoReset) {
      await ref.read(roomDataDbProvider.notifier).resetBoard(id);
      await Future.delayed(const Duration(seconds: 2));
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
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        if (pieceStates[i][j]?.possibleMove ?? true) {
          pieceStates[i][j]!.possibleMove = false;
          pieceStates[i][j]?.stateFn(operate: false);
        }
      }
    }
    for (var possibleMove in possibleMoves) {
      int i = possibleMove[0], j = possibleMove[1];
      pieceStates[i][j]!.possibleMove = true;
      pieceStates[i][j]?.stateFn(operate: false);
      havePossibleMove = true;
    }
    return havePossibleMove;
  }

  Future<void> _startFlipAnimation(
      List<List<List<int>>?> piecesToFlip, bool debug) async {
    bool gameEnded = _markPossibleMovesOrEndGame();
    if (_flipping) return;
    _flipping = true;
    for (var levelPieces in piecesToFlip) {
      if (levelPieces != null) {
        for (var pair in levelPieces) {
          flipPieceStates[pair.first][pair.last]?.flip();
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await Future.delayed(const Duration(milliseconds: 400));
    _syncEachPiece(gameEnded, debug);
    _flipping = false;
  }

  void _syncEachPiece(bool gameEnded, bool debug) {
    for (int i = 0; i < _roomData.height; i++) {
      for (int j = 0; j < _roomData.length; j++) {
        pieceStates[i][j]?.set(board[i][j]);
      }
    }
    for (int i = 0; i < _roomData.height; i++) {
      for (int j = 0; j < _roomData.length; j++) {
        flipPieceStates[i][j]?.set();
      }
    }
    makeNextTurn(gameEnded, debug: debug);
  }

  Future<void> makeNextTurn(bool gameEnded, {bool debug = false}) async {
    final room = _roomData;
    if (debug) {
      log(
        "whiteTurn: ${room.isWhiteTurn}, manualTurn: ${room.isManualTurn}, gameEnded: $gameEnded",
        name: "makeNextTurn",
      );
    }
    if (!room.isManualTurn && !gameEnded) {
      var nextMove = await room.nextTurn;
      if (nextMove != null && nextMove.length >= 2) {
        await onTapOnPiece(nextMove[0], nextMove[1], true, debug)(
          pieceStates[nextMove[0]][nextMove[1]]!);
      }
    }
  }

  /// Deletes current room, creates a fresh one from it, returns the new room id.
  /// Caller is responsible for navigation.
  Future<String> resetGame() async {
    final current = state;
    await ref.read(roomDataDbProvider.notifier).deleteRoom(current.id);
    final newRoom = models.RoomData.freshFrom(current);
    return ref.read(roomDataDbProvider.notifier).createRoom(newRoom);
  }
}

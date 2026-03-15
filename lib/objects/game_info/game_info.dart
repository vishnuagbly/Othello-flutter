import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello/components/flip_piece.dart';
import 'package:othello/components/piece.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data/room_data.dart';
import 'package:othello/utils/globals.dart';

class GameInfo {
  GameInfo({
    required this.roomDataId,
    required this.ref,
    required this.onEndGame,
    this.autoReset = false,
  }) {
    _initValues(_roomData);
    WidgetsBinding.instance.addPostFrameCallback((_) => _markPossibleMoves());
  }

  final String roomDataId;
  final WidgetRef ref;
  final void Function(int status) onEndGame;
  final bool autoReset;

  late double _boardWidth;
  late double cellWidth;
  List<List<FlipPieceState?>> flipPieceStates = [];
  List<List<PieceState?>> pieceStates = [];
  bool _flipping = false;

  RoomData get _roomData => ref.read(roomDataProvider(roomDataId));

  int get boardHeight => _roomData.height;

  int get boardLength => _roomData.length;

  RoomData get roomData => _roomData;

  IList<IList<int>> get board => _roomData.currentBoard;

  void _initValues(RoomData room) {
    final margin = 50;
    if (Globals.screenWidth < Globals.screenHeight) {
      _boardWidth = Globals.screenWidth - margin;
      final _hasEnoughHeight = Globals.screenHeight > Globals.screenWidth * 1.5;
      if (!_hasEnoughHeight) _boardWidth -= Globals.screenWidth * 0.2;
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
    final notifier = ref.read(roomDatasProvider.notifier);
    final didUndo = await notifier.undo(roomDataId);
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
        final notifier = ref.read(roomDatasProvider.notifier);
        final piecesToFlip = await notifier.makeMove(roomDataId, i, j);
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
      await ref.read(roomDatasProvider.notifier).resetBoard(roomDataId);
      await Future.delayed(const Duration(seconds: 2));
      _markPossibleMovesOrEndGame();
      _syncEachPiece(false, false);
      return;
    }
    final status = room.getStatus();
    onEndGame(status);
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
    final room = _roomData;
    for (int i = 0; i < room.height; i++) {
      for (int j = 0; j < room.length; j++) {
        pieceStates[i][j]?.set(board[i][j]);
      }
    }
    for (int i = 0; i < room.height; i++) {
      for (int j = 0; j < room.length; j++) {
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
}

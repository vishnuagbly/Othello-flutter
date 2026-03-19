import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:othello/objects/move_data/move_data.dart';
import 'package:othello/objects/room_data/room_data.dart' as o;
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_data.g.dart';

@riverpod
class RoomData extends _$RoomData {
  @override
  o.RoomData build(String id) {
    return ref.watch(roomDataDbProvider)[id]!;
  }

  RoomDataDb get db => ref.read(roomDataDbProvider.notifier);

  /// Returns pieces to flip for animation, or null if room not found or move invalid.
  Future<List<List<List<int>>?>?> makeMove(int i, int j) async {
    final result = _applyMove(state, i, j);
    if (result == null) return null;
    final (updated, piecesToFlip) = result;
    await db.update(updated);
    return piecesToFlip;
  }

  /// Returns true if undo was performed.
  Future<bool> undo() async {
    o.RoomData? next = _applyUndo(state);
    /* Here we need lastMoves length to at least be 2, since based on the
     implementation of [_applyUndo], it get lastToLastMoves as well, which can
     only be available in-case the length >= 2 */
    while (next != null && !next.isManualTurn && next.lastMoves.length >= 2) {
      next = _applyUndo(next);
    }
    if (next == null) return false;
    await db.update(next);
    return true;
  }

  /// Resets board in place (same id). Used for preview CvC autoReset only.
  Future<void> resetBoard() async {
    final updated = state.copyWith(
      lastMoves: const IList.empty(),
      currentBoard: o.RoomData.initializeBoard(state.length, state.height),
      blackTotalDuration: Duration.zero,
      whiteTotalDuration: Duration.zero,
      timestamp: DateTime.now(),
    );
    await db.update(updated);
  }

  /// Pure computation: apply move and return (new o.RoomData, piecesToFlip).
  static (o.RoomData, List<List<List<int>>?>)? _applyMove(
    o.RoomData room,
    int i,
    int j,
  ) {
    final piecesToFlip = room.getPiecesToFlip(i, j, room.currentPlayerMove);
    IList<IList<int>> newBoard = room.currentBoard.replace(
      i,
      room.currentBoard[i].replace(j, room.currentPlayerMove),
    );
    for (var levelPieces in piecesToFlip) {
      if (levelPieces != null) {
        for (var pair in levelPieces) {
          final pi = pair.first, pj = pair.last;
          newBoard = newBoard.replace(
            pi,
            newBoard[pi].replace(pj, 1 - newBoard[pi][pj]),
          );
        }
      }
    }
    final now = DateTime.now();
    final durationToAdd = now.difference(room.timestamp);
    final newBlackDuration = room.isWhiteTurn
        ? room.blackTotalDuration
        : room.blackTotalDuration + durationToAdd;
    final newWhiteDuration = room.isWhiteTurn
        ? room.whiteTotalDuration + durationToAdd
        : room.whiteTotalDuration;
    final currentMove = MoveData.create(
      board: newBoard,
      duration: durationToAdd,
      playerIdTurn: room.playerIdTurn,
      timestamp: room.timestamp,
    );
    final newLastMoves = room.lastMoves.add(currentMove);
    String nextTurnId = room.isWhiteTurn
        ? room.blackPlayer.id
        : room.whitePlayer.id;
    var afterTurn = room.copyWith(
      currentBoard: newBoard,
      lastMoves: newLastMoves,
      blackTotalDuration: newBlackDuration,
      whiteTotalDuration: newWhiteDuration,
      timestamp: now,
      playerIdTurn: nextTurnId,
    );
    if (afterTurn.getPossibleMovesList().isEmpty) {
      nextTurnId = room.playerIdTurn;
      afterTurn = afterTurn.copyWith(playerIdTurn: nextTurnId);
    }
    return (afterTurn, piecesToFlip);
  }

  static o.RoomData? _applyUndo(o.RoomData room) {
    if (room.lastMoves.length < 2) return null;
    final newLastMoves = room.lastMoves.removeLast();
    final lastToLastMove = newLastMoves.last;
    final prevMove = room.lastMoves.last;
    final durationToSubtract = prevMove.duration;
    final wasWhiteTurn = prevMove.playerIdTurn == room.whitePlayer.id;
    final newBlackDuration = wasWhiteTurn
        ? room.blackTotalDuration
        : room.blackTotalDuration - durationToSubtract;
    final newWhiteDuration = wasWhiteTurn
        ? room.whiteTotalDuration - durationToSubtract
        : room.whiteTotalDuration;
    return room.copyWith(
      lastMoves: newLastMoves,
      currentBoard: lastToLastMove.board,
      playerIdTurn: prevMove.playerIdTurn,
      blackTotalDuration: newBlackDuration,
      whiteTotalDuration: newWhiteDuration,
      timestamp: lastToLastMove.timestamp,
    );
  }
}

@riverpod
List<o.RoomData> roomsByType(Ref ref, RoomType type) {
  final ds = ref.watch(roomDataDbProvider);
  return ds.values.where((r) => r.roomType == type).toList();
}

@riverpod
bool roomExists(Ref ref, String id) {
  return ref.watch(roomDataDbProvider).containsKey(id);
}

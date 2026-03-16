import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:othello/objects/move_data/move_data.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synckit/synckit.dart';

part 'room_data_db.g.dart';

@Riverpod(keepAlive: true)
class RoomDataDb extends _$RoomDataDb with SyncedState<RoomData> {
  @override
  Dataset<RoomData> build() {
    return initialize(
      SyncConfig(
        manager: SyncManager<RoomData>(
          stdObjParams: StdObjParams<RoomData>(
            getId: (r) => r.id,
            fromJson: RoomData.fromJson,
            toJson: (r) => r.toJson(),
          ),
          storage: const LocalStorage('rooms'),
          network: NetworkStorage.disabled(),
        ),
      ),
    );
  }

  /// Returns pieces to flip for animation, or null if room not found or move invalid.
  Future<List<List<List<int>>?>?> makeMove(String id, int i, int j) async {
    final room = state[id];
    if (room == null) return null;
    final result = _applyMove(room, i, j);
    if (result == null) return null;
    final (updated, piecesToFlip) = result;
    await update(updated);
    return piecesToFlip;
  }

  /// Returns true if undo was performed.
  Future<bool> undo(String id) async {
    final room = state[id];
    if (room == null) return false;
    RoomData? next = _applyUndo(room);
    /* Here we need lastMoves length to at least be 2, since based on the
     implementation of [_applyUndo], it get lastToLastMoves as well, which can
     only be available in-case the length >= 2 */
    while (next != null && !next.isManualTurn && next.lastMoves.length >= 2) {
      next = _applyUndo(next);
    }
    if (next == null) return false;
    await update(next);
    return true;
  }

  // TODO: remove this function once migration is no longer needed
  Future<void> _ensureCvCNotPersisted() async {
    final cvCRooms = state.entries
        .where((e) => e.value.roomType == RoomType.offlineCvC)
        .toList();
    if (cvCRooms.isEmpty) return;
    for (final e in cvCRooms) {
      await remove(e.key);
    }
    for (final e in cvCRooms) {
      await update(e.value, stateOnly: true);
    }
  }

  /// Creates a room. CvC rooms are state-only (ephemeral); others are persisted.
  /// Returns the room id.
  Future<String> createRoom(RoomData room) async {
    if (room.roomType == RoomType.offlineCvC) {
      await _ensureCvCNotPersisted();
      await update(room, stateOnly: true);
    } else {
      await update(room);
    }
    return room.id;
  }

  Future<void> deleteRoom(String id) async {
    await remove(id);
  }

  /// Resets board in place (same id). Used for preview CvC autoReset only.
  Future<void> resetBoard(String id) async {
    final room = state[id];
    if (room == null) return;
    final updated = room.copyWith(
      lastMoves: const IList.empty(),
      currentBoard: RoomData.initializeBoard(room.length, room.height),
      blackTotalDuration: Duration.zero,
      whiteTotalDuration: Duration.zero,
      timestamp: DateTime.now(),
    );
    await update(updated);
  }
}

@riverpod
List<RoomData> roomsByType(Ref ref, RoomType type) {
  final ds = ref.watch(roomDataDbProvider);
  return ds.values.where((r) => r.roomType == type).toList();
}

@riverpod
bool roomExists(Ref ref, String id) {
  return ref.watch(roomDataDbProvider).containsKey(id);
}

/// Pure computation: apply move and return (new RoomData, piecesToFlip).
(RoomData, List<List<List<int>>?>)? _applyMove(RoomData room, int i, int j) {
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
  String nextTurnId =
      room.isWhiteTurn ? room.blackPlayer.id : room.whitePlayer.id;
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

RoomData? _applyUndo(RoomData room) {
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

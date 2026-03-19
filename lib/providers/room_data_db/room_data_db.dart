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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/objects/player/player.dart';
import 'package:othello/providers/user/users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synckit/synckit.dart';

part 'room_data_db.g.dart';

@Riverpod(keepAlive: true)
class RoomDataDb extends _$RoomDataDb with SyncedState<RoomData> {
  String? _listeningForUserId;

  @override
  Dataset<RoomData> build() {
    ref.listen<bool>(isLoggedInProvider, (prev, isLoggedIn) async {
      if (isLoggedIn) {
        final user = ref.read(currentUserProvider);
        await _startOnlineListening(user.id);
      } else {
        await _stopOnlineListening();
      }
    });
    ref.onDispose(() {
      unawaited(dispose());
    });

    return initialize(
      SyncConfig(
        manager: SyncManager<RoomData>(
          stdObjParams: StdObjParams<RoomData>(
            getId: (r) => r.id,
            fromJson: RoomData.fromJson,
            toJson: (r) => r.toJson(),
          ),
          storage: const LocalStorage('rooms'),
          network: NetworkStorage(
            'online_rooms',
            collectionBased: true,
            collectionBasedConfig: const NetworkStorageCollectionBasedConfig(
              getAllEnabled: false,
              maxGetAllDocs: 10,
            ),
            writeRules: (data) => IMap.fromEntries(
              data.entries.where(
                (e) => e.value.roomType == RoomType.onlinePvP,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startOnlineListening(String userId) async {
    if (_listeningForUserId == userId) return;
    if (_listeningForUserId != null) {
      await _stopOnlineListening();
    }
    _listeningForUserId = userId;
    keepQueryInSync(
      (query) => query.where(
        Filter.or(
          Filter('blackPlayer.playerId', isEqualTo: userId),
          Filter('whitePlayer.playerId', isEqualTo: userId),
        ),
      ),
      maxGetAllDocs: 10,
    );
  }

  Future<void> _stopOnlineListening() async {
    if (_listeningForUserId == null) return;
    _listeningForUserId = null;
    await dispose();
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

  Future<RoomData?> findRoomByCode(String code) async {
    final normalized = code.trim();
    final results = await getQueryFromNetwork(
      (query) => query.where(FieldPath.documentId, isEqualTo: normalized),
      maxGetAllDocs: 1,
    );
    if (results.isEmpty) return null;
    final room = results.values.first;
    if (room.blackPlayer.id.isEmpty || room.whitePlayer.id.isEmpty) {
      return room;
    }
    return null;
  }

  Future<bool> roomCodeExists(String code) async {
    final results = await getQueryFromNetwork(
      (query) => query.where(FieldPath.documentId, isEqualTo: code.trim()),
      maxGetAllDocs: 1,
    );
    return results.isNotEmpty;
  }

  Future<void> joinRoom(RoomData room, String joiningUserId) async {
    final updated = room.whitePlayer.id.isEmpty
        ? room.copyWith(whitePlayer: Player.create(id: joiningUserId))
        : room.copyWith(blackPlayer: Player.create(id: joiningUserId));
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

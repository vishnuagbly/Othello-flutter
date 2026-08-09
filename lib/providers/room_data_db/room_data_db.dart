import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ref.onDispose(() {
      unawaited(dispose());
    });

    final initialState = initialize(
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

    /* Listens to the user id directly, instead of combining
    * [isLoggedInProvider] and [currentUserProvider]. Riverpod notifies the
    * listeners of a provider one at a time, so reading a sibling derived
    * provider from inside this callback can observe its previous (here,
    * errored) value.
    * Registered after [initialize] so that `fireImmediately` can safely reach
    * the sync config. */
    ref.listen<String?>(
      usersProvider.select((users) => users.values.firstOrNull?.id),
      (prev, userId) => unawaited(_syncOnlineListening(userId)),
      fireImmediately: true,
    );

    return initialState;
  }

  Future<void> _syncOnlineListening(String? userId) {
    if (userId == null) return _stopOnlineListening();
    return _startOnlineListening(userId);
  }

  Future<void> _startOnlineListening(String userId) async {
    if (_listeningForUserId == userId) return;
    if (_listeningForUserId != null) {
      await _stopOnlineListening();
    }
    _listeningForUserId = userId;
    /* [keepQueryInSync] needs the synckit manager, which is only ready once
    * `initialize` has finished. This is reachable before that, since the
    * `fireImmediately` listener in [build] runs while `initialize` is still in
    * flight. */
    await waitForInitialization;
    /* A logout, or a login as someone else, can land during the await above, so
    * bail out instead of subscribing for a user we are no longer tracking. */
    if (_listeningForUserId != userId) return;
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

  Future<void> _ensureCvCNotPersisted() async {
    final cvCRooms = state.entries
        .where((e) => e.value.roomType == RoomType.offlineCvC)
        .toList();
    if (cvCRooms.isEmpty) return;
    for (final e in cvCRooms) {
      /* Inside try-catch black to prevent a race-condition, in which case
      * due to a separate async process the same key could have been deleted, by
      * the time we are actually able to delete it here. Hence causing the
      * error. */
      try {
        await remove(e.key);
      } catch (err) {
        if (state.containsKey(e.key)) rethrow;
      }
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

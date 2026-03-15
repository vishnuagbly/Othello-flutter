import 'dart:math';

import 'package:othello/objects/room_data/next_move_fn_ids.dart';
import 'package:othello/objects/room_data/room_data.dart';

abstract class NextMoveFns {
  static const offlineTempId = NextMoveFnIds.offlineTempId;
  static const offlineDelayedTempId = NextMoveFnIds.offlineDelayedTempId;

  static final Map<String, Future<List<int>?> Function(RoomData roomData, String id)> fns = {
    offlineTempId: (roomData, id) async {
      final moves = roomData.getPossibleMovesList();
      if (moves.isEmpty) return null;
      return moves.first;
    },
    offlineDelayedTempId: (roomData, id) async {
      await Future.delayed(Duration(seconds: 1));
      final moves = roomData.getPossibleMovesList();
      if (moves.isEmpty) return null;
      final rand = Random(DateTime.now().second);
      final index = rand.nextInt(moves.length);
      return moves[index];
    }
  };
}

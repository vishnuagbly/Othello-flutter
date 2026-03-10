part of 'room_data.dart';

abstract class NextMoveFns {
  static String offlineTempId = 'offlineTemp';
  static String offlineDelayedTempId = 'offlineDelayedTemp';
  static Map<String, Future<List<int>?> Function(RoomData, String)> fns = {
    offlineTempId: (roomData, id) async {
      await Future.delayed(Duration(seconds: 0));
      return roomData.getPossibleMovesList().first;
    },
    offlineDelayedTempId: (roomData, id) async {
      await Future.delayed(Duration(seconds: 1));
      final moves = roomData.getPossibleMovesList();
      final rand = Random(DateTime.now().second);
      final index = rand.nextInt(moves.length);
      return moves[index];
    }
  };
}

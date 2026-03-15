import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:othello/utils/globals.dart';
import 'package:othello/objects/room_data/next_move_fns.dart';
import 'package:othello/objects/room_data/room_data.dart';

part 'player.freezed.dart';
part 'player.g.dart';

Object? _readPlayerId(Map json, String key) => json[key] ?? Globals.uuid.v1();

@freezed
sealed class Player with _$Player {
  const Player._();

  const factory Player({
    @JsonKey(name: 'playerId', readValue: _readPlayerId) required String id,
    String? nextMoveFnId,
  }) = _Player;

  factory Player.create({String? id, String? nextMoveFnId}) => Player(
        id: id ?? Globals.uuid.v1(),
        nextMoveFnId: nextMoveFnId,
      );

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Future<List<int>?> nextTurn(RoomData roomData) {
    if (nextMoveFnId == null) return Future.value(null);
    if (!NextMoveFns.fns.containsKey(nextMoveFnId)) return Future.value(null);
    return NextMoveFns.fns[nextMoveFnId]!(roomData, id);
  }
}

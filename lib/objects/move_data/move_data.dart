import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:othello/extensions/nested_list.dart';
import 'package:othello/utils/globals.dart';

part 'move_data.freezed.dart';
part 'move_data.g.dart';

Object? _readMoveDataId(Map json, String key) =>
    json[key] ?? Globals.uuid.v1();

class DurationSecondsConverter implements JsonConverter<Duration, int> {
  const DurationSecondsConverter();

  @override
  Duration fromJson(int json) => Duration(seconds: json);

  @override
  int toJson(Duration object) => object.inSeconds;
}

class IListBoardConverter
    implements JsonConverter<IList<IList<int>>, List<dynamic>> {
  const IListBoardConverter();

  @override
  IList<IList<int>> fromJson(List<dynamic> json) =>
      [for (final row in json) (row as List).cast<int>()].deepLock;

  @override
  List<dynamic> toJson(IList<IList<int>> object) => object.deepUnlock;
}

@freezed
sealed class MoveData with _$MoveData {
  const MoveData._();

  const factory MoveData({
    @IListBoardConverter() required IList<IList<int>> board,
    @JsonKey(readValue: _readMoveDataId) required String id,
    @DurationSecondsConverter() required Duration duration,
    required DateTime timestamp,
    required String playerIdTurn,
  }) = _MoveData;

  factory MoveData.create({
    required IList<IList<int>> board,
    required Duration duration,
    required String playerIdTurn,
    required DateTime timestamp,
  }) =>
      MoveData(
        board: board,
        id: Globals.uuid.v1(),
        duration: duration,
        playerIdTurn: playerIdTurn,
        timestamp: timestamp,
      );

  factory MoveData.fromJson(Map<String, dynamic> json) =>
      _$MoveDataFromJson(json);
}

extension MoveDataExtension on Iterable<MoveData> {
  List<String> print() {
    List<String> res = [];
    for (var move in this) res.add(move.id);
    return res;
  }
}

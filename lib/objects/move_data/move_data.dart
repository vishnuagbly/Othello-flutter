import 'package:freezed_annotation/freezed_annotation.dart';
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

class UnmodifiableBoardConverter
    implements JsonConverter<List<List<int>>, List<dynamic>> {
  const UnmodifiableBoardConverter();

  @override
  List<List<int>> fromJson(List<dynamic> json) =>
      [for (final row in json) List<int>.unmodifiable((row as List).cast<int>())];

  @override
  List<dynamic> toJson(List<List<int>> object) => object;
}

@freezed
sealed class MoveData with _$MoveData {
  const MoveData._();

  const factory MoveData({
    @UnmodifiableBoardConverter() required List<List<int>> board,
    @JsonKey(readValue: _readMoveDataId) required String id,
    @DurationSecondsConverter() required Duration duration,
    required DateTime timestamp,
    required String playerIdTurn,
  }) = _MoveData;

  factory MoveData.create({
    required List<List<int>> board,
    required Duration duration,
    required String playerIdTurn,
    required DateTime timestamp,
  }) =>
      MoveData(
        board: [for (final row in board) List<int>.unmodifiable(row)],
        id: Globals.uuid.v1(),
        duration: duration,
        playerIdTurn: playerIdTurn,
        timestamp: timestamp,
      );

  factory MoveData.fromJson(Map<String, dynamic> json) =>
      _$MoveDataFromJson(json);
}

extension moveDataExtension on List<MoveData> {
  List<String> print() {
    List<String> res = [];
    for (var move in this) res.add(move.id);
    return res;
  }
}

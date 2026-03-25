import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:othello/extensions/nested_list.dart';
import 'package:othello/utils/globals.dart';

part 'move_data.freezed.dart';
part 'move_data.g.dart';

Object? _readMoveDataId(Map json, String key) =>
    json[key] ?? Globals.uuid.v1();

List<int> _flattenBoard(IList<IList<int>> board) {
  return board.expand((row) => row).toList();
}

IList<IList<int>> _fromFlatBoard(List<int> flat, int width) {
  if (width <= 0 || flat.isEmpty) return const IList.empty();
  final rows = <IList<int>>[];
  var temp = <int>[];
  for (var i = 0; i < flat.length; i++) {
    temp.add(flat[i]);
    if ((i + 1) % width == 0) {
      rows.add(temp.lock);
      temp = <int>[];
    }
  }
  return rows.lock;
}

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
  IList<IList<int>> fromJson(List<dynamic> json) {
    if (json.isEmpty) return const IList.empty();
    if (json.first is List) {
      return [for (final row in json) (row as List).cast<int>()].deepLock;
    }
    final width = json.first as int;
    final cells = json.sublist(1).cast<int>();
    return _fromFlatBoard(cells, width);
  }

  @override
  List<int> toJson(IList<IList<int>> object) {
    if (object.isEmpty) return [];
    final width = object[0].length;
    return [width, ..._flattenBoard(object)];
  }
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

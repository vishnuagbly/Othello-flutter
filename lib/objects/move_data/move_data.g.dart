// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoveData _$MoveDataFromJson(Map<String, dynamic> json) => _MoveData(
  board: const IListBoardConverter().fromJson(json['board'] as List),
  id: _readMoveDataId(json, 'id') as String,
  duration: const DurationSecondsConverter().fromJson(
    (json['duration'] as num).toInt(),
  ),
  timestamp: DateTime.parse(json['timestamp'] as String),
  playerIdTurn: json['playerIdTurn'] as String,
);

Map<String, dynamic> _$MoveDataToJson(_MoveData instance) => <String, dynamic>{
  'board': const IListBoardConverter().toJson(instance.board),
  'id': instance.id,
  'duration': const DurationSecondsConverter().toJson(instance.duration),
  'timestamp': instance.timestamp.toIso8601String(),
  'playerIdTurn': instance.playerIdTurn,
};

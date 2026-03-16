// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomData _$RoomDataFromJson(Map<String, dynamic> json) => _RoomData(
  id: json['id'] as String,
  roomType:
      $enumDecodeNullable(_$RoomTypeEnumMap, json['roomType']) ??
      RoomType.offlinePvP,
  blackPlayer: Player.fromJson(json['blackPlayer'] as Map<String, dynamic>),
  whitePlayer: Player.fromJson(json['whitePlayer'] as Map<String, dynamic>),
  length: (json['length'] as num?)?.toInt() ?? 8,
  height: (json['height'] as num?)?.toInt() ?? 8,
  playerIdTurn: json['playerIdTurn'] as String,
  currentBoard: const IListBoardConverter().fromJson(
    json['currentBoard'] as List,
  ),
  lastMoves: const IListMoveDataConverter().fromJson(
    json['lastMoves'] as List?,
  ),
  blackTotalDuration: json['blackTotalDuration'] == null
      ? Duration.zero
      : const DurationSecondsConverter().fromJson(
          (json['blackTotalDuration'] as num).toInt(),
        ),
  whiteTotalDuration: json['whiteTotalDuration'] == null
      ? Duration.zero
      : const DurationSecondsConverter().fromJson(
          (json['whiteTotalDuration'] as num).toInt(),
        ),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$RoomDataToJson(_RoomData instance) => <String, dynamic>{
  'id': instance.id,
  'roomType': _$RoomTypeEnumMap[instance.roomType]!,
  'blackPlayer': instance.blackPlayer,
  'whitePlayer': instance.whitePlayer,
  'length': instance.length,
  'height': instance.height,
  'playerIdTurn': instance.playerIdTurn,
  'currentBoard': const IListBoardConverter().toJson(instance.currentBoard),
  'lastMoves': const IListMoveDataConverter().toJson(instance.lastMoves),
  'blackTotalDuration': const DurationSecondsConverter().toJson(
    instance.blackTotalDuration,
  ),
  'whiteTotalDuration': const DurationSecondsConverter().toJson(
    instance.whiteTotalDuration,
  ),
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$RoomTypeEnumMap = {
  RoomType.offlinePvP: 'offlinePvP',
  RoomType.offlinePvC: 'offlinePvC',
  RoomType.offlineCvC: 'offlineCvC',
};

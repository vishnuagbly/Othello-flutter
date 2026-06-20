// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: _readPlayerId(json, 'playerId') as String,
  nextMoveFnId: json['nextMoveFnId'] as String?,
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'playerId': instance.id,
  'nextMoveFnId': instance.nextMoveFnId,
};

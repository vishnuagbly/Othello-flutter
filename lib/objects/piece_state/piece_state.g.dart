// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piece_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PieceState _$PieceStateFromJson(Map<String, dynamic> json) => _PieceState(
  value: (json['value'] as num).toInt(),
  possibleMove: json['possibleMove'] as bool? ?? false,
);

Map<String, dynamic> _$PieceStateToJson(_PieceState instance) =>
    <String, dynamic>{
      'value': instance.value,
      'possibleMove': instance.possibleMove,
    };

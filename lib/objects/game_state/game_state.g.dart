// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  roomData: RoomData.fromJson(json['roomData'] as Map<String, dynamic>),
  boardWidth: (json['boardWidth'] as num?)?.toDouble() ?? 0.0,
  cellWidth: (json['cellWidth'] as num?)?.toDouble() ?? 0.0,
  flipPieceStates: json['flipPieceStates'] == null
      ? const IListConst([])
      : IList<IList<FlipPieceState>>.fromJson(
          json['flipPieceStates'],
          (value) => IList<FlipPieceState>.fromJson(
            value,
            (value) => FlipPieceState.fromJson(value as Map<String, dynamic>),
          ),
        ),
  pieceStates: json['pieceStates'] == null
      ? const IListConst([])
      : IList<IList<PieceState>>.fromJson(
          json['pieceStates'],
          (value) => IList<PieceState>.fromJson(
            value,
            (value) => PieceState.fromJson(value as Map<String, dynamic>),
          ),
        ),
  autoReset: json['autoReset'] as bool? ?? false,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'roomData': instance.roomData.toJson(),
      'boardWidth': instance.boardWidth,
      'cellWidth': instance.cellWidth,
      'flipPieceStates': instance.flipPieceStates.toJson(
        (value) => value.toJson((value) => value.toJson()),
      ),
      'pieceStates': instance.pieceStates.toJson(
        (value) => value.toJson((value) => value.toJson()),
      ),
      'autoReset': instance.autoReset,
    };

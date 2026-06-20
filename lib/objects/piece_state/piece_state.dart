import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece_state.freezed.dart';
part 'piece_state.g.dart';

@freezed
sealed class PieceState with _$PieceState {
  const PieceState._();

  factory PieceState.fromBoardvalue({
    required int boardValue,
    bool? possibleMove,
  }) => PieceState(
    value: fromBoardValue(boardValue),
    possibleMove: possibleMove ?? false,
  );

  const factory PieceState({
    required int value,
    @Default(false) bool possibleMove,
  }) = _PieceState;

  factory PieceState.fromJson(Map<String, dynamic> json) =>
      _$PieceStateFromJson(json);

  static int fromBoardValue(int boardValue) => boardValue == 1 ? 2 : boardValue;

  int get boardValue {
    if (value == 0 || value == 3) return 0;
    if (value == 1 || value == 2) return 1;
    return -1;
  }

  PieceState updateFromBoardValue(int boardValue) =>
      copyWith(value: fromBoardValue(boardValue));
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flip_piece_state.freezed.dart';
part 'flip_piece_state.g.dart';

@freezed
sealed class FlipPieceState with _$FlipPieceState {
  const FlipPieceState._();

  const factory FlipPieceState({
    @Default(false) bool flipping,
  }) = _FlipPieceState;

  factory FlipPieceState.fromJson(Map<String, dynamic> json) =>
      _$FlipPieceStateFromJson(json);

  FlipPieceState flip() => copyWith(flipping: !flipping);
  FlipPieceState reset() => copyWith(flipping: false);
}

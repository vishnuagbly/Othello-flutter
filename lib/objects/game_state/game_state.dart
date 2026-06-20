import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:othello/extensions/nested_list.dart';
import 'package:othello/objects/flip_piece_state/flip_piece_state.dart';
import 'package:othello/objects/piece_state/piece_state.dart';
import 'package:othello/objects/room_data/room_data.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
sealed class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required RoomData roomData,
    @Default(0.0) double boardWidth,
    @Default(0.0) double cellWidth,
    @Default(IListConst([])) IList<IList<FlipPieceState>> flipPieceStates,
    @Default(IListConst([])) IList<IList<PieceState>> pieceStates,
    @Default(false) bool autoReset,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  GameState flip(int i, int j) {
    var newFStates = flipPieceStates.deepUnlock;
    var newPStates = pieceStates.deepUnlock;

    newFStates[i][j] = newFStates[i][j].flip();
    newPStates[i][j] = newPStates[i][j].copyWith(
      value: (newPStates[i][j].value + 1) % 4,
    );

    return copyWith(
      flipPieceStates: newFStates.deepLock,
      pieceStates: newPStates.deepLock,
    );
  }

  GameState set(int i, int j) {
    var newFStates = flipPieceStates.deepUnlock;
    var newPStates = pieceStates.deepUnlock;

    newFStates[i][j] = newFStates[i][j].reset();
    newPStates[i][j] = newPStates[i][j].copyWith(
      value: PieceState.fromBoardValue(roomData.currentBoard[i][j]),
    );

    return copyWith(
      flipPieceStates: newFStates.deepLock,
      pieceStates: newPStates.deepLock,
    );
  }
}

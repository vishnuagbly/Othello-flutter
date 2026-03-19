import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello/providers/game_state/game_state.dart';

class Piece extends ConsumerWidget {
  Piece(this.i, this.j, this.roomDataId);

  final int i;
  final int j;
  final String roomDataId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We only want to rebuild if this specific piece's state changes, or basic things like cellWidth.
    // However, cellWidth and isWhiteTurn are simple enough to just use watch on specific fields.
    final cellWidth = ref.read(
      gameStateProvider(roomDataId).select((s) => s.cellWidth),
    );
    final pieceState = ref.watch(
      gameStateProvider(roomDataId).select((s) => s.pieceStates[i][j]),
    );
    final isWhiteTurn = ref.read(
      gameStateProvider(roomDataId).select((s) => s.roomData.isWhiteTurn),
    );

    Widget child = Container();

    if (pieceState.possibleMove && pieceState.value == -1) {
      child = Center(
        child: Container(
          width: cellWidth / 2,
          height: cellWidth / 2,
          decoration: BoxDecoration(
            color: isWhiteTurn ? Colors.white54 : Colors.black54,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      );
    }
    if (pieceState.value == 0)
      child = FittedBox(
        fit: BoxFit.cover,
        child: Image.asset("assets/flip_0/frame_0.png"),
      );
    else if (pieceState.value == 2)
      child = FittedBox(
        fit: BoxFit.cover,
        child: Image.asset("assets/flip_0/frame_18.png"),
      );

    return Container(
      padding: const EdgeInsets.all(0.5),
      width: cellWidth,
      height: cellWidth,
      color: Colors.black,
      child: InkWell(
        onTap: () {
          if (pieceState.value == -1 && pieceState.possibleMove) {
            final notifier = ref.read(gameStateProvider(roomDataId).notifier);
            notifier.onTapOnPiece(i, j)();
          }
        },
        child: Container(color: Colors.green[600], child: child),
      ),
    );
  }
}

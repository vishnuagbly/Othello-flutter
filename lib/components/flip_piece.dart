import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello/providers/game_state/game_state.dart';

import 'image_sequence_animator.dart';

class FlipPiece extends ConsumerStatefulWidget {
  FlipPiece(this.i, this.j, this.roomDataId);

  final int i;
  final int j;
  final String roomDataId;

  @override
  ConsumerState<FlipPiece> createState() => FlipPieceState();
}

class FlipPieceState extends ConsumerState<FlipPiece> {
  ImageSequenceAnimatorState? _state;

  @override
  void dispose() {
    if (mounted) _state?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cellWidth = ref.read(
      gameStateProvider(widget.roomDataId).select((s) => s.cellWidth),
    );
    final flipPieceState = ref.watch(
      gameStateProvider(
        widget.roomDataId,
      ).select((s) => s.flipPieceStates[widget.i][widget.j]),
    );
    final pieceValue = ref.read(
      gameStateProvider(
        widget.roomDataId,
      ).select((s) => s.pieceStates[widget.i][widget.j].value),
    );
    final boardValue = ref.read(
      gameStateProvider(
        widget.roomDataId,
      ).select((s) => s.pieceStates[widget.i][widget.j].boardValue),
    );

    final bool flipping = flipPieceState.flipping;

    return Positioned(
      left: cellWidth * widget.j,
      top: cellWidth * widget.i - (((cellWidth * (90 / 74)) - cellWidth) / 2),
      child: IgnorePointer(
        child: flipping
            ? _flipAnimation(cellWidth, pieceValue, boardValue)
            : Container(),
      ),
    );
  }

  Widget _flipAnimation(double cellWidth, int pieceValue, int boardValue) {
    final _onFinishPlaying = (ImageSequenceAnimatorState state) {
      if (pieceValue % 2 == 0) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(gameStateProvider(widget.roomDataId).notifier)
            .set(widget.i, widget.j);
      });
    };
    return Container(
      width: cellWidth,
      height: cellWidth * (90 / 74),
      child: FittedBox(
        child: InkWell(
          child: ImageSequenceAnimator(
            boardValue == 1 ? "assets/flip_0" : 'assets/flip_1',
            "frame_",
            0,
            1,
            "png",
            19,
            fps: 50,
            key: UniqueKey(),
            waitUntilCacheIsComplete: true,
            onReadyToPlay: (state) => _state = state,
            onFinishPlaying: _onFinishPlaying,
          ),
        ),
      ),
    );
  }
}

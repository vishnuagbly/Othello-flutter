import 'package:flutter/material.dart';
import 'image_sequence_animator.dart';
import 'package:othello/components/piece.dart';

class FlipPiece extends StatefulWidget {
  FlipPiece(this.cellWidth, this.i, this.j,
      {this.onCreation, required this.getPieceStateFn});

  final double cellWidth;
  final int i;
  final int j;
  final Function(FlipPieceState state)? onCreation;
  final PieceState Function() getPieceStateFn;

  @override
  FlipPieceState createState() => FlipPieceState();
}

class FlipPieceState extends State<FlipPiece> {
  bool flipping = false;
  ImageSequenceAnimatorState? _state;

  void flip() {
    _flipStateFn();
    _pieceState.stateFn();
  }

  @override
  void initState() {
    (widget.onCreation ?? (_) {})(this);
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) _state?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.cellWidth * widget.j,
      top: widget.cellWidth * widget.i -
          (((widget.cellWidth * (90 / 74)) - widget.cellWidth) / 2),
      child: IgnorePointer(
        child: flipping ? _flipAnimation() : Container(),
      ),
    );
  }

  Widget _flipAnimation() {
    final _onFinishPlaying = (ImageSequenceAnimatorState state) {
      if (_pieceState.value % 2 == 0) return;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _flipStateFn();
        _pieceState.stateFn();
      });
    };
    return Container(
      width: widget.cellWidth,
      height: widget.cellWidth * (90 / 74),
      child: FittedBox(
        child: InkWell(
          child: ImageSequenceAnimator(
            _pieceState.boardValue == 1 ? "assets/flip_0" : 'assets/flip_1',
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

  void _flipStateFn({operate = true}) {
    if (operate) flipping = !flipping;
    if (!mounted) return;
    setState(() {});
  }

  void set() {
    if (!mounted) return;
    flipping = false;
    setState(() {});
  }

  PieceState get _pieceState => widget.getPieceStateFn();
}

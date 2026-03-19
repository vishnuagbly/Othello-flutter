import 'package:flutter/material.dart';
import 'package:othello/objects/piece_state/piece_state.dart' as objects;

class Piece extends StatefulWidget {
  Piece(
    this.cellWidth, {
    this.onCreation,
    this.initValue = -1,
    this.onTap,
    this.isWhiteTurn,
  });

  final void Function(PieceState state)? onCreation;
  final void Function(PieceState state)? onTap;
  final double cellWidth;
  final int initValue;
  final bool Function()? isWhiteTurn;

  @override
  PieceState createState() => PieceState(initValue);
}

class PieceState extends State<Piece> {
  PieceState(int value)
    : pieceState = objects.PieceState.fromBoardvalue(boardValue: value);

  objects.PieceState pieceState;

  int get boardValue => pieceState.boardValue;
  int get value => pieceState.value;
  bool get possibleMove => pieceState.possibleMove;

  set possibleMove(bool val) {
    pieceState = pieceState.copyWith(possibleMove: val);
  }

  @override
  void initState() {
    (widget.onCreation ?? (_) {})(this);
    super.initState();
  }

  void stateFn({bool operate = true}) {
    if (!mounted) return;
    setState(() {
      if (operate)
        pieceState = pieceState.copyWith(value: (pieceState.value + 1) % 4);
    });
  }

  void set(int boardValue) {
    if (!mounted) return;
    setState(() {
      pieceState = pieceState.updateFromBoardValue(boardValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    if (possibleMove && value == -1) {
      final whiteTurn = widget.isWhiteTurn?.call() ?? true;
      child = Center(
        child: Container(
          width: widget.cellWidth / 2,
          height: widget.cellWidth / 2,
          decoration: BoxDecoration(
            color: whiteTurn ? Colors.white54 : Colors.black54,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      );
    }
    if (value == 0)
      child = FittedBox(
        fit: BoxFit.cover,
        child: Image.asset("assets/flip_0/frame_0.png"),
      );
    else if (value == 2)
      child = FittedBox(
        fit: BoxFit.cover,
        child: Image.asset("assets/flip_0/frame_18.png"),
      );
    return Container(
      padding: const EdgeInsets.all(0.5),
      width: widget.cellWidth,
      height: widget.cellWidth,
      color: Colors.black,
      child: InkWell(
        onTap: () {
          if (value == -1 && possibleMove && widget.onTap != null) {
            widget.onTap!(this);
          }
        },
        child: Container(color: Colors.green[600], child: child),
      ),
    );
  }
}

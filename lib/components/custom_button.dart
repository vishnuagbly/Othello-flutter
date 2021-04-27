import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/utils/globals.dart';

import 'image_sequence_animator.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    required this.text,
    required this.onPressed,
    this.width,
    this.white = true,
  });

  final String text;
  final void Function() onPressed;
  final bool white;
  final double? width;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _flipping = false;
  bool _executedOnPressedFn = false;
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Globals.maxScreenWidth * 0.16,
          padding: EdgeInsets.only(
            left: Globals.maxScreenWidth * 0.1,
            top: Globals.maxScreenWidth * 0.041,
            bottom: Globals.maxScreenWidth * 0.041,
          ),
          child: ElevatedButton(
            key: _key,
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.zero,
                textStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: Globals.maxScreenWidth * 0.04,
                  fontWeight: FontWeight.w700,
                )),
            onPressed: () {
              setState(() {
                _flipping = true;
                _executedOnPressedFn = false;
              });
            },
            child: Container(
              width: widget.width,
              padding: EdgeInsets.fromLTRB(
                Globals.maxScreenWidth * 0.025,
                Globals.maxScreenWidth * 0.015,
                8,
                Globals.maxScreenWidth * 0.015,
              ),
              child: widget.width != null
                  ? Center(child: Text(widget.text))
                  : Text(widget.text),
            ),
          ),
        ),
        Positioned(
            top: 0,
            bottom: 0,
            child: Container(
              height: Globals.maxScreenWidth * 0.13,
              width: Globals.maxScreenWidth * 0.13,
              child: FittedBox(
                child: _flipping
                    ? ImageSequenceAnimator(
                        widget.white ? "assets/flip_0" : "assets/flip_1",
                        "frame_",
                        0,
                        1,
                        "png",
                        19,
                        fps: 50,
                        key: UniqueKey(),
                        waitUntilCacheIsComplete: true,
                        onFinishPlaying: (state) {
                          if (!_executedOnPressedFn) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              setState(() {
                                _flipping = false;
                              });
                            });
                            widget.onPressed();
                            _executedOnPressedFn = true;
                          }
                        },
                      )
                    : Image.asset(
                        widget.white
                            ? "assets/flip_0/frame_0.png"
                            : "assets/flip_1/frame_0.png",
                      ),
              ),
            )),
      ],
    );
  }
}

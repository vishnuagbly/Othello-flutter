import 'package:flutter/material.dart';

import 'package:bubble/bubble.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({required this.isSender, required this.showNip});

  final bool isSender;
  final bool showNip;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Bubble(
        showNip: showNip,
        nip: isSender ? BubbleNip.rightTop : BubbleNip.leftTop,
        child: Text(
          'hello adfadsfadsf\naljsdf ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        color: isSender ? Colors.grey : Colors.white,
      ),
    );
  }
}

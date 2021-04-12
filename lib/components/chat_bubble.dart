import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bubble/bubble.dart';
import 'package:othello/objects/chat_message.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({required this.isSender, required this.showNip, required this.message});

  final bool isSender;
  final bool showNip;
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Bubble(
        showNip: showNip,
        nip: isSender ? BubbleNip.rightTop : BubbleNip.leftTop,
        child: Text(
          message.msg,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        color: isSender ? Colors.grey : Colors.white,
        margin: const BubbleEdges.only(bottom: 10),
      ),
    );
  }
}

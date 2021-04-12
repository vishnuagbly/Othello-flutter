import 'package:flutter/material.dart';
import 'package:othello/components/chat_box_widget.dart';
import 'package:othello/components/chat_bubble.dart';
import 'package:othello/objects/room_data.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late RoomData _roomData;

  @override
  Widget build(BuildContext context) {
    _roomData = ModalRoute.of(context)?.settings.arguments as RoomData;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/chat_bg.jpg',
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${_roomData.id}'),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                child: ChatBubble(
                  isSender: true,
                  showNip: true,
                ),
              ),
            ),
            ChatBoxWidget(_roomData),
          ],
        ),
      ),
    );
  }
}

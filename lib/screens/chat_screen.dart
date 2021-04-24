import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:othello/components/chat_box_widget.dart';
import 'package:othello/components/chat_bubble.dart';
import 'package:othello/objects/chat_message.dart';
import 'package:othello/objects/room_data.dart';
import 'package:othello/utils/networks.dart';

late User currentUser;
final _controller = ScrollController();

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late RoomData _roomData;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    currentUser = auth.currentUser!;
  }

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
          title: Text('Chat'),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: ChatsListView(_roomData),
              ),
            ),
            ChatBoxWidget(_roomData),
          ],
        ),
      ),
    );
  }
}

class ChatsListView extends StatelessWidget {
  ChatsListView(this._roomData);
  final RoomData _roomData;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Networks.roomStream(_roomData.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final _streamRoomData = RoomData.fromMap(snapshot.data!.data()!);
          final List<ChatMessage> _chats = _streamRoomData.chats;
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (_controller.hasClients) {
              _controller.jumpTo(_controller.position.maxScrollExtent);
            } else {}
          });
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: _chats.length,
            physics: BouncingScrollPhysics(),
            controller: _controller,
            itemBuilder: (_, index) {
              return ChatBubble(
                isSender: _checkIsSender(_chats[index].uid),
                showNip: index < 1
                    ? true
                    : _checkShowNip(
                        _chats[index - 1].uid,
                        _chats[index].uid,
                      ),
                message: _chats[index],
              );
            },
          );
        });
  }
}

bool _checkIsSender(String uid) {
  return uid == currentUser.uid ? true : false;
}

bool _checkShowNip(String uid1, String uid2) {
  return uid1 == uid2 ? false : true;
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:othello/objects/chat_message.dart';
import 'package:othello/objects/room_data.dart';
import 'package:othello/utils/globals.dart';
import 'package:othello/utils/networks.dart';

class ChatBoxWidget extends StatefulWidget {
  ChatBoxWidget(this._roomData, this.scrollController);
  final RoomData _roomData;
  final ScrollController scrollController;
  @override
  _ChatBoxWidgetState createState() => _ChatBoxWidgetState();
}

class _ChatBoxWidgetState extends State<ChatBoxWidget> {
  TextEditingController chatController = TextEditingController();
  late ChatMessage _chatMessage;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    currentUser = auth.currentUser!;
  }

  Future _sendMessage() async {
    FocusScope.of(context).unfocus();
    _chatMessage = ChatMessage(
      msg: chatController.value.text.trim(),
      uid: currentUser.uid,
      timestamp: DateTime.now(),
    );
    chatController.clear();
    try {
      await Networks.sendMessage(_chatMessage, widget._roomData.id);
    } catch (e) {
      throw e;
    }
    widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Globals.screenWidth,
      height: Globals.screenHeight * 0.1,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                fillColor: Colors.black45,
                filled: true,
              ),
              cursorColor: Theme.of(context).primaryColor,
              cursorHeight: 23,
              maxLines: 3,
              minLines: 1,
              controller: chatController,
              textInputAction: TextInputAction.newline,
            ),
          ),
          SizedBox(
            width: Globals.screenWidth * 0.02,
          ),
          FloatingActionButton(
            child: Icon(Icons.send_rounded),
            isExtended: true,
            foregroundColor: Colors.white,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

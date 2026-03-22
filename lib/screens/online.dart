import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/screens/room_list.dart';

class OnlineScreen extends ConsumerWidget {
  static const kPath = '/online/rooms';

  const OnlineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoomListScreen(roomType: RoomType.onlinePvP);
  }
}

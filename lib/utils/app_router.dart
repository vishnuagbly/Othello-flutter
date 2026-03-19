import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:othello/extensions/widget.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/screens/game_room.dart';
import 'package:othello/screens/main_menu.dart';
import 'package:othello/screens/online.dart';
import 'package:othello/screens/room_list.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainMenu()),
    GoRoute(
      path: '/game_room/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GameRoomGate(key: ValueKey(id), roomDataId: id);
      },
    ),
    GoRoute(
      path: '/rooms/:type',
      builder: (context, state) {
        final typeStr = state.pathParameters['type']!;
        final type = RoomType.values.byName(typeStr);
        return RoomListScreen(roomType: type);
      },
    ),
    GoRoute(
      path: OnlineScreen.kPath,
      builder: (context, state) => OnlineScreen().userSafe,
    ),
  ],
);

import 'package:go_router/go_router.dart';
import 'package:othello/objects/room_data.dart';
import 'package:othello/screens/chat_screen.dart';
import 'package:othello/screens/enter_room.dart';
import 'package:othello/screens/enter_name.dart';
import 'package:othello/screens/game_room.dart';
import 'package:othello/screens/main_menu.dart';
import 'package:othello/screens/online_rooms.dart';
import 'package:othello/screens/phone_input_screen.dart';
import 'package:othello/screens/signup_screen.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainMenu(),
    ),
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: PhoneInputScreen.routeName,
      builder: (context, state) => PhoneInputScreen(),
    ),
    GoRoute(
      path: GameRoom.offlinePvCRouteName,
      builder: (context, state) => GameRoom.offlinePvC(),
    ),
    GoRoute(
      path: GameRoom.offlinePvPRouteName,
      builder: (context, state) => GameRoom.offlinePvP(),
    ),
    GoRoute(
      path: '${GameRoom.fromKeyRouteName}/:key',
      builder: (context, state) {
        final key = state.pathParameters['key']!;
        return GameRoom.fromKey(key);
      },
    ),
    GoRoute(
      path: OnlineRooms.routeName,
      builder: (context, state) => OnlineRooms(),
    ),
    GoRoute(
      path: EnterName.routeName,
      builder: (context, state) => EnterName(),
    ),
    GoRoute(
      path: '${OnlineRooms.routeName}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EnterRoom(id);
      },
    ),
    GoRoute(
      path: ChatScreen.routeName,
      builder: (context, state) => ChatScreen(roomData: state.extra as RoomData),
    ),
  ],
);

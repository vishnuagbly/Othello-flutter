import 'package:go_router/go_router.dart';
import 'package:othello/screens/game_room.dart';
import 'package:othello/screens/main_menu.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainMenu(),
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
  ],
);

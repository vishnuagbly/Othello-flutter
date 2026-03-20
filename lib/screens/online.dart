import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello/providers/user/users.dart';

class OnlineScreen extends ConsumerWidget {
  static const kPath = '/online/rooms';

  const OnlineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Online'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                ref.read(usersProvider.notifier).logout();
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            "Online play is currently unavailable.\nPlease check back later.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

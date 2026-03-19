import 'package:flutter/material.dart';

class OnlineScreen extends StatelessWidget {
  static const kPath = '/online/rooms';

  const OnlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Online')),
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

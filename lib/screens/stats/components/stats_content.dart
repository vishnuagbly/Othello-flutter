import 'package:flutter/material.dart';

/// Actual Android-only stats content.
///
/// This widget is only ever built on Android (see [StatsScreen]), so it is the
/// safe place to import and use Android-only plugins.
class StatsContent extends StatelessWidget {
  const StatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Stats',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

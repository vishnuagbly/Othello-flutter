import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/screens/logs/logs.dart';

import 'components/stats_content.dart';
import 'components/unsupported_platform_view.dart';

class StatsScreen extends StatelessWidget {
  static const kPath = '/stats';

  static const kStatsCode = '-00-';

  const StatsScreen({super.key});

  static bool get _isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('Stats', style: GoogleFonts.montserrat()),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'Background logs',
              icon: const Icon(Icons.receipt_long),
              onPressed: () => context.push(LogsScreen.kPath),
            ),
          ],
        ),
        body: _isSupported
            ? const StatsContent()
            : const UnsupportedPlatformView(),
      ),
    );
  }
}

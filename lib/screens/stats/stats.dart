import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/stats_content.dart';
import 'components/unsupported_platform_view.dart';

class StatsScreen extends StatelessWidget {
  static const kPath = '/stats';

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
        ),
        body: _isSupported
            ? const StatsContent()
            : const UnsupportedPlatformView(),
      ),
    );
  }
}

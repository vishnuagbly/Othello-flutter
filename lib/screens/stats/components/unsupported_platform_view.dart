import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnsupportedPlatformView extends StatelessWidget {
  const UnsupportedPlatformView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.phonelink_erase_outlined,
              size: 72,
              color: Colors.white54,
            ),
            const SizedBox(height: 24),
            Text(
              'Not available on this platform',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Stats are only supported on Android for now.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

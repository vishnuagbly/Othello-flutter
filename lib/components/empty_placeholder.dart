import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A scrollable, centered empty-state placeholder (icon + message).
///
/// Backed by a scrollable [ListView] so it can be dropped inside a
/// [RefreshIndicator] and still allow pull-to-refresh when there's no content.
class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    required this.icon,
    required this.message,
    this.iconColor = Colors.white24,
    this.textColor = Colors.white54,
    this.iconSize = 64,
    this.topSpacingFactor = 0.3,
  });

  final IconData icon;
  final String message;
  final Color iconColor;
  final Color textColor;
  final double iconSize;

  /// Fraction of the viewport height used as top padding before the icon.
  final double topSpacingFactor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * topSpacingFactor),
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(height: 16),
        Center(
          child: Text(
            message,
            style: GoogleFonts.montserrat(color: textColor),
          ),
        ),
      ],
    );
  }
}

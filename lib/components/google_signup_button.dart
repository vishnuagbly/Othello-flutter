import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/providers/google_sign_in.dart';
import 'package:othello/utils/globals.dart';

class GoogleSignupButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        onPressed: () {
          ref.read(googleSignInProvider.notifier).login();
        },
        icon: FaIcon(
          FontAwesomeIcons.google,
          color: Colors.white,
          size: Globals.maxScreenWidth * 0.05,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10),
            Text(
              'Sign In With Google',
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: Colors.red,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: Globals.maxScreenWidth * 0.045,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

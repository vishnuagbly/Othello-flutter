import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/providers/google_sign_in.dart';
import 'package:othello/utils/globals.dart';
import 'package:provider/provider.dart';

class GoogleSignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.login();
        },
        icon: FaIcon(
          FontAwesomeIcons.google,
          color: Colors.white,
          size: Globals.maxScreenWidth * 0.05,
        ),
        label: Text(
          'Sign In With Google',
        ),
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: Colors.red,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: Globals.maxScreenWidth * 0.04,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          primary: Colors.white,
        ),
      ),
    );
  }
}

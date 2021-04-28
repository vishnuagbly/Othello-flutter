import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/screens/phone_input_screen.dart';
import 'package:othello/utils/globals.dart';

class PhoneSignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed(PhoneInputScreen.routeName);
        },
        icon: FaIcon(
          FontAwesomeIcons.phoneAlt,
          color: Colors.white,
          size: Globals.maxScreenWidth * 0.05,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10),
            Text(
              'Sign In With Phone',
            ),
          ]
        ),
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: Colors.green,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: Globals.maxScreenWidth * 0.045,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          primary: Colors.white,
        ),
      ),
    );
  }
}

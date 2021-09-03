import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/components/google_signup_button.dart';
import 'package:othello/components/phone_signup_button.dart';
import 'package:othello/utils/globals.dart';

import 'game_room.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up-screen';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/othello-background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Othello",
                  style: GoogleFonts.montserrat(
                    fontSize: Globals.maxScreenWidth * 0.17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: Globals.maxScreenWidth * 0.8,
                  constraints: BoxConstraints(
                    maxHeight: Globals.screenHeight * 0.5,
                  ),
                  child: FittedBox(
                    child: GameRoom.offlineCvC(),
                  ),
                ),
                SizedBox(height: 30),
                GoogleSignupButton(),
                SizedBox(height: 10),
                PhoneSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

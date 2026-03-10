import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/components/custom_button.dart';
import 'package:othello/screens/game_room.dart';
import 'package:othello/utils/globals.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Globals.setMediaQueryData(context);
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
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: "vs Computer",
                      onPressed: () {
                        context.push(GameRoom.offlinePvCRouteName);
                      },
                      width: Globals.maxScreenWidth * 0.34,
                    ),
                    SizedBox(width: Globals.maxScreenWidth * 0.06),
                    CustomButton(
                      text: "Pass N Play",
                      onPressed: () {
                        context.push(GameRoom.offlinePvPRouteName);
                      },
                      width: Globals.maxScreenWidth * 0.34,
                      white: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

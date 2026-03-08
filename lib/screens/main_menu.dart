import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/components/custom_button.dart';
import 'package:othello/components/side_drawer.dart';
import 'package:othello/objects/profile.dart';
import 'package:othello/screens/game_room.dart';
import 'package:othello/screens/signup_screen.dart';
import 'package:othello/utils/globals.dart';

import 'online_rooms.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      this.user = user;
      context.go('/');
      await Profile.setProfile(context, user);
    });
    super.initState();
  }

  Widget get _onlineButton => CustomButton(
        onPressed: () async {
          if (user == null)
            context.push(SignUpScreen.routeName);
          else
            context.push(OnlineRooms.routeName);
        },
        width: Globals.maxScreenWidth * 0.34,
        text: 'Online',
      );

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
        drawer: SideDrawer(),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        if (Globals.screenWidth > Globals.screenHeight) ...[
                          SizedBox(width: Globals.maxScreenWidth * 0.06),
                          _onlineButton,
                        ]
                      ],
                    ),
                    if (Globals.screenWidth <= Globals.screenHeight)
                      _onlineButton,
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

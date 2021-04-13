import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
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
      Navigator.popUntil(context, ModalRoute.withName('/'));
      await Profile.setProfile(context, user);
    });
    initDynamicLinks();
    super.initState();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final deepLink = dynamicLink?.link;
      print("got link: $deepLink");

      if (deepLink != null) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.pushNamed(context, deepLink.fragment);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

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
                            Navigator.pushNamed(
                                context, GameRoom.offlinePvCRouteName);
                          },
                          width: Globals.maxScreenWidth * 0.3,
                        ),
                        SizedBox(width: Globals.maxScreenWidth * 0.06),
                        CustomButton(
                          text: "Pass N Play",
                          onPressed: () {
                            Navigator.pushNamed(
                                context, GameRoom.offlinePvPRouteName);
                          },
                          width: Globals.maxScreenWidth * 0.3,
                          white: false,
                        ),
                      ],
                    ),
                    CustomButton(
                      onPressed: () async {
                        if (user == null)
                          Navigator.pushNamed(context, SignUpScreen.routeName);
                        else
                          Navigator.pushNamed(context, OnlineRooms.routeName);
                      },
                      width: Globals.maxScreenWidth * 0.3,
                      text: 'Online',
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

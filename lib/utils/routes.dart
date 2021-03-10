import 'package:flutter/cupertino.dart';
import 'package:othello/main.dart';
import 'package:othello/screens/home_page.dart';
import 'package:othello/screens/signup_screen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (_) => MainPage(),
  SignUpScreen.routeName: (_) => SignUpScreen(),
};

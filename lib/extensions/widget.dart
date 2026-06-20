import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello/providers/user/users.dart';
import 'package:othello/screens/login.dart';

extension WidgetExt on Widget {
  Widget get userSafe => Consumer(
    builder: (context, ref, child) {
      if (!ref.watch(isLoggedInProvider)) {
        return LoginScreen();
      }
      return this;
    },
  );
}

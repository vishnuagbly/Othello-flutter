import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:othello/objects/profile.dart';

class GoogleSignInProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn(
    params: const GoogleSignInParams(
      scopes: ['openid', 'email', 'profile'],
    ),
  );
  final auth = FirebaseAuth.instance;
  late bool _isSigningIn;

  Profile? get profile => profile;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set setSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    _isSigningIn = true;

    final credentials = await googleSignIn.signIn();

    if (credentials == null) {
      setSigningIn = false;
      return;
    } else {
      final credential = GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      setSigningIn = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}

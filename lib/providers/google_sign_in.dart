import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_sign_in.g.dart';

@Riverpod(keepAlive: true)
class GoogleSignInNotifier extends _$GoogleSignInNotifier {
  final _googleSignIn = GoogleSignIn(
    params: const GoogleSignInParams(
      scopes: ['openid', 'email', 'profile'],
    ),
  );

  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  bool build() => false;

  Future<void> login() async {
    state = true;

    final credentials = await _googleSignIn.signIn();

    if (credentials == null) {
      state = false;
      return;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: credentials.accessToken,
      idToken: credentials.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    state = false;
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}

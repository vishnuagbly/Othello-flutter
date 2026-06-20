import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import '../secrets.dart';

final GoogleSignIn kGoogleSignIn = GoogleSignIn(
  params: const GoogleSignInParams(
    clientId: kGoogleClientId,
    clientSecret: kGoogleSecret,
    scopes: ['openid', 'profile', 'email'],
  ),
);

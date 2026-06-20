import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:googleapis/people/v1.dart' as people;
import 'package:othello/components/custom_button.dart';
import 'package:othello/providers/user/users.dart';
import 'package:othello/utils/globals.dart';
import 'package:othello/utils/google_sign_in.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _fetchingPerson = false;

  @override
  void initState() {
    /* Recommended to call lightweightSignIn to follow the officially recommended flow.
    We can also do something like this:
    ```dart
    (await kGoogleSignIn.silentSignIn()) ?? await kGoogleSignIn.lightweightSignIn();
    ```

    This will ensure in case the saved token is expired, it goes through the official
    recommended flow, for refreshing the token.
    */
    kGoogleSignIn.silentSignIn();
    kGoogleSignIn.authenticationState.listen(_signInListener);
    super.initState();
  }

  Future<void> _signInListener(GoogleSignInCredentials? creds) async {
    if (creds == null || !mounted) return;
    if (ref.read(isLoggedInProvider)) return;

    setState(() => _fetchingPerson = true);
    try {
      final person = await _fetchPerson();
      if (mounted) await ref.read(usersProvider.notifier).login(person);
      debugPrint('Fetched person: ${person.names?.firstOrNull?.displayName}');
    } catch (e) {
      debugPrint('Error fetching person: $e');
    } finally {
      if (mounted) setState(() => _fetchingPerson = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Globals.setMediaQueryData(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/othello-background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Othello",
                    style: GoogleFonts.montserrat(
                      fontSize: Globals.maxScreenWidth * 0.17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Login to play online",
                    style: GoogleFonts.montserrat(
                      fontSize: Globals.maxScreenWidth * 0.05,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Recommended to subscribe to authenticatedState to check sign-in state
                  StreamBuilder<GoogleSignInCredentials?>(
                    stream: kGoogleSignIn.authenticationState,
                    builder: (context, snapshot) {
                      final isSignedIn = snapshot.data != null;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_fetchingPerson)
                            const CircularProgressIndicator()
                          else if (isSignedIn)
                            Column(
                              children: [
                                Text(
                                  'Signed In',
                                  style: GoogleFonts.montserrat(
                                    fontSize: Globals.maxScreenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: 'Sign Out',
                                  onPressed: kGoogleSignIn.signOut,
                                  width: Globals.maxScreenWidth * 0.4,
                                  white: false,
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                Text(
                                  'Not Signed In',
                                  style: GoogleFonts.montserrat(
                                    fontSize: Globals.maxScreenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white54,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                if (kIsWeb)
                                  kGoogleSignIn.signInButton() ??
                                      const SizedBox.shrink()
                                else
                                  CustomButton(
                                    text: 'Sign In via Google',
                                    onPressed: kGoogleSignIn.signIn,
                                    width: Globals.maxScreenWidth * 0.6,
                                    backgroundColor: Colors.deepOrangeAccent,
                                  ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// An example for how to use googleapis with the plugin.
  Future<people.Person> _fetchPerson() async {
    final authClient = await kGoogleSignIn.authenticatedClient;

    if (authClient == null) {
      throw Exception('Failed to get authenticated client');
    }

    final peopleApi = people.PeopleServiceApi(authClient);

    final person = await peopleApi.people.get(
      'people/me',
      personFields: 'names,emailAddresses,photos',
    );

    return person;
  }
}

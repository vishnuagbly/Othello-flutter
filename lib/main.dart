import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:othello/utils/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('Rooms');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(Phoenix(child: ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Othello Game',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.brown,
        scaffoldBackgroundColor: Colors.black,
        floatingActionButtonTheme:
            ThemeData.dark().floatingActionButtonTheme.copyWith(
                  backgroundColor: Colors.brown,
                ),
      ),
      routerConfig: goRouter,
    );
  }
}

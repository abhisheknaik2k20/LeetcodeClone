import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/blackscreen.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/homescreen.dart';
import 'package:leetcodeclone/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:leetcodeclone/Welcome/welcome.dart';
import 'package:leetcodeclone/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: user == null
          ? const WelcomeScreen()
          : LeetCodeProblemsetHomescreen(size: MediaQuery.sizeOf(context)),
    );
  }
}

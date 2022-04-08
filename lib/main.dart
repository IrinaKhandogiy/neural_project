import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neural_project/firebase_components/firebase_options.dart';
import 'package:neural_project/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authorization/auth.dart';
import 'firebase_components/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neural App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const HomePage(title: "Neural App | Home")
          : const AuthPage(title: 'Neural App | Auth'),
    );
  }
}

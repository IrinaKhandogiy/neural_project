import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neural_project/home.dart';
import 'package:neural_project/reset_password.dart';
import 'package:neural_project/results.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  FirebaseAuth.instance.currentUser!=null? const HomePage(title:"Neural App | Home"): const AuthPage(title: 'Neural App | Auth'),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isEmailValid = true;
  String emailError = "";
  bool isPasswordValid = true;
  String passwordError = "";


  @override
  void dispose() {
   emailController.dispose();
   passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(title: 'Neural App | Home',)));
  }
  
  void _navigateToResetPasswordScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage(title: 'Neural App | Reset Password',)));
  }

  signIn() async {
    isPasswordValid = true;
    isEmailValid = true;
    if(passwordController.text.isEmpty) {
      isPasswordValid = false;
      passwordError = "Пароль обязателен";
    }
    if(emailController.text.isEmpty) {
      isEmailValid = false;
      emailError = "Email обязателен";
    }
    if(!isEmailValid || !isPasswordValid) {
      setState(() {
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      var uid = userCredential.user?.uid;
      if(uid==null) {
        return;
      }
      _navigateToNextScreen(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        emailError = "Пользователя не существует";
        isEmailValid = false;
      } else if (e.code == 'wrong-password') {
        passwordError = "Неверный пароль";
        isPasswordValid = false;
      } else if (e.code == 'invalid-email') {
        emailError="Неверный формат email";
        isEmailValid = false;
      } else if (e.code == 'network-request-failed') {
        emailError = "Отсутствует подключение к сети";
        isEmailValid = false;
      }
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF222222),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.2), bottom: 42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
            padding: const EdgeInsets.only(left: 39, right: 39),
            child: Column(
            children: [
            Text(
              'Авторизация',
              style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)
            ),
            CupertinoFormRow(
              padding: const EdgeInsets.only(top: 48),
              child: CupertinoTextField(
                textInputAction: TextInputAction.next,
                controller: emailController,
                padding: const EdgeInsets.only(top: 14, bottom: 13, left: 18),
                placeholder: 'Адрес электронной почты',
                  clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                  decoration: const BoxDecoration(
                    color:  Color(0xFF222222),
                    border:  Border(
                      top: BorderSide(width: 2, color: Colors.white),
                      left: BorderSide(width: 2, color: Colors.white),
                      right: BorderSide(width: 2, color: Colors.white),
                      bottom: BorderSide(width: 2, color: Colors.white),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                  placeholderStyle: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white)
              ),
              error: Text(isEmailValid? "": emailError),
            ),
            CupertinoFormRow(
              padding: const EdgeInsets.only(top: 20),
              child: CupertinoTextField(
                textInputAction: TextInputAction.next,
                restorationId: 'login_password_text_field',
                controller: passwordController,
                placeholder: 'Пароль',
                padding: const EdgeInsets.only(top: 14, bottom: 13, left: 18),
                clearButtonMode: OverlayVisibilityMode.editing,
                obscureText: true,
                autocorrect: false,
                decoration: const BoxDecoration(
                    color:  Color(0xFF222222),
                    border:  Border(
                      top: BorderSide(width: 2, color: Colors.white),
                      left: BorderSide(width: 2, color: Colors.white),
                      right: BorderSide(width: 2, color: Colors.white),
                      bottom: BorderSide(width: 2, color: Colors.white),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                placeholderStyle: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
              ),
              error: Text(isPasswordValid? "": passwordError),
            ),
            Container(
              margin: const EdgeInsets.only(top: 48),
              child: Row (
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonTheme(
                      minWidth: 118,
                      height: 47,
                      child: OutlinedButton(
                      onPressed: () => {signIn()},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(118, 47),
                          side: const BorderSide(
                              color: Color(0xFF336CB2),
                              width: 2,
                              style: BorderStyle.solid
                          ),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                      child: Text(
                      "Войти",
                      style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF307EDE)),
                    ),
                  )
                  ),
                  CupertinoButton(child: Text(
                    "Восстановить пароль",
                    style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400, color: const Color.fromRGBO(255, 255, 255, 0.75)),
                  ), onPressed: () => {_navigateToResetPasswordScreen(context)},
                    padding: const EdgeInsets.only(left: 51),
                  )
                ],
              ),
            )
          ],
        )),
          Image.asset('assets/background_image.png')
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

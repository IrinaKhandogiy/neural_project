import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neural_project/theme/theme_const.dart';

import '../home.dart';
import 'reset_password.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isEmailValid = true;
  bool isPasswordValid = true;
  String emailError = "";
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(
              title: 'Neural App | Home',
            )));
  }

  void _navigateToResetPasswordScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ResetPasswordPage(
              title: 'Neural App | Reset Password',
            )));
  }

  signIn() async {
    isPasswordValid = true;
    isEmailValid = true;
    if (passwordController.text.isEmpty) {
      isPasswordValid = false;
      passwordError = "Пароль обязателен";
    }
    if (emailController.text.isEmpty) {
      isEmailValid = false;
      emailError = "Email обязателен";
    }
    if (!isEmailValid || !isPasswordValid) {
      setState(() {});
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      var uid = userCredential.user?.uid;
      if (uid == null) {
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
        emailError = "Неверный формат email";
        isEmailValid = false;
      } else if (e.code == 'network-request-failed') {
        emailError = "Отсутствует подключение к сети";
        isEmailValid = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BACKGROUND_COLOR,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height * 0.2), bottom: 42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Text('Авторизация',
                        style: GoogleFonts.openSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    CupertinoFormRow(
                      padding: const EdgeInsets.only(top: 48),
                      child: CupertinoTextField(
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          padding: const EdgeInsets.only(
                              top: 14, bottom: 13, left: 18),
                          placeholder: 'Адрес электронной почты',
                          clearButtonMode: OverlayVisibilityMode.editing,
                          autocorrect: false,
                          decoration: const BoxDecoration(
                              color: Color(0xFF222222),
                              border: Border(
                                top: BorderSide(width: 2, color: Colors.white),
                                left: BorderSide(width: 2, color: Colors.white),
                                right:
                                    BorderSide(width: 2, color: Colors.white),
                                bottom:
                                    BorderSide(width: 2, color: Colors.white),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          placeholderStyle: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                      error: Text(isEmailValid ? "" : emailError),
                    ),
                    CupertinoFormRow(
                      padding: const EdgeInsets.only(top: 20),
                      child: CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'login_password_text_field',
                        controller: passwordController,
                        placeholder: 'Пароль',
                        padding: const EdgeInsets.only(
                            top: 14, bottom: 13, left: 18),
                        clearButtonMode: OverlayVisibilityMode.editing,
                        obscureText: true,
                        autocorrect: false,
                        decoration: const BoxDecoration(
                            color: Color(0xFF222222),
                            border: Border(
                              top: BorderSide(width: 2, color: Colors.white),
                              left: BorderSide(width: 2, color: Colors.white),
                              right: BorderSide(width: 2, color: Colors.white),
                              bottom: BorderSide(width: 2, color: Colors.white),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        placeholderStyle: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      error: Text(isPasswordValid ? "" : passwordError),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 48),
                      child: Row(
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
                                      style: BorderStyle.solid),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                child: Text(
                                  "Войти",
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF307EDE)),
                                ),
                              )),
                          Spacer(),
                          CupertinoButton(
                            child: Text(
                              "Восстановить пароль",
                              style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(
                                      255, 255, 255, 0.75)),
                            ),
                            onPressed: () =>
                                {_navigateToResetPasswordScreen(context)},
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

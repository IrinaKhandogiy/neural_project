import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neural_project/main.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  bool isEmailValid = true;
  String emailError = "";

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _navigateToAuthScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthPage(title: 'Neural App | Auth',)));
  }


  resetPassword() async {
    isEmailValid = true;
    if (emailController.text.isEmpty) {
      isEmailValid = false;
      emailError = "Email обязателен";
    }
    if (!isEmailValid) {
      setState(() {});
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      _navigateToAuthScreen(context);
    } on FirebaseAuthException catch (e) {
    print(e);
    if (e.code == 'user-not-found') {
    emailError = "Пользователя не существует";
    isEmailValid = false;
    } else if (e.code == 'invalid-email') {
    emailError="Неверный формат email";
    isEmailValid = false;
    } else if (e.code == 'network-request-failed') {
      emailError = "Отсутствует подключение к сети";
      isEmailValid = false;
    }
    setState(() {
      
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF222222),
      body: Stack(
        children: [
          Positioned(child: Image.asset("assets/background_image.png"), bottom: 42,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only( top: 109),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Восстановление пароля",
                style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                child: CupertinoFormRow(
                  padding: const EdgeInsets.only(top: 62),
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
                ),
                   SizedBox(
                     width: MediaQuery.of(context).size.width * 0.85,
                     child: Text("На вашу почту будет отправлено письмо для сброса пароля",
                       style: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),),
                    ),

                Container(
                  margin: const EdgeInsets.only(top: 48),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => {resetPassword()},
                        child:  Text("Восстановить пароль",
                            style: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w600, color: const  Color(0xFF307EDE))
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(180, 47),
                          side: const BorderSide(
                              color: Color.fromRGBO(51, 108, 178, 1),
                              width: 2,
                              style: BorderStyle.solid
                          ),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => {_navigateToAuthScreen(context)},
                        child:  Text("Войти",
                            style: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w600, color: const  Color(0xFFE5E5E5))
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(118, 47),
                          side: const BorderSide(
                              color: Color.fromRGBO(229, 229, 229, 0.62),
                              width: 2,
                              style: BorderStyle.solid
                          ),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
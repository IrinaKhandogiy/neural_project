import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/theme_const.dart';

class UsageRulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BackButton(),
      backgroundColor: BACKGROUND_COLOR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Правила прохождения тестирования',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Image.asset("assets/usage/Group 22.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text('Успокойтесь и расслабьтесь',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(35, 10, 10, 10),
                    child: Image.asset("assets/usage/image 5.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text('Смотрите на изображения\nна экранах',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                    child: Image.asset("assets/usage/image 6.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Text('Следуйте указаниям врача',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Image.asset("assets/usage/image 7.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Дождитесь результатов\nисследования',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

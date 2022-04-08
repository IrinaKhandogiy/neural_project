import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neural_project/results.dart';
import 'package:neural_project/testing/testing_process.dart';
import 'package:neural_project/testing/testing_rules_page.dart';
import 'package:neural_project/theme/theme_const.dart';

import 'usage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToResultsScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ResultsPage(
              title: 'Neural App | Results',
            )));
  }

  void _navigateToTestingScreen(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => TestingRulesPage()));

  void _navigateToUsageRulesScreen(BuildContext context) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UsageRulesPage()));

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BACKGROUND_COLOR,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset('assets/bubbles.png'),
            left: -25,
            top: -20,
          ),
          Positioned(
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                _signOut();
              },
              child: const Icon(Icons.logout),
            ),
            left: 300,
            top: 40,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => {_navigateToTestingScreen(context)},
                  child: Text("Начать тестирование",
                      style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE5E5E5))),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(248, 47),
                    side: const BorderSide(
                        color: Color.fromRGBO(229, 229, 229, 0.62),
                        width: 2,
                        style: BorderStyle.solid),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 46),
                  child: OutlinedButton(
                    onPressed: () => {_navigateToResultsScreen(context)},
                    child: Text("Посмотреть результаты",
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(255, 255, 255, 0.73))),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(222, 47),
                      side: const BorderSide(
                          color: Color.fromRGBO(229, 229, 229, 0.62),
                          width: 2,
                          style: BorderStyle.solid),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: CupertinoButton(
                    child: Text(
                      "Правила использования",
                      style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff307EDE)),
                    ),
                    onPressed: () => {_navigateToUsageRulesScreen(context)},
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

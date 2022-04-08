import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neural_project/testing/testing_process.dart';
import 'package:neural_project/theme/theme_const.dart';

class TestingRulesPage extends StatefulWidget {
  @override
  _TestingRulesPageState createState() => _TestingRulesPageState();
}

class _TestingRulesPageState extends State<TestingRulesPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _myAnimation;
  late List<Image> tests = [];
  int current_list_ind = 0;
  List<Widget> list = [
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing_rules/1.jpg"),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Text('Успокойтесь и расслабьтесь',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
    ),
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing_rules/2.jpg"),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Text('Сконцетрируйтесь на представленном изображении',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
    ),
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing_rules/sticker.png"),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Text('Следуйте указаниям врача',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
    ),
    Container(
      padding: EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Text(
          'Вы можете приостановить прохождение теста в любой момент, коснувшись экрана',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
    ),
    // Text('Следуйте указаниям врача',
    //     textAlign: TextAlign.center,
    //     style: GoogleFonts.openSans(
    //         fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
    // Text(
    //     'Вы можете приостановить прохождение теста в любой момент, коснувшись экрана',
    //     textAlign: TextAlign.center,
    //     style: GoogleFonts.openSans(
    //         fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
  ];

  Future<void> downloadTest(String name) async {
    var ref = firebase_storage.FirebaseStorage.instance.ref().child(name);
    var url = await ref.getDownloadURL();
    this.tests.add(Image.network(url));
  }

  getTests() async {
    await FirebaseFirestore.instance
        .collection("tests")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        downloadTest(doc["path"]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTests();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _myAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 2000), () {
          _controller.reverse();
        });
      }
    });
    Timer.periodic(Duration(seconds: 6), (Timer t) {
      if (current_list_ind < 3) {
        setState(() {
          _controller.forward();
          current_list_ind++;
        });
      } else {
        t.cancel();

        _navigateToTestingScreen(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BACKGROUND_COLOR,
      body:
          FadeTransition(opacity: _myAnimation, child: list[current_list_ind]),
    );
  }

  void _navigateToTestingScreen(context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TestingPage(
                tests: this.tests,
                duriation: this.tests.length * 13,
              )));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Animation>('_myAnimation', _myAnimation));
    properties
        .add(DiagnosticsProperty<Animation>('_myAnimation', _myAnimation));
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neural_project/theme/theme_const.dart';
import '../home.dart';

class TestingPage extends StatefulWidget {
  late List<Image> tests = [];
  final int duriation;
  TestingPage({Key? key, required this.tests, required this.duriation})
      : super(key: key);

  @override
  State<TestingPage> createState() => TestingState(tests: tests);
}

class TestingState extends State<TestingPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _myAnimation;
  int _current_list_ind = 0;
  late List<Image> tests;
  Timer? _timer;
  late int _waitTime;
  var _paused = false;
  var timeStr;
  TestingState({Key? key, required this.tests});

  @override
  void initState() {
    _waitTime = widget.duriation;
    _calculationTime();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _myAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    super.initState();
    _controller.forward();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 2000), () {
          _controller.reverse();
        });
      }
    });
    start(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void start(BuildContext context) {
    if (_waitTime > 0) {
      setState(() {
        _paused = false;
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _waitTime--;
        _calculationTime();
        if ((widget.duriation - _waitTime) % 8 == 0) {
          if (_current_list_ind < tests.length - 1) {
            setState(() {
              _controller.forward();
              _current_list_ind++;
            });
          } else {
            timer.cancel();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Тестирование завершено')));
            goHome();
          }
        }
      });
    }
  }

  void goHome() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(
              title: 'Neural App | Home',
            )));
  }

  void _calculationTime() {
    var minuteStr = (_waitTime ~/ 60).toString().padLeft(2, '0');
    var secondStr = (_waitTime % 60).toString().padLeft(2, '0');
    setState(() {
      timeStr = '$minuteStr:$secondStr';
    });
  }

  void pause() {
    _timer?.cancel();
    setState(() {
      _paused = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: _paused
            ? Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Оставшееся время',
                      style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFE5E5E5)),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Text(
                        timeStr,
                        style: GoogleFonts.openSans(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE5E5E5)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: FloatingActionButton(
                            heroTag: "btn1",
                            onPressed: () {
                              start(context);
                            },
                            child: const Icon(Icons.play_arrow),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: FloatingActionButton(
                            heroTag: "btn2",
                            onPressed: () {
                              goHome();
                            },
                            child: const Icon(Icons.cancel),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
            : GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: FadeTransition(
                        opacity: _myAnimation,
                        child: tests[_current_list_ind])),
                onTap: () {
                  pause();
                },
              ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Animation>('_myAnimation', _myAnimation));
    properties
        .add(DiagnosticsProperty<Animation>('_myAnimation', _myAnimation));
    properties.add(DiagnosticsProperty<Timer>('_timer', _timer));
  }
}

import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neural_project/entities.dart' as entities;
import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:neural_project/theme/theme_const.dart';
import 'package:path_provider/path_provider.dart';

class ResultDetailsPage extends StatefulWidget {
  const ResultDetailsPage(
      {Key? key, required this.title, required this.reference})
      : super(key: key);
  final String title;
  final DocumentReference reference;

  @override
  State<ResultDetailsPage> createState() => _ResultDetailsState();
}

class _ResultDetailsState extends State<ResultDetailsPage> {
  bool loaded = true;
  entities.Result? _result;
  late entities.Experiment _experiment;

  downloadFiles() async {
    if (_result == null) return;
    Directory appDocDir = Directory(
        await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS));
    File downloadToFile = File('${appDocDir.path}/' + _result!.file);
    loaded = true;
    setState(() {});
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseStorage.instance
            .ref(_result!.file)
            .writeToFile(downloadToFile)
            .then((p0) {
          loaded = false;
          setState(() {});
          _showMyDialog(false, null);
        });
      }
    } on FirebaseException catch (e) {
      loaded = false;
      setState(() {});
      _showMyDialog(true, e);
      print(e);
    }
  }

  Future<void> _showMyDialog(bool error, FirebaseException? e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error ? 'Ошибка скачивания' : 'Файл сохранен'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error
                    ? 'Файл не был скачан. Код ошибки:'
                    : 'Файл сохранен в раздел загрузок на вашем устройстве.'),
                error
                    ? Text(
                        e!.message != null ? e.message! : e.code,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const Text(
                        'Документ содержит важную информацию по вашему исследованию.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Хорошо'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getResult() async {
    var firestoreInstance = FirebaseFirestore.instance;
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var user = await firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: userId)
        .get();
    var _user = entities.User(
        user.docs[0].data()["uid"],
        user.docs[0].data()["first_name"],
        user.docs[0].data()["last_name"],
        user.docs[0].data()["second_name"]);
    await widget.reference.get().then((value) {
      var ret_ex = value.data() as LinkedHashMap<String, dynamic>;
      var doctor;
      ret_ex["doctor"].get().then((value) {
        doctor = entities.User(value["uid"], value["first_name"],
            value["last_name"], value["second_name"]);
        _experiment = entities.Experiment(
            widget.reference, ret_ex["date"], doctor, _user);
        loaded = false;
        setState(() {});
        firestoreInstance
            .collection("result")
            .where("experiment", isEqualTo: _experiment.reference)
            .get()
            .then((value) {
          if (value.docs.isEmpty) return;
          _result = entities.Result(
              value.docs[0].data()["date"],
              value.docs[0].data()["file"],
              value.docs[0].data()["comment"],
              _experiment);
          setState(() {});
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return const Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF307EDE),
            ),
          ));
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BACKGROUND_COLOR,
        body: Stack(children: [
          Positioned(
            child: Image.asset("assets/bubbles.png"),
            bottom: -28,
            left: -39,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 73, bottom: 64),
                  child: Text(
                    "Результаты исследования",
                    style: GoogleFonts.openSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: [
                      Text(
                        "Дата исследования:",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        DateFormat("dd.MM.yyyy").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                _experiment.date.millisecondsSinceEpoch)),
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: [
                      Text(
                        "Дата публикации результатов:",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        _result == null
                            ? "нет"
                            : DateFormat("dd.MM.yyyy").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    _result!.date.millisecondsSinceEpoch)),
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: [
                      Text(
                        "Врач:",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        "${_experiment.doctor.last_name} ${_experiment.doctor.first_name} ${_experiment.doctor.second_name}",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(bottom: 29),
                  child: Text(
                    "Комментарий",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(bottom: 63),
                  child: Text(
                    _result != null && _result?.comment != null
                        ? _result!.comment!
                        : "Комментариев нет",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Row(children: [
                      OutlinedButton(
                        onPressed: () => {downloadFiles()},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(170, 41),
                          side: const BorderSide(
                              color: Color.fromRGBO(229, 229, 229, 0.62),
                              width: 2,
                              style: BorderStyle.solid),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        child: Text(
                          "Скачать файлы",
                          style: GoogleFonts.openSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE5E5E5)),
                        ),
                      ),
                      Spacer(),
                    ]))
              ],
            ),
          )
        ]));
  }
}

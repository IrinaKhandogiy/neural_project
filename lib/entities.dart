import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  late Timestamp date;
  late String file;
  late String? comment;
  late Experiment experiment;

  Result(this.date, this.file, this.comment, this.experiment);
}

class Experiment {
  late DocumentReference reference;
  late Timestamp date;
  late User doctor;
  late User user;
  Timestamp? resultDate;
  Experiment(this.reference, this.date, this.doctor, this.user);
}

class User {
  late String uid;
  late String first_name;
  late String last_name;
  String? second_name;

  User(this.uid, this.first_name, this.last_name, this.second_name);

}

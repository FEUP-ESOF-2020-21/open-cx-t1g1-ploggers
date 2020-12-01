import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';


class Comment {
  User user;
  String text;
  DateTime date;
  bool isFromHost;
  DocumentReference reference;

  Comment(this.user, this.text, this.date, this.isFromHost, this.reference);
}

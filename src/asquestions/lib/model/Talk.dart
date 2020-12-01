import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';

class Talk {
  String title;
  String room;
  String description;
  User host;
  DateTime startDate;
  DocumentReference reference;

  Talk(this.title, this.room, this.description, this.host, this.startDate, this.reference);
  
  Talk.fromNew(this.title, this.room, this.description, this.host, this.startDate);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'Talk.dart';

class Slide {
  int number;
  String imageName;
  DocumentReference talk;
  DocumentReference reference;

  Slide(this.number, this.imageName, this.talk, this.reference);
}

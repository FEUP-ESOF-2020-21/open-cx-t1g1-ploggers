import 'package:cloud_firestore/cloud_firestore.dart';

class Slide {
  int number;
  String url;
  DocumentReference talk;
  DocumentReference reference;

  Slide(this.number, this.url, this.talk, this.reference);

  Slide.fromNew(this.number, this.url, this.talk);

  Slide.fromNewNoImage(this.number, this.talk);
}

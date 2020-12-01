import 'package:cloud_firestore/cloud_firestore.dart';

class Talk {
  String name;
  List<String> slides;
  DocumentReference reference;

  Talk(this.name, this.slides, this.reference);
}

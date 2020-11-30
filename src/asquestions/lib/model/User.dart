import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String password;
  String name;
  String picture;
  String bio;
  DocumentReference reference;

  User(this.username, this.email, this.name, this.picture, this.bio,
      this.password, this.reference);



  String replacePassword() {
    String result = this
        .password
        .replaceRange(0, this.password.length, "*" * this.password.length);
    return result;
  }
}

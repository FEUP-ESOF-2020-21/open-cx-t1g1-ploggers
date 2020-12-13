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

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + username.hashCode;
    return result;
  }

  @override
  bool operator ==(Object user) {
    return user is User && user.username == this.username;
  }

  void toggleAvatar(int index) {
    String selectedAvatar = "assets/avatar" + index.toString() + ".png";
    this.picture = selectedAvatar;
  }

  int getAvatarNumber() {
    return int.parse(this.picture.substring(13, 14));
  }
}

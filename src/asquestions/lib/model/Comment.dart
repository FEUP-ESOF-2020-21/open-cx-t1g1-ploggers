import 'User.dart';

class Comment {
  User user;
  String text;
  DateTime date;
  bool isFromHost;

  Comment(this.user, this.text, this.date, this.isFromHost);
}

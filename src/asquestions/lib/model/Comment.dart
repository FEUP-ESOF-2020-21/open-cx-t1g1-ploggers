import 'package:asquestions/model/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Post.dart';
import 'User.dart';

class Comment extends Post {
  bool isFromHost;
  bool isFromModerator;
  DocumentReference question;

  Comment(User user, String content, DateTime date, this.isFromHost,
      this.isFromModerator, this.question, DocumentReference reference)
      : super(user, content, date, reference);

  Comment.fromNew(User user, String content, DateTime date, this.isFromHost,
      this.isFromModerator, this.question)
      : super.fromNew(user, content, date);
}

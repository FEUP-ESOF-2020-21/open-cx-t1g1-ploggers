import 'package:asquestions/model/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Post.dart';
import 'User.dart';

class Comment extends Post {
  bool isFromHost;
  DocumentReference question;

  Comment(User user, String content, DateTime date, this.isFromHost, this.question, DocumentReference reference): super(user, content, date, reference);

  Comment.fromNew(User user, String content, DateTime date, this.isFromHost, this.question): super.fromNew(user, content, date);

}

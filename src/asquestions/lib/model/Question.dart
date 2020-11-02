import 'Comment.dart';
import 'User.dart';

class Question {
  String title;
  User user;
  DateTime date;
  int votes;
  List<Comment> comments;
  int voted; //0 is not voted, 1 is upvoted, 2 is downvoted

  Question(this.title, this.user, this.date, this.votes, this.comments, this.voted);

  void triggerUpvote(){
    if (this.voted == 0) {
        this.votes++;
        this.voted = 1;
      } else if (this.voted == 2) {
        this.votes += 2;
        this.voted = 1;
      } else {
        this.votes--;
        this.voted = 0;
      }
  }

  void triggerDownvote(){
    if (this.voted == 0) {
        this.votes--;
        this.voted = 2;
      } else if (this.voted == 1) {
        this.votes -= 2;
        this.voted = 2;
      } else {
        this.votes++;
        this.voted = 0;
      }
  }
}

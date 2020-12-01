import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';
import 'Slide.dart';
import 'Post.dart';

class Question extends Post{
  int votes;
  int voted; //0 is not voted, 1 is upvoted, 2 is downvoted
  List<Slide> slides;
  DocumentReference talk;

 Question(User user, String content, DateTime date, this.votes, this.voted, this.slides, this.talk, DocumentReference reference): super(user, content, date, reference);

 Question.fromNew(User user, String content, DateTime date, this.votes, this.slides, this.voted, this.talk): super.fromNew(user, content, date);

  void triggerUpvote() {
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

  void triggerDownvote() {
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

  void toggleAnnexSlide(slideIndex) {
    if (this.slides.contains(slideIndex))
      this.slides.remove(slideIndex);
    else
      this.slides.add(slideIndex);
  }
}

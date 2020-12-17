import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';
import 'Slide.dart';
import 'Post.dart';

class Question extends Post {
  List<User> upvotes;
  List<User> downvotes;
  List<Slide> slides;
  bool highlighted;
  DocumentReference talk;

  Question(
      User user,
      String content,
      DateTime date,
      this.upvotes,
      this.downvotes,
      this.slides,
      this.highlighted,
      this.talk,
      DocumentReference reference)
      : super(user, content, date, reference);

  Question.fromNew(User user, String content, DateTime date, this.upvotes,
      this.downvotes, this.slides, this.highlighted, this.talk)
      : super.fromNew(user, content, date);

  int getVotes() {
    return upvotes.length - downvotes.length;
  }

  bool hasUpvoted(User user) {
    for (User upvoteUser in upvotes) {
      if (upvoteUser.username == user.username) return true;
    }
    return false;
  }

  bool hasDownvoted(User user) {
    for (User downvoteUser in downvotes) {
      if (downvoteUser.username == user.username) return true;
    }
    return false;
  }

  void removeUser(User user) {}

  void triggerUpvote(User user) {
    if (!hasUpvoted(user) && hasDownvoted(user)) {
      upvotes.add(user);
      downvotes.remove(user);
    } else if (!hasUpvoted(user) && !hasDownvoted(user)) {
      upvotes.add(user);
    } else if (hasUpvoted(user) && !hasDownvoted(user)) {
      upvotes.remove(user);
    }
  }

  void triggerDownvote(User user) {
    if (!hasDownvoted(user) && hasUpvoted(user)) {
      downvotes.add(user);
      upvotes.remove(user);
    } else if (!hasDownvoted(user) && !hasUpvoted(user)) {
      downvotes.add(user);
    } else if (hasDownvoted(user) && !hasUpvoted(user)) {
      downvotes.remove(user);
    }
  }

  void toggleAnnexSlide(Slide slide) {
    if (this.slides.contains(slide))
      this.slides.remove(slide);
    else
      this.slides.add(slide);
  }

  bool isHighlighted() {
    return this.highlighted;
  }

  void triggerHighlighted() {
    if (this.highlighted) {
      this.highlighted = false;
    } else {
      this.highlighted = true;
    }
  }

  String slidesToNumberString() {
    String result = "";
    int count = 1;
    for (Slide slide in slides) {
      
      if (count == slides.length) {
        result += slide.number.toString();
      }
      else{
        result += slide.number.toString() + ", ";
      }
      count++;
    }
    return result;
  }
}

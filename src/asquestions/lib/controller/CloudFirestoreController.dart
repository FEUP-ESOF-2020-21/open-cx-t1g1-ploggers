import 'package:asquestions/model/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/model/User.dart';
import 'package:asquestions/model/Question.dart';
import 'package:asquestions/model/Talk.dart';
import 'package:asquestions/model/Slide.dart';

class CloudFirestoreController {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User _currentUser;

  Future<Talk> _makeTalkFromDoc(DocumentSnapshot snapshot) async {
    String title = snapshot.get('title');
    String description = snapshot.get('description');
    String room = snapshot.get('room');
    DocumentReference userRef = snapshot.get('host');
    User host = await _makeUserFromSnapshot(await userRef.get());
    DateTime date = snapshot.get('startDate').toDate();
    DocumentReference reference = snapshot.reference;
    return Talk(title, room, description, host, date, reference);
  }

  Future<User> _makeUserFromSnapshot(DocumentSnapshot snapshot) async {
    String username = snapshot.get('username');
    String email = snapshot.get('email');
    String password = snapshot.get('password');
    String name = snapshot.get('name');
    String picture = snapshot.get('picture');
    String bio = snapshot.get('bio');
    DocumentReference reference = snapshot.reference;
    User user = User(username, email, name, picture, bio, password, reference);
    return user;
  }

  Future<Question> _makeQuestionFromSnapshot(DocumentSnapshot snapshot) async {
    String content = snapshot.get('content');
    DocumentReference userRef = snapshot.get('user');
    User user = await _makeUserFromSnapshot(await userRef.get());
    DateTime date = snapshot.get('date').toDate();
    int votes = snapshot.get('votes');
    int voted = snapshot.get('voted');
    List slidesDynamic = snapshot.get('slides');
    List<DocumentReference> slidesRef = slidesDynamic.cast<DocumentReference>();
    List<Slide> slides = new List();
    for (DocumentReference slideRef in slidesRef) {
      Slide newSlide = await _makeSlideFromSnapshot(await slideRef.get());
      slides.add(newSlide);
    }
    DocumentReference talk = snapshot.get('talk');
    DocumentReference reference = snapshot.reference;
    Question question = Question(user, content, date, votes, voted, slides, talk, reference);
    return question;
  }

  Future<List<Talk>> getTalks() async {
    List<Future<Talk>> talks = new List();
    QuerySnapshot snapshot = await firestore.collection("talks").orderBy('startDate').get();
    for (DocumentSnapshot document in snapshot.docs) {
      talks.add(_makeTalkFromDoc(document));
    }
    if (snapshot.docs.length == 0) return [];
    return await Future.wait(talks);
  }

  Future<Comment> _makeCommentFromSnapshot(DocumentSnapshot snapshot) async {
    DocumentReference userRef = snapshot.get('user');
    User user = await _makeUserFromSnapshot(await userRef.get());
    String content = snapshot.get('content');
    DateTime date = snapshot.get('date').toDate();
    bool isFromHost = snapshot.get('isFromHost');
    DocumentReference question = snapshot.get('question');
    DocumentReference reference = snapshot.reference;

    Comment comment =
        Comment(user, content, date, isFromHost, question, reference);
    return comment;
  }

  Future<Slide> _makeSlideFromSnapshot(DocumentSnapshot snapshot) async {
    int number = snapshot.get('number');
    String imageName = snapshot.get('imageName');
    DocumentReference talk = snapshot.get('talk');
    DocumentReference reference = snapshot.reference;

    Slide slide = Slide(number, imageName, talk, reference);
    return slide;
  }

  Future<List<Question>> getQuestionsFromTalkReference(
      DocumentReference talk) async {
    List<Future<Question>> questions = new List();
    QuerySnapshot snapshot = await firestore
        .collection("questions")
        .where('talk', isEqualTo: talk)
        .get();
    for (DocumentSnapshot document in snapshot.docs) {
      questions.add(_makeQuestionFromSnapshot(document));
    }
    if (snapshot.docs.length == 0) return [];
    return await Future.wait(questions);
  }

  Future<List<Comment>> getCommentsFromQuestionReference(
      DocumentReference question) async {
    List<Future<Comment>> comments = new List();
    QuerySnapshot snapshot = await firestore
        .collection("comments")
        .where('question', isEqualTo: question)
        .get();
    for (DocumentSnapshot document in snapshot.docs) {
      comments.add(_makeCommentFromSnapshot(document));
    }
    if (snapshot.docs.length == 0) return [];
    return await Future.wait(comments);
  }

  Future<User> getUser(DocumentSnapshot snapshot) async {
    Future<User> user = _makeUserFromSnapshot(snapshot);
    return await user;
  }

  Future<Question> getQuestion(DocumentSnapshot snapshot) async {
    Future<Question> question = _makeQuestionFromSnapshot(snapshot);
    return await question;
  }


  Future<DocumentReference> getUserReferenceByUsername(String username) async {
    QuerySnapshot snapshot = await firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .limit(1)
        .get();
    if (snapshot.docs.length == 0) return null;
    return snapshot.docs[0].reference;
  }

  User getCurrentUser() {
    return _currentUser;
  }

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  void addQuestion(String content) {
    firestore.collection("questions").add({
      "comments": [],
      "date": Timestamp.fromDate(DateTime.now()),
      "slides": [],
      "content": content,
      "user": _currentUser.reference,
      "voted": 1,
      "votes": 1,
    });
  }
}

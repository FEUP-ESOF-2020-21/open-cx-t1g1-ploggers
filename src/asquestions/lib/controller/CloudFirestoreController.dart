import 'package:asquestions/model/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/model/User.dart';
import 'package:asquestions/model/Question.dart';

class CloudFirestoreController {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User _currentUser;

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
    String title = snapshot.get('title');
    DocumentReference userRef = snapshot.get('user');
    User user = await _makeUserFromSnapshot(await userRef.get());
    List commentRefs = snapshot.get('comments');
    List<Comment> comments = [];
    for (DocumentReference commentRef in commentRefs) {
      Comment comment = await _makeCommentFromSnapshot(await commentRef.get());
      comments.add(comment);
    }
    DateTime date = snapshot.get('date').toDate();
    int votes = snapshot.get('votes');
    int voted = snapshot.get('voted');
    List slidesDynamic = snapshot.get('slides');
    List<int> slides = slidesDynamic.cast<int>();
    DocumentReference reference = snapshot.reference;
    Question question =
        Question(title, user, date, votes, comments, voted, slides, reference);
    return question;
  }

  Future<Comment> _makeCommentFromSnapshot(DocumentSnapshot snapshot) async {
    DocumentReference userRef = snapshot.get('user');
    User user = await _makeUserFromSnapshot(await userRef.get());
    String text = snapshot.get('text');
    DateTime date = snapshot.get('date').toDate();
    bool isFromHost = snapshot.get('isFromHost');
    DocumentReference reference = snapshot.reference;

    Comment comment = Comment(user, text, date, isFromHost, reference);
    return comment;
  }

  Future<List<Question>> getQuestions() async {
    List<Future<Question>> questions = new List();
    QuerySnapshot snapshot = await firestore.collection("questions").get();
    for (DocumentSnapshot document in snapshot.docs) {
      questions.add(_makeQuestionFromSnapshot(document));
    }
    if (snapshot.docs.length == 0) return [];
    return await Future.wait(questions);
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
    return await snapshot.docs[0].reference;
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
      "title": content,
      "user": _currentUser.reference,
      "voted": 1,
      "votes": 1,
    });
  }
}

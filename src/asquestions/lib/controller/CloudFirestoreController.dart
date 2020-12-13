import 'package:asquestions/model/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/model/User.dart';
import 'package:asquestions/model/Question.dart';
import 'package:asquestions/model/Talk.dart';
import 'package:asquestions/model/Slide.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'dart:io';
import 'StorageController.dart';

class CloudFirestoreController {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final StorageController storage = new StorageController();

  static User _currentUser;
  static String _currentUserEmail;
  static bool _needAuth = false;
  static bool _register = false;

  void needsAuth() {
    _needAuth = true;
  }

  bool getAuth() {
    return _needAuth;
  }

  void setRegister(bool value) {
    _register = value;
  }

  bool getRegister() {
    return _register;
  }

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
    List upvotesDynamic = snapshot.get('upvotes');
    List downvotesDynamic = snapshot.get('downvotes');
    List slidesDynamic = snapshot.get('slides');
    List<DocumentReference> upvotesRef =
        upvotesDynamic.cast<DocumentReference>();
    List<DocumentReference> downvotesRef =
        downvotesDynamic.cast<DocumentReference>();
    List<DocumentReference> slidesRef = slidesDynamic.cast<DocumentReference>();

    List<User> upvotes = new List();
    for (DocumentReference upvote in upvotesRef) {
      User upvoteUser = await _makeUserFromSnapshot(await upvote.get());
      upvotes.add(upvoteUser);
    }

    List<User> downvotes = new List();
    for (DocumentReference downvote in downvotesRef) {
      User downvoteUser = await _makeUserFromSnapshot(await downvote.get());
      downvotes.add(downvoteUser);
    }

    List<Slide> slides = new List();
    for (DocumentReference slideRef in slidesRef) {
      Slide newSlide = await _makeSlideFromSnapshot(await slideRef.get());
      slides.add(newSlide);
    }
    DocumentReference talk = snapshot.get('talk');
    DocumentReference reference = snapshot.reference;
    Question question = Question(
        user, content, date, upvotes, downvotes, slides, talk, reference);
    return question;
  }

  Future<List<Talk>> getTalks() async {
    List<Future<Talk>> talks = new List();
    QuerySnapshot snapshot =
        await firestore.collection("talks").orderBy('startDate').get();
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
    String imageName = snapshot.get('url');
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

  Future<List<Slide>> getSlidesFromTalkReference(DocumentReference talk) async {
    List<Future<Slide>> slides = new List();
    QuerySnapshot snapshot = await firestore
        .collection("slides")
        .where('talk', isEqualTo: talk)
        .get();
    for (DocumentSnapshot document in snapshot.docs) {
      slides.add(_makeSlideFromSnapshot(document));
    }
    if (snapshot.docs.length == 0) return [];
    return await Future.wait(slides);
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

  Future<DocumentReference> getUserReferenceByEmail(String email) async {
    QuerySnapshot snapshot = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
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

  String getCurrentUserEmail() {
    return _currentUserEmail;
  }

  void setCurrentUserEmail(String email) {
    _currentUserEmail = email;
  }

  void addQuestion(String content, List<Slide> slides, DocumentReference talk) {
    List<DocumentReference> slidesRef = new List();
    for (Slide slide in slides) {
      slidesRef.add(slide.reference);
    }

    firestore.collection("questions").add({
      "date": Timestamp.fromDate(DateTime.now()),
      "slides": slidesRef,
      "content": content,
      "talk": talk,
      "user": _currentUser.reference,
      "upvotes": [],
      "downvotes": [],
    });
  }

  void addUser(String name, String username, String email) {
    firestore.collection("users").add({
      "username": username,
      "bio": "",
      "email": email,
      "name": name,
      "picture": "assets/avatar1.png",
      "password": "12345678",
    });
  }

  void addComment(String content, bool isFromHost, DocumentReference question) {
    firestore.collection("comments").add({
      "date": Timestamp.fromDate(DateTime.now()),
      "content": content,
      "isFromHost": isFromHost,
      "question": question,
      "user": _currentUser.reference,
    });
  }

  Future<void> refreshQuestionVotes(Question question) async {
    List<DocumentReference> upvotesRef = new List();
    for (User upvote in question.upvotes) {
      upvotesRef.add(upvote.reference);
    }

    List<DocumentReference> downvotesRef = new List();
    for (User downvote in question.downvotes) {
      downvotesRef.add(downvote.reference);
    }

    await question.reference
        .update({'upvotes': upvotesRef, 'downvotes': downvotesRef});
  }

  Future<bool> isHost(User user, DocumentReference question) async {
    DocumentSnapshot questionSnap = await question.get();
    DocumentReference talkRef = questionSnap.get("talk");
    DocumentSnapshot talkSnap = await talkRef.get();
    DocumentReference hostRef = talkSnap.get("host");

    return hostRef.id == user.reference.id;
  }

  Future<DocumentReference> addTalk(String title, String room,
    String description, User moderator, DateTime startDate) async {
    firestore.collection("talks").add({
      "description": description,
      "title": title,
      "host": _currentUser.reference,
      "moderator": moderator.reference,
      "room": room,
      "startDate": Timestamp.fromDate(startDate)
    });
    QuerySnapshot snapshot = await firestore
        .collection("talks")
        .where('description', isEqualTo: description)
        .where('title', isEqualTo: title)
        .where('host', isEqualTo: _currentUser.reference)
        .where('moderator', isEqualTo: moderator.reference)
        .where('room', isEqualTo: room)
        .where('startDate', isEqualTo: Timestamp.fromDate(startDate))
        .get();
    if (snapshot.docs.length == 0) return null;
    return snapshot.docs[0].reference;
  }

  Future<void> addSlidesFromImagePicker(
    List<Asset> images, DocumentReference reference) async {
    List<File> fileSlides = new List();
    for (Asset imageAsset in images) {
      final filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        fileSlides.add(tempFile);
      }
    }

    int count = 1;
    for (File imageFile in fileSlides) {
      String url;
      url = await storage.uploadFile(
          imageFile, reference.path + "-" + count.toString());
      firestore.collection("slides").add({
        "number": count,
        "talk": reference,
        "url": url,
      });
      count++;
    }
  }
}

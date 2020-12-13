import 'package:asquestions/view/pages/UserProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import '../../model/Question.dart';
import '../../model/Comment.dart';
import '../../view/pages/AddCommentPage.dart';
import '../../view/widgets/CustomListView.dart';

class QuestionPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  final DocumentReference _questionReference;

  QuestionPage(this._firestore, this._questionReference);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Question question;
  List<Comment> comments;
  bool showLoadingIndicator = false;
  bool isModeratorOrHost;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    this.refreshModel(true);
  }

  Future<void> refreshModel(bool showIndicator) async {
    Stopwatch sw = Stopwatch()..start();
    setState(() {
      showLoadingIndicator = showIndicator;
    });
    question = await widget._firestore
        .getQuestion(await widget._questionReference.get());
    comments = await widget._firestore
        .getCommentsFromQuestionReference(widget._questionReference);
    DocumentReference talkRef = await widget._firestore
        .getTalkFromQuestionReference(widget._questionReference);
    isModeratorOrHost = await widget._firestore
        .isModeratorOrHost(widget._firestore.getCurrentUser(), talkRef);
    comments.sort((a, b) {
      if (b.isFromModerator) {
        return 1;
      }
      return -1;
    });
    comments.sort((a, b) {
      if (b.isFromHost) {
        return 1;
      }
      return -1;
    });
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("Question fetch time: " + sw.elapsed.toString());
  }

  void _toggleDeleteComment(Comment comment) {
    setState(() {
      widget._firestore.removeComment(comment.reference);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (question == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Question Thread"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add_comment_outlined),
                  iconSize: 28,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCommentPage(
                                widget._firestore, widget._questionReference)));
                  })
            ],
          ),
          body: Visibility(
              visible: showLoadingIndicator, child: LinearProgressIndicator()));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Question Thread"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add_comment_outlined),
                  iconSize: 28,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCommentPage(
                                widget._firestore, widget._questionReference)));
                  })
            ],
          ),
          body: CustomListView(
              onRefresh: () => refreshModel(false),
              controller: scrollController,
              itemCount: (comments.length == 0 ? 3 : comments.length + 2),
              itemBuilder: (BuildContext context, int index) =>
                  listPageBuilder(context, index)));
    }
  }

  Widget listPageBuilder(BuildContext context, int index) {
    switch (index) {
      case 0:
        Widget questionCard;
        if (question.slides.length == 0)
          questionCard = buildQuestionWithoutSlide();
        else
          questionCard = buildQuestionWithSlide();
        return questionCard;
      case 1:
        return Divider(
            height: 10,
            thickness: 3,
            color: Colors.grey.shade400,
            indent: 10,
            endIndent: 10);
      case 2:
        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              height: 500,
              width: 300,
              child: Column(
                children: <Widget>[
                  Text("Looks like no one answered this question yet!",
                      style: new TextStyle(fontSize: 14.0, color: Colors.blue)),
                  Icon(
                    Icons.question_answer_rounded,
                    size: 80,
                    color: Colors.lightBlue.shade300,
                  ),
                  Text("Be the first!",
                      style: new TextStyle(fontSize: 14.0, color: Colors.blue)),
                ],
              ),
            ),
          );
        }
        continue hasComments;
      hasComments:
      default:
        Comment comment = comments[index - 2];
        if (isModeratorOrHost) {
          return Card(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      //height: 5,
                      //color: Colors.black,
                      child: IconButton(
                          icon: Icon(Icons.close_rounded),
                          color: Colors.red,
                          onPressed: () {
                            //_toggleDeleteQuestion(question);
                            _toggleDeleteComment(comment);
                          },
                          iconSize: 20),
                    ),
                  ]),
                  GestureDetector(
                    onTap:  (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) =>
                          UserProfilePage(widget._firestore, comment.user.reference)));
                    },
                        child: ListTile(
                        leading: Image(image: AssetImage(comment.user.picture)),
                        title: Text(comment.user.name,
                            style: new TextStyle(fontSize: 20.0)),
                        subtitle: Text(comment.content,
                            style: new TextStyle(fontSize: 18.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(comment.getAgeString(),
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.grey.shade700)),
                          if (!comment.isFromHost && !comment.isFromModerator)
                            Icon(
                              Icons.person_rounded,
                              color: Colors.grey.shade600,
                            )
                          else if (!comment.isFromHost &&
                              comment.isFromModerator)
                            Icon(
                              Icons.security_rounded,
                              color: Colors.lightBlue,
                            )
                          else
                            Icon(
                              Icons.mic_rounded,
                              color: Colors.yellow.shade800,
                            )
                        ]),
                  )
                ],
              ),
            ),
          );
        }
        return Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                                widget._firestore, comment.user.reference)));
                  },
                  child: ListTile(
                      leading: Image(image: AssetImage(comment.user.picture)),
                      title: Text(comment.user.name,
                          style: new TextStyle(fontSize: 20.0)),
                      subtitle: Text(comment.content,
                          style: new TextStyle(fontSize: 18.0))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(comment.getAgeString(),
                            style: new TextStyle(
                                fontSize: 14.0, color: Colors.grey.shade700)),
                        if (!comment.isFromHost && !comment.isFromModerator)
                          Icon(
                            Icons.person_rounded,
                            color: Colors.grey.shade600,
                          )
                        else if (!comment.isFromHost && comment.isFromModerator)
                          Icon(
                            Icons.security_rounded,
                            color: Colors.lightBlue,
                          )
                        else
                          Icon(
                            Icons.mic_rounded,
                            color: Colors.yellow.shade800,
                          )
                      ]),
                )
              ],
            ),
          ),
        );
    }
  }

  Widget buildComments() {
    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 500,
          width: 300,
          child: Column(
            children: <Widget>[
              Text("Looks like no one answered this question yet!",
                  style: new TextStyle(fontSize: 14.0, color: Colors.blue)),
              Icon(
                Icons.question_answer_rounded,
                size: 80,
                color: Colors.lightBlue.shade300,
              ),
              Text("Be the first!",
                  style: new TextStyle(fontSize: 14.0, color: Colors.blue)),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (BuildContext context, int index) {
          Comment comment = comments[index];
          return Card(
            color: Colors.blue.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                  widget._firestore, comment.user.reference)));
                    },
                    child: ListTile(
                        leading: Image(image: AssetImage(comment.user.picture)),
                        title: Text(comment.user.name,
                            style: new TextStyle(fontSize: 20.0)),
                        subtitle: Text(comment.content,
                            style: new TextStyle(fontSize: 18.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(comment.getAgeString(),
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.grey.shade700)),
                          if (!comment.isFromHost)
                            Icon(
                              Icons.person_rounded,
                              color: Colors.grey.shade600,
                            )
                          else
                            Icon(
                              Icons.mic_rounded,
                              color: Colors.yellow.shade800,
                            )
                        ]),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget buildQuestionWithSlide() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                              widget._firestore, question.user.reference)));
                },
                child: ListTile(
                  leading: Image(image: AssetImage(question.user.picture)),
                  title: Text(question.content,
                      style: new TextStyle(fontSize: 25.0)),
                  subtitle: Text("Asked by: " + question.user.name,
                      style: new TextStyle(fontSize: 18.0)),
                ),
              ),
              Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.blue.shade200,
                  indent: 40,
                  endIndent: 40),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Tagged Slide: ",
                    style: new TextStyle(fontSize: 18.0)),
              ),
              Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.blue.shade200,
                  indent: 40,
                  endIndent: 40),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: question.slides.length != 1
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: question.slides.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: FittedBox(
                                        child: Image.network(
                                            question.slides[index].url),
                                        fit: BoxFit.fill));
                              })
                          : Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: FittedBox(
                                  child: Image.network(question.slides[0].url),
                                  fit: BoxFit.fill)))),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comments.length.toString() + " comments",
                        style: new TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade700)),
                    Text(question.getAgeString(),
                        style: new TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade700))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestionWithoutSlide() {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                              widget._firestore, question.user.reference)));
                },
                child: ListTile(
                  leading: Image(image: AssetImage(question.user.picture)),
                  title: Text(question.content,
                      style: new TextStyle(fontSize: 25.0)),
                  subtitle: Text("Asked by: " + question.user.name,
                      style: new TextStyle(fontSize: 18.0)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comments.length.toString() + " comments",
                        style: new TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade700)),
                    Text(question.getAgeString(),
                        style: new TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade700))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

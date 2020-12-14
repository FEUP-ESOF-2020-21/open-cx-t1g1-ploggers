import 'package:asquestions/view/pages/UserProfilePage.dart';
import 'package:asquestions/view/pages/QuestionPage.dart';
import 'package:asquestions/view/pages/AddQuestionPage.dart';
import 'package:flutter/material.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import '../../model/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../view/widgets/CustomListView.dart';

class TalkQuestionsPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  final DocumentReference _talkReference;

  TalkQuestionsPage(this._firestore, this._talkReference);

  @override
  _TalkQuestionsState createState() => _TalkQuestionsState();
}

class _TalkQuestionsState extends State<TalkQuestionsPage> {
  List<Question> questions = new List();
  bool showLoadingIndicator = false;
  ScrollController scrollController;

  bool isModeratorOrHost;

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
    questions = await widget._firestore
        .getQuestionsFromTalkReference(widget._talkReference);
    isModeratorOrHost = await widget._firestore.isModeratorOrHost(
        widget._firestore.getCurrentUser(), widget._talkReference);
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("Question fetch time: " + sw.elapsed.toString());
  }

  void _toggleUpvote(Question question) {
    setState(() {
      question.triggerUpvote(widget._firestore.getCurrentUser());
      widget._firestore.refreshQuestionVotes(question);
    });
  }

  void _toggleDownvote(Question question) {
    setState(() {
      question.triggerDownvote(widget._firestore.getCurrentUser());
      widget._firestore.refreshQuestionVotes(question);
    });
  }

  void _toggleHighLighted(Question question) {
    setState(() {
      question.triggerHighlighted();
      widget._firestore.refreshHighLighted(question);
    });
  }

  void _toggleDeleteQuestion(Question question) {
    setState(() {
      widget._firestore.removeQuestion(question.reference);
    });
  }

  void openPage() {}

  @override
  Widget build(BuildContext context) {
    questions.sort((a, b) => b.getVotes().compareTo(a.getVotes()));
    questions.sort((a, b) {
      if (b.highlighted) {
        return 1;
      }
      return -1;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Talk Questions'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_box_outlined),
              iconSize: 28,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddQuestionPage(
                            widget._firestore, widget._talkReference)));
              })
        ],
      ),
      body: Column(
        children: [
          Visibility(
              visible: showLoadingIndicator, child: LinearProgressIndicator()),
          Expanded(
            child: CustomListView(
                onRefresh: () => refreshModel(false),
                controller: scrollController,
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildQuestionCard(context, index)),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionCard(BuildContext context, int index) {
    final question = questions[index];
    if (!isModeratorOrHost) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionPage(widget._firestore, question.reference)));
        },
        child: Container(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                  widget._firestore, question.user.reference)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.blue.shade500, width: 4),
                      ),
                      child: SizedBox(
                          width: 80,
                          height: 80,
                          child:
                              Image(image: AssetImage(question.user.picture))),
                    ),
                  ),
                ),
                buildCard(question),
                buildVotes(question),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionPage(widget._firestore, question.reference)));
        },
        child: Container(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                                widget._firestore, question.user.reference)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image(image: AssetImage(question.user.picture))),
                  ),
                ),
                buildCard(question),
                buildPreferenceDelete(question),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildCard(Question question) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.content, style: new TextStyle(fontSize: 20.0)),
            Container(
              height: 10,
            ),
            Divider(
                height: 0,
                thickness: 3,
                color: Colors.blue.shade200,
                indent: 0,
                endIndent: 40),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 10.0),
              child: Text("By: " + question.user.name,
                  style: new TextStyle(fontSize: 15.0)),
            ),
            Text(question.getAgeString()),
          ],
        ),
      ),
    );
  }

  Widget buildVotes(Question question) {
    if (question.highlighted) {
      return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child:
                  Icon(Icons.star_rate_rounded, color: Colors.orange, size: 30),
            ),
            Transform.scale(
              scale: 2.0,
              child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up_outlined),
                  color:
                      (question.hasUpvoted(widget._firestore.getCurrentUser())
                          ? Colors.green
                          : Colors.black),
                  onPressed: () {
                    _toggleUpvote(question);
                  }),
            ),
            Text((question.getVotes()).toString(),
                style: new TextStyle(fontSize: 18.0)),
            Transform.scale(
              scale: 2.0,
              child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                  color:
                      (question.hasDownvoted(widget._firestore.getCurrentUser())
                          ? Colors.red
                          : Colors.black),
                  onPressed: () {
                    _toggleDownvote(question);
                  }),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: 2.0,
            child: IconButton(
                icon: Icon(Icons.keyboard_arrow_up_outlined),
                color: (question.hasUpvoted(widget._firestore.getCurrentUser())
                    ? Colors.green
                    : Colors.black),
                onPressed: () {
                  _toggleUpvote(question);
                }),
          ),
          Text((question.getVotes()).toString(),
              style: new TextStyle(fontSize: 18.0)),
          Transform.scale(
            scale: 2.0,
            child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                color:
                    (question.hasDownvoted(widget._firestore.getCurrentUser())
                        ? Colors.red
                        : Colors.black),
                onPressed: () {
                  _toggleDownvote(question);
                }),
          ),
        ],
      ),
    );
  }

  Widget buildPreferenceDelete(Question question) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: 2.0,
            child: IconButton(
                icon: (question.isHighlighted()
                    ? Icon(Icons.star_rate_rounded)
                    : Icon(Icons.star_border_rounded)),
                color: Colors.orange,
                onPressed: () {
                  _toggleHighLighted(question);
                },
                iconSize: 16),
          ),
          Text((question.getVotes()).toString(),
              style: new TextStyle(fontSize: 18.0)),
          Transform.scale(
            scale: 2.0,
            child: IconButton(
                icon: Icon(Icons.close_rounded),
                color: Colors.red,
                onPressed: () {
                  _toggleDeleteQuestion(question);
                },
                iconSize: 16),
          ),
        ],
      ),
    );
  }
}

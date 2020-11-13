import 'package:asquestions/view/MyQuestionPage.dart';
import 'package:asquestions/view/AddQuestionPage.dart';
import 'package:flutter/material.dart';
import '../model/Question.dart';
import '../model/User.dart';
import '../model/Comment.dart';

class MyConferenceQuestionsPage extends StatefulWidget {
  @override
  _MyConferenceQuestionsState createState() => _MyConferenceQuestionsState();
}

class _MyConferenceQuestionsState extends State<MyConferenceQuestionsPage> {
  static List<Comment> comments = [
    Comment(
        User('', '', 'Atendee One', 'assets/avatar1.png', '', '1234'),
        'Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1',
        DateTime.now(),
        true),
    Comment(User('', '', 'Atendee Two', 'assets/avatar2.png', '', '1234'),
        'Comment 2', DateTime.now(), false),
    Comment(User('', '', 'Atendee Three', 'assets/avatar3.png', '', '1234'),
        'Comment 3', DateTime.now(), false),
    Comment(User('', '', 'Atendee Four', 'assets/avatar4.png', '', '1234'),
        'Comment 4', DateTime.now(), false),
    Comment(User('', '', 'Atendee Five', 'assets/avatar5.png', '', '1234'),
        'Comment 5', DateTime.now(), false),
  ];

  List<Question> questionList = [
    Question(
        "Question 1",
        User('', '', 'Atendee One', 'assets/avatar1.png', '', '1234'),
        DateTime.now(),
        1,
        [],
        1,
        null),
    Question(
        "Question 2",
        User('', '', 'Atendee Two', 'assets/avatar2.png', '', '1234'),
        DateTime.parse("2020-11-02 15:20"),
        10,
        comments,
        0,
        null),
    Question(
        "Question 3",
        User('', '', 'Atendee Three', 'assets/avatar3.png', '', '1234'),
        DateTime.parse("2020-11-02 15:40"),
        100,
        comments,
        1,
        null),
    Question(
        "Question 4",
        User('', '', 'Atendee Four', 'assets/avatar4.png', '', '1234'),
        DateTime.parse("2020-11-02 14:50"),
        80,
        comments,
        2,
        null),
    Question(
        "Question 5",
        User('', '', 'Atendee Five', 'assets/avatar5.png', '', '1234'),
        DateTime.parse("2020-11-02 14:56"),
        20,
        comments,
        0,
        null),
    Question(
        "Question 6",
        User('', '', 'Atendee Six', 'assets/avatar1.png', '', '1234'),
        DateTime.parse("2020-11-02 15:34"),
        20,
        comments,
        0,
        null),
    Question(
        "Question 7",
        User('', '', 'Atendee Seven', 'assets/avatar3.png', '', '1234'),
        DateTime.parse("2020-11-02 16:10"),
        54,
        comments,
        1,
        null),
  ];

  void _toggleUpvote(Question question) {
    setState(() {
      question.triggerUpvote();
    });
  }

  void _toggleDownvote(Question question) {
    setState(() {
      question.triggerDownvote();
    });
  }

  void openPage() {}

  @override
  Widget build(BuildContext context) {
    questionList.sort((a, b) => b.votes.compareTo(a.votes));
    return Scaffold(
      appBar: AppBar(
        title: Text('Conference Questions'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_sharp),
              iconSize: 28,
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddQuestionPage()));
              })
        ],
      ),
      body: ListView.builder(
          itemCount: questionList.length,
          itemBuilder: (BuildContext context, int index) =>
              buildQuestionCard(context, index)),
    );
  }

  Widget buildQuestionCard(BuildContext context, int index) {
    final question = questionList[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyQuestionPage(question)));
      },
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image(image: AssetImage(question.user.picture))),
              ),
              buildCard(question),
              buildVotes(question),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Question question) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.title, style: new TextStyle(fontSize: 20.0)),
            Text(question.user.name, style: new TextStyle(fontSize: 15.0)),
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                  question.date.hour.toString() +
                      ":" +
                      question.date.minute.toString(),
                  style: new TextStyle(fontSize: 12.0)),
            ),
            Text(question.comments.length.toString() + " comments",
                style: new TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
    );
  }

  Widget buildVotes(Question question) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: 2.0,
            child: IconButton(
                icon: Icon(Icons.keyboard_arrow_up_outlined),
                color: (question.voted == 1 ? Colors.green : Colors.black),
                onPressed: () {
                  _toggleUpvote(question);
                }),
          ),
          Text((question.votes).toString(),
              style: new TextStyle(fontSize: 18.0)),
          Transform.scale(
            scale: 2.0,
            child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                color: (question.voted == 2 ? Colors.red : Colors.black),
                onPressed: () {
                  _toggleDownvote(question);
                }),
          ),
        ],
      ),
    );
  }
}

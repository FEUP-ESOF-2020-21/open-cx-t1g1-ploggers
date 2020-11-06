import 'package:flutter/material.dart';
import '../model/Question.dart';
import '../model/Comment.dart';

class MyQuestionPage extends StatefulWidget {
  final Question question;

  MyQuestionPage(this.question);

  @override
  _MyQuestionPageState createState() => _MyQuestionPageState(question);
}

class _MyQuestionPageState extends State<MyQuestionPage> {
  final Question question;

  _MyQuestionPageState(this.question);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Question Thread"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildQuestion(),
            Divider(
                height: 10,
                thickness: 3,
                color: Colors.grey.shade400,
                indent: 10,
                endIndent: 10),
            Expanded(child: buildComments())
          ],
        ));
  }

  Widget buildComments() {
    if (question.comments.isEmpty) {
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
                color: Colors.blue.shade200,
              ),
              Text("Be the first!",
                  style: new TextStyle(fontSize: 14.0, color: Colors.blue)),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: question.comments.length,
        itemBuilder: (BuildContext context, int index) {
          Comment comment = question.comments[index];
          return Card(
            color: Colors.blue.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                      leading: Image(image: AssetImage(comment.user.picture)),
                      title: Text(comment.user.name,
                          style: new TextStyle(fontSize: 20.0)),
                      subtitle: Text(comment.text,
                          style: new TextStyle(fontSize: 18.0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              comment.date.hour.toString() +
                                  ":" +
                                  comment.date.minute.toString(),
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

  Widget buildQuestion() {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image(image: AssetImage(question.user.picture)),
                title:
                    Text(question.title, style: new TextStyle(fontSize: 25.0)),
                subtitle: Text("Asked by: " + question.user.name,
                    style: new TextStyle(fontSize: 18.0)),
              ),
              Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.blue.shade200,
                  indent: 40,
                  endIndent: 40),
              Text("Tagged Slide: ", style: new TextStyle(fontSize: 18.0)),
              Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.blue.shade200,
                  indent: 40,
                  endIndent: 40),
              Image(image: AssetImage('assets/pp1.png')),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(question.comments.length.toString() + " comments",
                        style: new TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade700)),
                    Text(
                        question.date.hour.toString() +
                            ":" +
                            question.date.minute.toString(),
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

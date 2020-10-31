import 'package:flutter/material.dart';
import 'Question.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AsQuestions',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  //To move to model
  final List<Question> questionList = [
    Question("Question 1", "Atendee One", 26, 6),
    Question("Question 2", "Atendee Two", 13, 5),
    Question("Question 3", "Atendee Three", 10, 3),
    Question("Question 4", "Atendee Four", 10, 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conference Questions'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: questionList.length,
          itemBuilder: (BuildContext context, int index) =>
              buildQuestionCard(context, index)),
    );
  }

  Widget buildQuestionCard(BuildContext context, int index) {
    final question = questionList[index];

    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.title, style: new TextStyle(fontSize: 25.0)),
                  Container(
                    height: 10,
                  ),
                  Text(question.author, style: new TextStyle(fontSize: 18.0)),
                  Text(question.numComments.toString() + " comments",
                      style: new TextStyle(fontSize: 15.0)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  Transform.scale(
                    scale: 2.0,
                    child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_up_outlined),
                        onPressed: () {
                          question.votes++;
                        }),
                  ),
                  Text(question.votes.toString(),
                      style: new TextStyle(fontSize: 18.0)),
                  Transform.scale(
                    scale: 2.0,
                    child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        onPressed: () {
                          question.votes--;
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

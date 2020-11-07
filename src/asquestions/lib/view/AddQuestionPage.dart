import 'package:asquestions/view/MyConferenceQuestionsPage.dart';
import 'package:flutter/material.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 600,
          width: 300,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            maxLines: 15,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Write your question",
            ),
            style: TextStyle(height: 1),
          )),
    );
  }
}

class AddQuestionPage extends StatefulWidget {
  AddQuestionPage();

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  _AddQuestionPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Question"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check_sharp),
              iconSize: 25,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyConferenceQuestionsPage()));
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Image(
              image: AssetImage("assets/avatar1.png"),
              width: 150,
            ),
          ),
          Divider(
              thickness: 3.0,
              color: Colors.blue.shade200,
              indent: 48,
              endIndent: 48),
          Text("Atendee Six", style: new TextStyle(fontSize: 20.0)),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Divider(
                thickness: 3.0,
                color: Colors.blue.shade200,
                indent: 48,
                endIndent: 48),
          ),
          Expanded(child: MyCustomForm())
        ],
      ),
    );
  }

  //Widget newQuestion() {}
}

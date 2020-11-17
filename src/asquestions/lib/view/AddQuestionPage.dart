import 'package:asquestions/view/AnnexSlidePage.dart';
import 'package:flutter/material.dart';
import '../model/Question.dart';

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
                icon: Icon(IconData(0xe5c7, fontFamily: 'MaterialIcons')),
                iconSize: 25,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnnexSlidePage(Question(
                              null, null, null, null, null, null, []))));
                })
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: AssetImage("assets/avatar1.png"),
                width: 150,
              ),
              Divider(
                thickness: 3.0,
                color: Colors.blue.shade200,
              ),
              Text("Atendee Six", style: new TextStyle(fontSize: 20.0)),
              Divider(
                thickness: 3.0,
                color: Colors.blue.shade200,
              ),
              MyCustomForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: null,
                    child:
                        Text("Submit", style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                  )),
                ],
              )
            ],
          ),
        ));
  }
}

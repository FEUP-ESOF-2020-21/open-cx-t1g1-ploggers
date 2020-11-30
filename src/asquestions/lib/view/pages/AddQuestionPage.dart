import 'package:asquestions/view/pages/AnnexSlidePage.dart';
import 'package:asquestions/view/pages/ConferenceQuestionsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:flutter/material.dart';
import '../../model/Question.dart';

class AddQuestionPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  AddQuestionPage(this._firestore);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  _AddQuestionPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("New Question"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.attachment_rounded),
                iconSize: 25,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnnexSlidePage(widget._firestore)));
                })
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 35),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("assets/avatar1.png"),
                width: 120,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  thickness: 3.0,
                  color: Colors.blue.shade200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Atendee Six", style: new TextStyle(fontSize: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Divider(
                  thickness: 3.0,
                  color: Colors.blue.shade200,
                ),
              ),
              MyCustomForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConferenceQuestionsPage(widget._firestore)));
                    },
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

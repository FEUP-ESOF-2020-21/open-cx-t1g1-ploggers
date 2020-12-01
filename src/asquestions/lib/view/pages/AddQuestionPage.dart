import 'package:asquestions/view/pages/AnnexSlidePage.dart';
import 'package:asquestions/view/pages/TalkQuestionsPage.dart';
import 'package:asquestions/model/Question.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:flutter/material.dart';

class AddQuestionPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  AddQuestionPage(this._firestore);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  String _content;
  final myController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
                          builder: (context) =>
                              AnnexSlidePage(widget._firestore)));
                })
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 0, left: 35, right: 35),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage(widget._firestore.getCurrentUser().picture),
                width: 150,
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
                child: Text(widget._firestore.getCurrentUser().name,
                    style: new TextStyle(fontSize: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Divider(
                  thickness: 3.0,
                  color: Colors.blue.shade200,
                ),
              ),
              Form(
                key: formKey,
                child: Column(children: [
                  Center(
                    child: SizedBox(
                        child: TextFormField(
                      controller: myController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      validator: (input) =>
                          input.length < 10 ? "Invalid Question" : null,
                      onSaved: (input) => _content = input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Write your question",
                      ),
                      style: TextStyle(height: 1),
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: _submit,
                        child: Text("Submit",
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue)),
                      )),
                    ],
                  )
                ]),
              ),
            ],
          ),
        ));
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget._firestore.addQuestion(_content);
    }
  }
}

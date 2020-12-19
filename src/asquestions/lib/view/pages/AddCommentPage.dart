import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:asquestions/view/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';

class AddCommentPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  final DocumentReference _questionReference;

  AddCommentPage(this._firestore, this._questionReference);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  String _content;
  final myController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showLoadingIndicator = false;
  ScrollController scrollController;
  bool isFromHost;
  bool isFromModerator;

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
    isFromHost = await widget._firestore
        .isHost(widget._firestore.getCurrentUser(), widget._questionReference);
    isFromModerator = await widget._firestore.isModerator(
        widget._firestore.getCurrentUser(), widget._questionReference);
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("Slides fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (isFromHost == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("New Comment"),
            centerTitle: true,
          ),
          body: Visibility(
              visible: showLoadingIndicator, child: LinearProgressIndicator()));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("New Comment"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: Padding(
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
                  child: Text(
                      "New Comment by: " +
                          widget._firestore.getCurrentUser().name,
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
                          child: TextFieldContainer(
                        child: TextFormField(
                          controller: myController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          validator: (input) => input.length < 10
                              ? "Invalid Comment: Too Short!"
                              : null,
                          onSaved: (input) => _content = input,
                          decoration: InputDecoration(
                            suffix: Icon(Icons.question_answer_rounded,
                                color: Colors.blue[900]),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Write your Comment",
                          ),
                          style: TextStyle(height: 1),
                        ),
                      )),
                    ),
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () => _submit(),
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
          )));
    }
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget._firestore.addComment(
          _content, isFromHost, isFromModerator, widget._questionReference);
      Navigator.pop(context);
    }
  }
}

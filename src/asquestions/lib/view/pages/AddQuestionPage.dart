import 'package:asquestions/model/Slide.dart';
import 'package:asquestions/model/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:asquestions/view/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';

class AddQuestionPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  final DocumentReference _talkReference;

  AddQuestionPage(this._firestore, this._talkReference);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  String _content;
  final myController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Slide> _slides = null;
  bool _sortedSlides = false;
  bool showLoadingIndicator = false;
  ScrollController scrollController;
  Question _temp_question;

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
    _slides = await widget._firestore
        .getSlidesFromTalkReference(widget._talkReference);
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("Slides fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    _temp_question = new Question.fromNew(
        widget._firestore.getCurrentUser(),
        null,
        DateTime.now(),
        [],
        [],
        [],
        widget._talkReference); // this object is helping to tag slides
    return Scaffold(
        appBar: AppBar(
          title: Text("New Question"),
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
                width: 100,
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
                child: Text("New Question by: " + widget._firestore.getCurrentUser().name,
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
                          validator: (input) =>
                                input.length < 10 ? "Invalid Question: Too Short!" : null,
                          onSaved: (input) => _content = input,
                          decoration: InputDecoration(
                            suffix: Icon(Icons.question_answer_rounded, color: Colors.blue[900]),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                              hintText: "Write your Question",
                          ),
                        style: TextStyle(height: 1),
                    ),
                        )),
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
                    child: Text("Choose slides to attach: ",
                        style: new TextStyle(fontSize: 20.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Divider(
                      thickness: 3.0,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  _slides != null
                      ? SizedBox(height: 200, child: buildSlidesInput())
                      : Center(
                          child: SizedBox(
                              child: Visibility(
                                  visible: showLoadingIndicator,
                                  child: CircularProgressIndicator(
                                      backgroundColor:
                                          Colors.lightBlue.shade300))),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () => _submit(),
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
        )));
  }

  Widget buildSlidesInput() {
    Widget slidesInput;
    if (!_sortedSlides && _slides != []) {
      print(_slides);
      _slides.sort((a, b) => a.number.compareTo(b.number));
      _sortedSlides = true;
    }

    if (_slides.length == 0) {
      slidesInput = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [MyAnnexQuestionForm()]);
    } else {
      slidesInput = ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _slides.length,
          itemBuilder: (BuildContext context, int index) =>
              buildSlideCard(context, index));
    }

    return slidesInput;
  }

  Widget buildSlideCard(BuildContext context, int index) {
    final slide = _slides[index];
    return SlideCard(_temp_question, slide, _slides.length);
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget._firestore
          .addQuestion(_content, _temp_question.slides, widget._talkReference);
      Navigator.pop(context);
    }
  }
}

class MyAnnexQuestionForm extends StatefulWidget {
  @override
  _MyAnnexQuestionFormState createState() => _MyAnnexQuestionFormState();
}

class _MyAnnexQuestionFormState extends State<MyAnnexQuestionForm> {
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
        maxLines: 1,
        decoration: InputDecoration(
          hintText: "What slides do you want to tag?",
        ),
        style: TextStyle(height: 1),
      )),
    );
  }
}

class SlideCard extends StatefulWidget {
  Question question;
  Slide slide;
  int presentationLength;

  SlideCard(this.question, this.slide, this.presentationLength);

  @override
  _SlideCardState createState() {
    return _SlideCardState();
  }
}

class _SlideCardState extends State<SlideCard> {
  @override
  Widget build(BuildContext context) {
    Widget slideWidget = Stack(children: [
      Image.asset("assets/" + widget.slide.imageName,
          width: MediaQuery.of(context).size.width - 90, height: 200),
      Container(
          margin: const EdgeInsets.all(5),
          color: Colors.grey.withOpacity(0.5),
          width: 20,
          height: 20,
          child: Center(
              child: Text((widget.slide.number).toString(),
                  style: TextStyle(color: Colors.black))))
    ]);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.question.toggleAnnexSlide(widget.slide);
        });
      },
      child: Container(
          // add a border when selected
          decoration: BoxDecoration(
              border: (widget.question.slides.contains(widget.slide)
                  ? Border.all(width: 1.0, color: Colors.blue)
                  : Border.all(width: 0.0))),
          margin: const EdgeInsets.all(2),
          child: Card(child: slideWidget)),
    );
  }
}

import 'package:asquestions/view/pages/AddQuestionPage.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import '../../model/Talk.dart';
import '../../model/Question.dart';
import 'package:flutter/material.dart';

class AnnexSlidePage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  Question _question;
  Talk _talk;
  AnnexSlidePage(this._firestore);

  @override
  _AnnexSlidePageState createState() => _AnnexSlidePageState();
}

class _AnnexSlidePageState extends State<AnnexSlidePage> {
  _AnnexSlidePageState();

  @override
  Widget build(BuildContext context) {}
}
/*
    Widget slidesInput;
    if (widget._talk.slides.length == 0) {
      slidesInput = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [MyAnnexQuestionForm()]);
    } else {
      slidesInput = ListView.builder(
          itemCount: widget._talk.slides.length,
          itemBuilder: (BuildContext context, int index) =>
              buildSlideCard(context, index));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Annex Slide"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check_rounded),
                iconSize: 25,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddQuestionPage(widget._firestore)));
                })
          ],
        ),
        body: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 35),
            child: slidesInput));
  }

  Widget buildSlideCard(BuildContext context, int index) {
    final slide = widget._talk.slides[index];
    return SlideCard(widget._question, index, slide, widget._talk.slides.length);
  }
}

class SlideCard extends StatefulWidget {
  Question question;
  int slideIndex;
  String slide;
  int presentationLength;

  SlideCard(
      this.question, this.slideIndex, this.slide, this.presentationLength);

  @override
  _SlideCardState createState() {
    return _SlideCardState();
  }
}

class _SlideCardState extends State<SlideCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.slideIndex);
    Widget slideWidget = Stack(children: [
      Image(image: AssetImage(widget.slide)),
      Container(
          margin: const EdgeInsets.all(5),
          color: Colors.grey.withOpacity(0.5),
          width: 20,
          height: 20,
          child: Center(
              child: Text((widget.slideIndex + 1).toString(),
                  style: TextStyle(color: Colors.black))))
    ]);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.question.toggleAnnexSlide(widget.slideIndex);
        });
      },
      child: Container(
          // add a margin when selected
          decoration: BoxDecoration(
              border: (widget.question.annexedSlides.contains(widget.slideIndex)
                  ? Border.all(width: 1.0, color: Colors.blue)
                  : Border.all(width: 0.0))),
          margin: (widget.slideIndex != widget.presentationLength - 1
              ? const EdgeInsets.only(bottom: 10)
              : const EdgeInsets.all(0)),
          child: Card(child: slideWidget)),
    );
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
*/

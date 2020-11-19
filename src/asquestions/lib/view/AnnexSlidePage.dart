import 'package:asquestions/view/AddQuestionPage.dart';
import '../model/Presentation.dart';
import '../model/Question.dart';
import 'package:flutter/material.dart';

class AnnexSlidePage extends StatefulWidget {
  Question question;
  AnnexSlidePage(this.question);

  @override
  _AnnexSlidePageState createState() => _AnnexSlidePageState(this.question);
}

class _AnnexSlidePageState extends State<AnnexSlidePage> {
  Question question;
  _AnnexSlidePageState(this.question);

  // pseudo-database, just to test code
  Presentation presentation = Presentation("Presentation 1", [
    "assets/pp1.png",
    "assets/pp1.png",
    "assets/pp1.png",
    "assets/pp1.png",
    "assets/pp1.png"
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Annex Slide"),
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
                          builder: (context) => AddQuestionPage()));
                })
          ],
        ),
        body: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 35),
            // child: Text("ola")));
            child: ListView.builder(
                itemCount: presentation.slides.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildSlideCard(context, index))));
  }

  Widget buildSlideCard(BuildContext context, int index) {
    final slide = presentation.slides[index];
    return SlideCard(widget.question, index, slide, presentation.slides.length);
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
          child: Card(
            child: Stack(children: [
              Image(image: AssetImage(widget.slide)),
              Container(
                  margin: const EdgeInsets.all(5),
                  color: Colors.grey.withOpacity(0.5),
                  width: 20,
                  height: 20,
                  child: Center(
                      child: Text(widget.slideIndex.toString(),
                          style: TextStyle(color: Colors.black))))
            ]),
          )),
    );
  }
}

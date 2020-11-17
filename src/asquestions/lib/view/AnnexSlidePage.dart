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

    return GestureDetector(
      onTap: () {
        question.annexSlide(slide);
      },
      child: Container(
        // add a margin when selected
        // decoration: BoxDecoration(
        //     border: (question.annexedSlides.contains(slide)
        //         ? Border.all(color: Colors.blue)
        //         : null)),
        margin: (index != presentation.slides.length - 1
            ? const EdgeInsets.only(bottom: 10)
            : const EdgeInsets.all(0)),
        child: Card(
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image(image: AssetImage(slide))),
        ),
      ),
    );
  }
}

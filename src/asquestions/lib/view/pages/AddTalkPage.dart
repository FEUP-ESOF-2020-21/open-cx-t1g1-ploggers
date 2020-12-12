import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:flutter/material.dart';
import 'package:asquestions/view/widgets/TextFieldContainer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddTalkPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  AddTalkPage(this._firestore);

  @override
  _AddTalkPageState createState() => _AddTalkPageState();
}

class _AddTalkPageState extends State<AddTalkPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _room = TextEditingController();
  TextEditingController _description = TextEditingController();
  DateTime _startDate;
  String _dateSelector = "Start Date";
  List<Asset> _images;

  Future getImages() async{
    await MultiImagePicker.pickImages(maxImages: 100).then((images){
      setState(() {
        _images = images;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("New Talk"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: Divider(
                indent: size.width * 0.1,
                endIndent: size.width * 0.1,
                height: 20,
                color: Colors.blue[900],
              ),
            ),
            Text(
              "Talk by: " + widget._firestore.getCurrentUser().name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Colors.blue[600]),
            ),
            Divider(
              indent: size.width * 0.1,
              endIndent: size.width * 0.1,
              height: 20,
              color: Colors.blue[900],
            ),
            Form(
                key: formKey,
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                    ),
                    child: TextFieldContainer(
                      child: TextField(
                        controller: _title,
                        decoration: InputDecoration(
                            icon: Icon(Icons.question_answer_rounded,
                                color: Colors.blue[900]),
                            hintText: "Title",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                      child: TextField(
                        controller: _room,
                        decoration: InputDecoration(
                            icon: Icon(Icons.home_work_rounded,
                                color: Colors.blue[900]),
                            hintText: "Room",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                      child: TextField(
                        controller: _description,
                        maxLines: 5,
                        decoration: InputDecoration(
                            suffix: Icon(Icons.description_rounded,
                                color: Colors.blue[900]),
                            hintText: "Description",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                        child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            color: Colors.blue[900]),
                        FlatButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  onChanged: (date) {}, onConfirm: (date) {
                                setState(() {
                                  _startDate = date;
                                  _dateSelector = date.toString();
                                });
                              }, currentTime: DateTime.now());
                            },
                            child: Text(
                              _dateSelector,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            )),
                      ],
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                        child: Row(
                          children: [
                            Icon(Icons.add_a_photo_rounded,
                                color: Colors.blue[900]),
                            FlatButton(
                                onPressed: getImages,
                                child: Text("Attach Slides", style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w400,fontSize: 16),
                            )),
                          ],
                        )),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        /*bottom: 20*/
                      ),
                      child: Button(
                          title: _title,
                          room: _room,
                          description: _description,
                          startDate: _startDate,
                          firestore: widget._firestore))
                ]))
          ],
        )));
  }
}

class Button extends StatelessWidget {
  final CloudFirestoreController firestore;
  final TextEditingController title, room, description;
  DateTime startDate;
  Button(
      {this.title,
      this.room,
      this.description,
      this.startDate,
      this.firestore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ButtonTheme(
          minWidth: 350.0,
          height: 50.0,
          child: RaisedButton(
              highlightElevation: 0.0,
              splashColor: Colors.blue[800],
              highlightColor: Colors.blue,
              elevation: 0.0,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 4.0, color: Colors.blue[500]),
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text("Create Talk",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.white)),
              onPressed: () {})),
    );
  }
}

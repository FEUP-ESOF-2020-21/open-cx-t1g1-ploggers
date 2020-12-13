import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController _moderator = TextEditingController();
  DateTime _startDate;
  String _dateSelector = "Start Date";
  List<Asset> _images = [];
  String _imagesString = "0";
  var emailValidator;

  Future getImages() async {
    await MultiImagePicker.pickImages(
        maxImages: 100,
        materialOptions: MaterialOptions(
          actionBarColor: "#2296f3",
          actionBarTitle: "Attach Slides",
          allViewTitle: "Attach Slides",
          useDetailsView: false,
          selectCircleStrokeColor: "#2296f3",
        )).then((images) {
      setState(() {
        _images = images;
        _imagesString = images.length.toString();
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
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size.height* 0.05),
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                      ),
                      child: TextFieldContainer(
                        child: TextFormField(
                          validator: (value) {
                            if (value.length < 10) {
                              return "Title is too short!";
                            } else
                              return null;
                          },
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
                      ),
                      child: TextFieldContainer(
                        child: TextFormField(
                          validator: (value) {
                            if (value.length < 1) {
                              return "Invalid Room";
                            } else
                              return null;
                          },
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
                        child: TextFormField(
                          validator: (value) {
                            if (value.length < 20) {
                              return "Description is too short!";
                            } else
                              return null;
                          },
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
                        child: TextFormField(
                          validator: (value) {
                            return emailValidator;
                          },
                          controller: _moderator,
                          decoration: InputDecoration(
                              icon: Icon(Icons.security_rounded,
                                  color: Colors.blue[900]),
                              hintText: "Moderator Email",
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
                          Icon(Icons.attach_file_rounded,
                              color: Colors.blue[900]),
                          FlatButton(
                              onPressed: getImages,
                              child: Text(
                                "Attach Slides: " +
                                    _imagesString +
                                    " slides attached",
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
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
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height* 0.03),
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
                                    side: BorderSide(
                                        width: 4.0, color: Colors.blue[500]),
                                    borderRadius: new BorderRadius.circular(30.0)),
                                child: Text("Create Talk",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white)),
                                onPressed: () async {
                                  var response;
                                  DocumentReference user = await widget._firestore
                                      .getUserReferenceByEmail(
                                          this._moderator.text);
                                  if (user == null) {
                                    response = "User not found!";
                                  }

                                  setState(() {
                                    this.emailValidator = response;
                                  });
                                  if (formKey.currentState.validate()) {
                                    DocumentReference talkRef =
                                        await widget._firestore.addTalk(
                                            _title.text,
                                            _room.text,
                                            _description.text,
                                            user,
                                            _startDate);
                                    widget._firestore
                                        .addSlidesFromImagePicker(_images, talkRef);
                                    Navigator.pop(context);
                                  }
                                })),
                      ),
                    )
                  ],
                )),
          ),
        ])));
  }
}

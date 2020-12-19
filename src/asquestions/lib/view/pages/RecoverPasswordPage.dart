import 'package:asquestions/controller/Authenticator.dart';
import 'package:asquestions/view/widgets/TextFieldContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoverPasswordPage extends StatefulWidget {
  final CloudFirestoreController _firestore;

  RecoverPasswordPage(this._firestore);

  @override
  State<StatefulWidget> createState() => RecoverPasswordPageState();
}

class RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  var emailValidator;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    widget._firestore.needsAuth();
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.036),
          child: Container(
              alignment: Alignment.topLeft,
              child: BackButton(color: Colors.blue)),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            child: Image.asset("assets/logo.png",
                width: size.width * 0.7,
                height: size.height * 0.22,
                fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.005),
          child: Divider(
            indent: size.width * 0.1,
            endIndent: size.width * 0.1,
            height: 20,
            color: Colors.blue[900],
          ),
        ),
        Text(
          "Recover Password",
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
                  top: 20,
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  bottom: 20),
              child: TextFieldContainer(
                child: TextFormField(
                  validator: (value) {
                    return emailValidator;
                  },
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.email_rounded, color: Colors.blue[900]),
                      hintText: "Email",
                      border: InputBorder.none),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: size.width * 0.1, right: size.width * 0.1),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
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
                    child: Text("Send",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: Colors.white)),
                    onPressed: () async {
                      var response;
                      DocumentReference user = await widget._firestore.getUserReferenceByEmail(_email.text);
                      if (user == null) {
                        response = "There are no accounts created with this email!";
                      }

                      setState(() {
                        this.emailValidator = response;
                      });
                      if (formKey.currentState.validate()) {
                        context.read<Authenticator>().resetPassword(_email.text);
                        Navigator.pop(context);
                      }
                    }
                  )
                )
              )
            )
          ]),
        ),
      ],
    )));
  }
}
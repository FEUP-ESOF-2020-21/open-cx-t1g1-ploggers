import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:asquestions/view/pages/LoginPage.dart';
import 'package:asquestions/view/pages/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InitialPage extends StatefulWidget {
  final CloudFirestoreController _firestore;

  InitialPage(this._firestore);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 100),
          child: SizedBox(
            child: Image.asset("assets/logo.png",
                width: 450, height: 250, fit: BoxFit.contain),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Text(
            "Welcome!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.blue[600]),
          ),
        ),
        Container(
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
                  side: BorderSide(width: 4.0, color: Colors.blue[800]),
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text("Sign In",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(widget._firestore)));
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 25.0),
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
                  side: BorderSide(width: 4.0, color: Colors.blue[800]),
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text("Sign Up",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage(widget._firestore)));
              },
            ),
          ),
        )
      ]),
    );
  }
}

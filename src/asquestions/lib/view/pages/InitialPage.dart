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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size.height*0.1),
            child: Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: Image.asset("assets/logo.png",
                width: size.width*0.7, height: size.height*0.22, fit: BoxFit.cover),
              ),
            ),
          ),
          Divider(
          color: Colors.blue[900],
          height: 20,
          indent: 0,
          endIndent: 0),
          Text(
            "Welcome!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.blue[600]),
          ),
          Divider(
            color: Colors.blue[900],
            height: 20,
            indent: 0,
            endIndent: 0,),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.05),
            child: Divider(
              color: Colors.blue,
              height: 20,
              indent: 100,
              endIndent: 0,
              thickness: 4,),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: Divider(
              color: Colors.blue[800],
              height: 20,
              indent: 0,
              endIndent: 100,
              thickness: 4,),
          ),
          Container(
            child: ButtonTheme(
              minWidth: 350.0,
              height: 50.0,
              child: RaisedButton(
                key: Key("LoginButton"),
                highlightElevation: 0.0,
                splashColor: Colors.blue[900],
                highlightColor: Colors.blue,
                elevation: 0.0,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 4.0, color: Colors.blue[500]),
                    borderRadius: new BorderRadius.circular(25.0)),
                child: Text("Sign In",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(widget._firestore)));
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 25.0),
            margin: const EdgeInsets.only(bottom: 20),
            child: ButtonTheme(
              minWidth: 350.0,
              height: 50.0,
              child: RaisedButton(
                highlightElevation: 0.0,
                splashColor: Colors.blue[900],
                highlightColor: Colors.blue,
                elevation: 0.0,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 4.0, color: Colors.blue[500]),
                    borderRadius: new BorderRadius.circular(25.0)),
                child: Text("Sign Up",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignUpPage(widget._firestore)));
                },
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
            height: 20,
            indent: 0,
            endIndent: 100,
            thickness: 4,),
          Divider(
            color: Colors.blue[800],
            height: 20,
            indent: 100,
            endIndent: 0,
            thickness: 4,),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.18),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text("© AsQuestions by PLOGGERS",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey)
              ),
            ),
          )
        ]
      ),
    );
  }
}

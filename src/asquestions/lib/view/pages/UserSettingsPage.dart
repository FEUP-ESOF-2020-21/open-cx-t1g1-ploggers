import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asquestions/controller/Authenticator.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';

class UserSettingsPage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  UserSettingsPage(this._firestore);
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignOutPage(widget._firestore),
    );
  }
}

class SignOutPage extends StatelessWidget {
  final CloudFirestoreController _firestore;

  SignOutPage(this._firestore);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              context.read<Authenticator>().signOut();
            },
            child: Text("Sign out"),
          )
        ],
      ),
    ));
  }
}

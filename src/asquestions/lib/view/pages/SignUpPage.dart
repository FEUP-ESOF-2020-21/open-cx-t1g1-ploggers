import 'package:asquestions/controller/Authenticator.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:asquestions/view/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final CloudFirestoreController _firestore;

  SignUpPage(this._firestore);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    widget._firestore.needsAuth();
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: size.height*0.036),
              child: Container(
                alignment: Alignment.topLeft,
                child: BackButton(color: Colors.blue)),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: Image.asset("assets/logo.png", width: size.width*0.7, height: size.height*0.22, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.005),
              child: Divider(
                indent: size.width*0.1,
                endIndent: size.width*0.1,
                height: 20,
                color: Colors.blue[900],
              ),
            ),
            Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Colors.blue[600]),
            ),
            Divider(
              indent: size.width*0.1,
              endIndent: size.width*0.1,
              height: 20,
              color: Colors.blue[900],
            ),
            Form(
                key: formKey,
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                        child: TextField(
                        controller: _username,
                        decoration: InputDecoration(
                            icon: Icon(Icons.alternate_email_rounded, color: Colors.blue[900]),
                            hintText: "Username",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                      child: TextField(
                        controller: _name,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person_rounded, color: Colors.blue[900]),
                            hintText: "Name",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                      child: TextField(
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
                        top: 10,
                        left: size.width * 0.1,
                        right: size.width * 0.1),
                    child: TextFieldContainer(
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock_rounded, color: Colors.blue[900]),
                            hintText: "Password",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        /*bottom: 20*/
                      ),
                      child: SignUpButton(
                          username: _username,
                          name: _name,
                          email: _email,
                          password: _password,
                          firestore: widget._firestore))
                ]))
          ],
        )));
  }
}

class SignUpButton extends StatelessWidget {
  final CloudFirestoreController firestore;
  final TextEditingController username, name, email, password;
  SignUpButton(
      {this.username, this.name, this.email, this.password, this.firestore});

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
                  side: BorderSide(width: 4.0, color: Colors.blue[900]),
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text("Sign Up",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.white)),
              onPressed: () {
                context
                    .read<Authenticator>()
                    .signUp(email.text.trim(), password.text.trim())
                    .then((value) {
                  Scaffold.of(context).removeCurrentSnackBar(
                      reason: SnackBarClosedReason.remove);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(value)));
                  if (value == 'Signed up') {
                    firestore.addUser(name.text, username.text, email.text);
                  }
                });
              })),
    );
  }
}

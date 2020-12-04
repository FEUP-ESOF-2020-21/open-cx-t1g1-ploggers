import 'package:asquestions/controller/Authenticator.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
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
        appBar: AppBar(),
        resizeToAvoidBottomPadding: false,
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: Image.asset("assets/logo.png",
                    width: 450, height: 250, fit: BoxFit.contain),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 7,
              color: Colors.blue[500],
            ),
            Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue[600]),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 7,
              color: Colors.blue[500],
            ),
            SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: size.width * 0.1,
                          right: size.width * 0.1,
                          /*bottom: 20*/
                        ),
                        child: TextField(
                          controller: _username,
                          decoration: InputDecoration(
                              icon: Icon(Icons.account_circle),
                              hintText: "Username",
                              labelText: "Username"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: size.width * 0.1,
                          right: size.width * 0.1,
                          /*bottom: 20*/
                        ),
                        child: TextField(
                          controller: _name,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: "Name",
                              labelText: "Name"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: size.width * 0.1,
                          right: size.width * 0.1,
                          /*bottom: 20*/
                        ),
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: "Email",
                              labelText: "Email"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10,
                            left: size.width * 0.1,
                            right: size.width * 0.1),
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: "Password",
                              labelText: "Password"),
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
                    ])))
          ],
        ));
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
      padding: const EdgeInsets.only(top: 50.0),
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
                //Navigator.pop(context);
              })),
    );
  }
}

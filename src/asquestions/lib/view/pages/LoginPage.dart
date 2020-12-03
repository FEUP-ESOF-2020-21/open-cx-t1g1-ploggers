import 'package:asquestions/controller/Authenticator.dart';
import 'package:asquestions/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final CloudFirestoreController _firestore;

  LoginPage(this._firestore);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _hidePassword = true;
    widget._firestore.needsAuth();
    return Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 50),
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
              "Sign In",
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
            Form(
              key: formKey,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      bottom: 20),
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        hintText: "Email",
                        labelText: "Email"),
                    /*validator: (String value) {
                      if (!value.contains('@')) return 'Invalid email.';
                      return null;
                    },*/
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 20, left: size.width * 0.1, right: size.width * 0.1),
                  child: TextField(
                    controller: _password,
                    obscureText: _hidePassword,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: "Password",
                        labelText: "Password"),
                  ),
                ),
                SigninButton(email: _email, password: _password),
                //Container(padding: EdgeInsets.all(20), child: SigninButton({email: _email, password: _password})),
              ]),
            )
          ],
        ));
  }
}

class SigninButton extends StatelessWidget {
  final TextEditingController email, password;
  SigninButton({this.email, this.password});

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
              child: Text("Sign In",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              onPressed: () {
                //print(email.text);
                context
                    .read<Authenticator>()
                    .signIn(email.text.trim(), password.text.trim())
                    .then((value) {
                  Scaffold.of(context).removeCurrentSnackBar(
                      reason: SnackBarClosedReason.remove);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(value)));
                });
                //Navigator.pop(context);
              })),
    );

    /*return RaisedButton(
      onPressed: () {
        print(email.text);
        context
            .read<Authenticator>()
            .signIn(email.text.trim(), password.text.trim())
            .then((value) {
          Scaffold.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(value)));
        });
      },
      child: Text("Login"),
    );*/
  }
}

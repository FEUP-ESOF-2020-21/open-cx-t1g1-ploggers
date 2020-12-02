import 'package:asquestions/controller/Authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:asquestions/model/User.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    bool _hidePassword = true;
    return Scaffold(
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
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.account_circle),
                        hintText: "Email",
                        labelText: "Email"),
                    validator: (String value) {
                      if (!value.contains('@')) return 'Invalid email.';
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.only(
                      top: 20, left: size.width * 0.1, right: size.width * 0.1),
                  child: TextFormField(
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
    return RaisedButton(
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
    );
  }
}

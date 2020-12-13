import 'package:asquestions/model/User.dart';
import 'package:asquestions/view/pages/AddTalkPage.dart';
import 'package:asquestions/view/widgets/TextFieldContainer.dart';
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
  final formKey = GlobalKey<FormState>();
  User _user;
  bool flag1 = true, flag2 = true, flag3 = false, flag4 = false, flag5 = false;
  List<bool> flagList = [];
  void initState() {
    flagList = [flag1, flag2, flag3, flag4, flag5];
  }

  TextEditingController _username = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _bio = TextEditingController();

  refreshState() {
    setState(() {
      widget._firestore.updateUserPicture(_user.picture).then((value) {
        print("changed Database");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initState();
    _user = widget._firestore.getCurrentUser();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings Page"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              height: 320,
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                Avatar(_user, 1, refreshState),
                Avatar(_user, 2, refreshState),
                Avatar(_user, 3, refreshState),
                Avatar(_user, 4, refreshState),
                Avatar(_user, 5, refreshState)
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                _user.name,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              )
            ]),
            Form(
                key: formKey,
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      /*bottom: 20*/
                    ),
                    child: TextFieldContainer(
                      child: TextField(
                        controller: _username,
                        decoration: InputDecoration(
                            icon: Icon(Icons.alternate_email_rounded,
                                color: Colors.blue[900]),
                            hintText: "Username: " + _user.username,
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
                        controller: _name,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person_rounded,
                                color: Colors.blue[900]),
                            hintText: "Name: " + _user.name,
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
                        controller: _bio,
                        maxLines: 5,
                        decoration: InputDecoration(
                            suffix: Icon(Icons.description_rounded,
                                color: Colors.blue[900]),
                            hintText: "Description: " + _user.bio,
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
                      child: Button(
                          bio: _bio,
                          username: _username,
                          name: _name,
                          firestore: widget._firestore)),
                ])),
            SignOutPage(widget._firestore)
          ],
        )));
  }
}

class Avatar extends StatefulWidget {
  final VoidCallback refreshParent;
  final int avatarNumber;
  User user;

  Avatar(this.user, this.avatarNumber, this.refreshParent);

  @override
  _AvatarState createState() {
    return _AvatarState();
  }
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.user.toggleAvatar(widget.avatarNumber);
            widget.refreshParent();
            print(widget.user.picture);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 10),
          // add a border when selected
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: (widget.user.picture ==
                      "assets/avatar" + widget.avatarNumber.toString() + ".png")
                  ? Border.all(width: 5.0, color: Colors.blue)
                  : Border.all(width: 0.0)),
          child: Image.asset(
              "assets/avatar" + widget.avatarNumber.toString() + ".png"),
        ));
  }
}

class SignOutPage extends StatelessWidget {
  final CloudFirestoreController _firestore;

  SignOutPage(this._firestore);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        context.read<Authenticator>().signOut();
      },
      child: Text("Sign out"),
    );
  }
}

class Button extends StatelessWidget {
  final CloudFirestoreController firestore;
  final TextEditingController bio, name, username;
  DateTime startDate;
  Button({
    this.bio,
    this.username,
    this.name,
    this.firestore,
  });

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
              child: Text("Edit Profile",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.white)),
              onPressed: () {
                String usernameStr = username.text.trim();
                String nameStr = name.text.trim();
                String bioStr = bio.text.trim();

                if (usernameStr == "") {
                  usernameStr = this.firestore.getCurrentUser().username;
                }

                if (nameStr == "") {
                  nameStr = this.firestore.getCurrentUser().name;
                }

                if (bioStr == "") {
                  bioStr = this.firestore.getCurrentUser().bio;
                }
                this.firestore.updateUser(usernameStr, nameStr, bioStr);
              })),
    );
  }
}

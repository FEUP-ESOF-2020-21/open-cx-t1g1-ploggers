import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asquestions/model/User.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';

class UserProfilePage extends StatefulWidget {
  final CloudFirestoreController _firestore;
  final DocumentReference _userReference;

  UserProfilePage(this._firestore, this._userReference);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User _user;
  bool showLoadingIndicator = false;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    this.refreshModel(true);
  }

  Future<void> refreshModel(bool showIndicator) async {
    Stopwatch sw = Stopwatch()..start();
    setState(() {
      showLoadingIndicator = showIndicator;
    });
    _user = await widget._firestore.getUser(await widget._userReference.get());
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("User fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_user == null) {
      return Scaffold(
          body: Stack(children: <Widget>[
        ClipPath(
          clipper: MyCustomClipper(),
          child: Container(
              height: 250, decoration: new BoxDecoration(color: Colors.blue)),
        ),
        Center(
          child: SizedBox(
              height: 150,
              width: 150,
              child: Visibility(
                  visible: showLoadingIndicator,
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue.shade300))),
        )
      ]));
    } else {
      return Scaffold(
          body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                  height: 250,
                  decoration: new BoxDecoration(color: Colors.blue)),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: size.height * 0.15),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      child: Image.asset("assets/avatar1.png"),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.lightBlue.shade300, width: 4)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(_user.name,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                          )),
                    ),
                    getItems(_user),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }
  }

  Widget getItems(User user) {
    return Column(children: <Widget>[
      Divider(indent: 20, endIndent: 20),
      ListTile(
        leading: Icon(Icons.chrome_reader_mode),
        title: Text(
          "Bio",
          style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          _user.bio,
          style: new TextStyle(fontSize: 18.0),
        ),
      ),
      Divider(indent: 20, endIndent: 20),
      ListTile(
        leading: Icon(Icons.account_circle),
        title: Text(
          "Username",
          style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          _user.username,
          style: new TextStyle(fontSize: 17.0),
        ),
        dense: true,
      ),
      Divider(indent: 20, endIndent: 20),
      ListTile(
        leading: Icon(Icons.lock),
        title: Text(
          "Password",
          style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          _user.replacePassword(),
          style: new TextStyle(fontSize: 18.0),
        ),
      ),
      Divider(indent: 20, endIndent: 20),
      ListTile(
        leading: Icon(Icons.alternate_email),
        title: Text(
          "Email",
          style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          _user.email,
          style: new TextStyle(fontSize: 18.0),
        ),
      ),
      Divider(indent: 20, endIndent: 20),
    ]);
  }

  Widget topBar() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back), onPressed: () {}, iconSize: 35),
          IconButton(
              icon: Icon(Icons.settings), onPressed: () {}, iconSize: 35),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

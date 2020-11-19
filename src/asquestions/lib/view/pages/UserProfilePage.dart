import 'package:flutter/material.dart';
import 'package:asquestions/model/User.dart';

class UserProfilePage extends StatefulWidget {
  final User _user;

  UserProfilePage(this._user);

  @override
  _UserProfilePageState createState() => _UserProfilePageState(_user);
}

class _UserProfilePageState extends State<UserProfilePage> {
  final User _user;

  _UserProfilePageState(this._user);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300,
              decoration: new BoxDecoration(
                  color: Colors.blue)
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: size.width * 0.015, top: size.height * 0.2),
            child: Column(
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/avatar1.png"),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.lightBlue.shade300, width: 4)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _user.name,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                    )),
                    IconButton(
                      icon: Icon(Icons.settings_rounded),
                      color: Colors.black,
                      onPressed: () {},
                    )
                  ],
                ),

                getItems(_user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getItems(User user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10), //use size later
          child: Column(children: <Widget>[
            Divider(indent: 20, endIndent: 50),
            ListTile(
              leading: Icon(Icons.chrome_reader_mode),
              title: Text(
                "Bio",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              ),
              subtitle: Text(
                _user.bio,
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(indent: 20, endIndent: 50),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                "Username",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              ),
              subtitle: Text(
                _user.username,
                style: new TextStyle(fontSize: 17.0),
              ),
              dense: true,
            ),
            Divider(indent: 20, endIndent: 50),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text(
                "Password",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              ),
              subtitle: Text(
                _user.replacePassword(),
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(indent: 20, endIndent: 50),
            ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text(
                "Email",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              ),
              subtitle: Text(
                _user.email,
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(indent: 20, endIndent: 50),
          ]),
        )
      ],
    );
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

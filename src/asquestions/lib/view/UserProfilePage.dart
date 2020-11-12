import 'package:flutter/material.dart';
import 'package:asquestions/model/User.dart';

class UserProfilePage extends StatefulWidget {
  final User user;

  UserProfilePage(this.user);

  @override
  _UserProfilePageState createState() => _UserProfilePageState(user);
}

class _UserProfilePageState extends State<UserProfilePage> {
  final User user;

  _UserProfilePageState(this.user);

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
              //color: Colors.transparent,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/background1.png"),
                      fit: BoxFit.cover)),
            ),
          ),
          topBar(),
          Container(
            //height: size.hei,
            padding: EdgeInsets.only(
                left: size.width * 0.015, top: size.height * 0.2),
            child: Column(
              children: <Widget>[
                //alignment: Alignment.,
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/avatar1.png"),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30, width: 4)),
                ),
                Positioned(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                getItems(user),
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
          padding: EdgeInsets.only(top: 20, right: 10), //use size later
          child: Column(children: <Widget>[
            ListTile(
              leading: Icon(Icons.chrome_reader_mode),
              title: Text(
                "Bio",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                user.bio,
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(indent: 20, endIndent: 50),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                "Username",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                user.username,
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
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                user.replacePassword(),
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(indent: 20, endIndent: 50),
            ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text(
                "Email",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                user.email,
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
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}, iconSize: 35),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}, iconSize: 35),
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
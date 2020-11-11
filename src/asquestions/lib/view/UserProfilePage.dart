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
                image: new DecorationImage( image: new AssetImage("assets/background1.png"),
                fit: BoxFit.cover)
              ),
            ),
          ),
          Container(
            height: 600,
            padding: EdgeInsets.only(left: size.width*0.25, top: size.height*0.2),
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
              ],
            ),
          ),
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

import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:asquestions/view/pages/TalkQuestionsPage.dart';
import 'package:asquestions/view/pages/HomePage.dart';
import 'package:asquestions/view/pages/UserProfilePage.dart';
import 'package:asquestions/view/pages/UserSettingsPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavigatorPage extends StatefulWidget {
  final CloudFirestoreController _firestore;

  NavigatorPage(this._firestore);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  DocumentReference _userReference;
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
    _userReference = await widget._firestore.getUserReferenceByEmail(widget
        ._firestore
        .getCurrentUserEmail()); //At this point current user should already be loaded -> test
    widget._firestore.setCurrentUser(
        await widget._firestore.getUser(await _userReference.get()));
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("User Reference fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (widget._firestore.getCurrentUser() != null) {
      int _currentIndex = 0;
      PageController _pageController = PageController();
      List<Widget> _screens = [
        HomePage(widget._firestore),
        UserProfilePage(
            widget._firestore, widget._firestore.getCurrentUser().reference),
        UserSettingsPage(widget._firestore)
      ];

      void _onPageChanged(int index) {
        _pageController.jumpToPage(index);
        _currentIndex = index;
      }

      return Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.blue,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.blue,
          animationDuration: Duration(milliseconds: 300),
          height: 50,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(_currentIndex);
            });
          },
          items: <Widget>[
            Icon(Icons.question_answer_rounded, size: 30, color: Colors.white),
            Icon(Icons.person_rounded, size: 30, color: Colors.white),
            Icon(Icons.settings_rounded, size: 30, color: Colors.white)
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(child: Image.asset("assets/logo.png",width: 450, height: 250, fit: BoxFit.contain))
      );
    }
  }
}

import 'package:asquestions/view/pages/ConferenceQuestionsPage.dart';
import 'package:asquestions/view/pages/HomePage.dart';
import 'package:asquestions/view/pages/UserProfilePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:asquestions/model/User.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  User user = new User(
      'Attendee 1',
      'attende1@gmail.com',
      'Atendee One',
      'assets/avatar1.png',
      'example_bio example_bio example_bio example_bio',
      '1234');

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    PageController _pageController = PageController();
    List<Widget> _screens = [
      HomePage(),
      ConferenceQuestionsPage(),
      UserProfilePage(user)
    ];

    void _onPageChanged(int index) {
      _pageController.jumpToPage(index);
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
        height: 60,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(_currentIndex);
          });
        },
        items: <Widget>[
          Icon(Icons.home_rounded, size: 30, color: Colors.white),
          Icon(Icons.question_answer_rounded, size: 30, color: Colors.white),
          Icon(Icons.person_rounded, size: 30, color: Colors.white)
        ],
        ),
      );
  }
}

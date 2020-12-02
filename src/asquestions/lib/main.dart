import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:asquestions/view/controller/NavigatorPage.dart';
import 'package:asquestions/view/pages/LoginPage.dart';
import 'package:provider/provider.dart';
import 'controller/Authenticator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StartApp());
}

class StartApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: Text("Error initializing Firebase"),
            decoration: BoxDecoration(color: Colors.red),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return AsQuestionsApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          decoration: BoxDecoration(color: Colors.blue),
        );
      },
    );
  }
}

class AsQuestionsApp extends StatelessWidget {
  // This widget is the root of your application.
  final CloudFirestoreController firestore = CloudFirestoreController();

  //example user
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authenticator>(create: (context) => Authenticator()),
        StreamProvider(
          create: (context) => context.read<Authenticator>().authStateChanges,
        )
      ],
      child: MaterialApp(
          //debugShowCheckedModeBanner: false,
          title: 'AsQuestions',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(firestore)),
    );
  }
}

class HomePage extends StatelessWidget {
  final CloudFirestoreController _firestore;

  HomePage(this._firestore);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return SignOutPage(_firestore); //NavigatorPage(_firestore);
    } else
      return LoginPage(_firestore);
  }
}

class SignOutPage extends StatelessWidget {
  final CloudFirestoreController _firestore;

  SignOutPage(this._firestore);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              context.read<Authenticator>().signOut();
            },
            child: Text("Sign out"),
          )
        ],
      ),
    ));
  }
}

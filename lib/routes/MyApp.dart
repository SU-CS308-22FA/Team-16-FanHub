import 'package:fl_fan/routes/create_forum.dart';
import 'package:fl_fan/routes/create_post.dart';
import 'package:fl_fan/routes/forum.dart';
import 'package:fl_fan/routes/issue.dart';
import 'package:fl_fan/routes/login.dart';
import 'package:fl_fan/routes/signup.dart';
import 'package:fl_fan/routes/team_login.dart';
import 'package:fl_fan/routes/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:747324314223:web:241fe7dafd16dcd98fb39a',
      apiKey: 'AIzaSyDmkUBkaLVENN6xO96-BjSwpgs_qh6fZcM',
      messagingSenderId: '747324314223',
      projectId: 'fhub-7f73c',
    ),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('No Connection!'),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print('Firebase Connected!');
          return ConnectedFirebase();
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Connecting to firebase...'),
            ),
          ),
        );
      },
    );
  }
}

class ConnectedFirebase extends StatefulWidget {
  const ConnectedFirebase({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<ConnectedFirebase> createState() => _ConnectedFirebaseState();
}

class _ConnectedFirebaseState extends State<ConnectedFirebase> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FanHub App',
      home: Welcome(
          analytics: ConnectedFirebase.analytics,
          observer: ConnectedFirebase.observer),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        'signup': (context) => Signup(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'login': (context) => Login(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'welcome': (context) => Welcome(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'teamsu': (context) => TeamSignup(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'create': (context) => CreatePost(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'forum': (context) => Forum(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'create_forum': (context) => CreateForum(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),
        'issue': (context) => Issue(
              analytics: ConnectedFirebase.analytics,
              observer: ConnectedFirebase.observer,
            ),

        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/second': (context) => const SecondScreen(),
      },
    );
  }
}

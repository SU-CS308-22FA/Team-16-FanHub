import 'package:fl_fan/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool x = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double screenWidth;
    double screenHeight;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _auth.authStateChanges().listen((event) {
      if (event == null) {
        setState(() {
          x = true;
        });
      } else {
        setState(() {
          x = false;
        });
      }
    });

    if (x) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0.5),
          body: Column(
            children: [
              SizedBox(
                height: screenHeight / 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Welcome to FANHUB...',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Signup FanHub to see the brand new campaigns of TFF",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w200,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 2.5,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    fixedSize: Size(screenWidth / 4, screenHeight / 16)),
              ),
              SizedBox(
                height: screenHeight / 32,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signup');
                },
                child: Text('Sign up'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    fixedSize: Size(screenWidth / 4, screenHeight / 16)),
              ),
              SizedBox(
                height: screenHeight / 32,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'admin_login');
                },
                child: const Text(
                  'Are you Admin?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 48,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'teamsu');
                },
                child: const Text(
                  'Are you entering on behalf of a team?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Feed(
        analytics: widget.analytics,
        observer: widget.observer,
      );
    }
  }
}

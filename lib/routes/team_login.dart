import 'package:fl_fan/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'Feed.dart';

class TeamSignup extends StatefulWidget {
  const TeamSignup({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<TeamSignup> createState() => _SignupState();
}

class _SignupState extends State<TeamSignup> {
  AuthService ath = AuthService();
  final _formKey = GlobalKey<FormState>();
  String password = "";
  String name = "";
  String _message = "";

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      if (event == null) {
        print('User is signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  bool x = true;
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
            image: AssetImage('assets/manager.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0.5),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight / 24,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Team Entrance',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth / 4, right: screenWidth / 4),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight / 12,
                          ),
                          const Text(
                            'Team Name',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              if (value != null) {
                                name = value;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              prefixIcon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter team\'s name: ',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Authority ID',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null) {
                                return 'Authority ID field can not be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty) {
                                  return 'Authority ID field can not be empty!';
                                }
                                if (trimmedValue.length < 2) {
                                  return 'Authority ID must be longer than 2 characters!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                password = value;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    30.0,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 10,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your password: ',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight / 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: screenWidth / 5,
                                height: screenHeight / 24,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // ath.loginWithMailAndPass(mail, pass)
                                    }
                                  },
                                  child: Text('Done'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    fixedSize: Size(
                                        screenWidth / 4, screenHeight / 16),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth / 5,
                                height: screenHeight / 24,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'welcome');
                                  },
                                  child: Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    fixedSize: Size(
                                        screenWidth / 4, screenHeight / 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Feed(analytics: widget.analytics, observer: widget.observer);
    }
  }
}

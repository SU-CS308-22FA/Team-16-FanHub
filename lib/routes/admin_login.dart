import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/routes/feed.dart';
import 'package:fl_fan/services/auth.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  AuthService ath = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  int count = 0;
  String token = "";
  String _message = "";
  String name = "";
  String surname = "";
  DBservice db = DBservice();
  FirebaseAuth _auth = FirebaseAuth.instance;

// TODO: show alerts if necessary...
  Future<void> showAlertDialog(String title, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

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
            image: AssetImage('assets/football.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0.5),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight / 12,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth / 4, right: screenWidth / 4),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Email field can not be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty) {
                                  return 'Please enter email!';
                                }
                                if (!EmailValidator.validate(trimmedValue)) {
                                  return 'Please enter a valid email!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                email = value;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(top: 10),
                                prefixIcon: Icon(Icons.account_circle_outlined,
                                    color: Colors.white70),
                                hintText: 'Enter your email: ',
                                hintStyle: TextStyle(color: Colors.white70)),
                          ),
                          SizedBox(
                            height: screenHeight / 24,
                          ),
                          const Text(
                            'Password',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null) {
                                return 'Password field can not be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty) {
                                  return 'Password field can not be empty!';
                                }
                                if (trimmedValue.length < 8) {
                                  return 'Password must be longer than 8 characters!';
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
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: const Color(0xFF000000)),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 10),
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
                                      ath.adminLogin(email, password);
                                    }
                                  },
                                  child: const Text('Login'),
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
                  ),
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

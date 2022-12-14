import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/services/auth.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Issue extends StatefulWidget {
  const Issue({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  AuthService ath = AuthService();
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String desc = "";
  String _message = "";

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
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double screenWidth;
    double screenHeight;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('issue.jpg'),
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
                    'Report your issue below',
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
                          'Issue Title',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Title field can not be empty!';
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return 'Please enter title!';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              title = value;
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
                              hintText: 'Enter title of the issue: ',
                              hintStyle: TextStyle(color: Colors.white70)),
                        ),
                        SizedBox(
                          height: screenHeight / 24,
                        ),
                        const Text(
                          'Describe the issue below',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Description field can not be empty!';
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return 'Description field can not be empty!';
                              }
                              if (trimmedValue.length < 8) {
                                return 'Description must be longer than 8 characters!';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              desc = value;
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
                            hintText: 'Enter your issue description: ',
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
                                    DBservice db = DBservice();
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    db.addIssue(
                                        title, desc, _auth.currentUser!.uid);
                                  }
                                  showAlertDialog('Success',
                                      'Your issue has been successfuly recieved. Expect related response within 2 business days...');
                                },
                                child: const Text('Submit'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  fixedSize:
                                      Size(screenWidth / 4, screenHeight / 16),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 5,
                              height: screenHeight / 24,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.pushNamed(context, 'welcome');
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  fixedSize:
                                      Size(screenWidth / 4, screenHeight / 16),
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
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/UI/issue_tile.dart';
import 'package:fl_fan/models/issue.dart';
import 'package:flutter/material.dart';

class MyIssues extends StatefulWidget {
  const MyIssues({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<MyIssues> createState() => _MyIssuesState();
}

class _MyIssuesState extends State<MyIssues> {
  List<dynamic> my_issues = [];

  void _deleteIssue(List<dynamic> my_issues, IssuePiece issue) async {
    // Static part
    my_issues.remove(issue);
    // DB part
    var _db = await FirebaseFirestore.instance;
    _db.collection('issues').doc(issue.did).delete();
  }

  void _loadUsersIssues(List<dynamic> my_issues_list) async {
    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    var curr_users_issues = await FirebaseFirestore.instance
        .collection('issues')
        // .where('uid', isEqualTo: _user!.uid)
        .get();
    my_issues_list.clear();
    curr_users_issues.docs.forEach(
      (doc) => {
        my_issues_list.add(
          IssuePiece(
            title: doc['title'],
            description: doc['message'],
            uid: doc['uid'],
            did: doc['did'],
          ),
        ),
      },
    );
    print(my_issues_list);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadUsersIssues(my_issues);
  // }

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
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _loadUsersIssues(my_issues);
                });
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.transparent.withOpacity(0.5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 12,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Your Issue History',
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
              Container(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 100,
                  right: MediaQuery.of(context).size.width / 100,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth / 4, right: screenWidth / 4),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Column(
                          children: my_issues
                              .map((my_issue) => IssueTile(
                                    issue: my_issue,
                                    delete: () {
                                      setState(() {
                                        _deleteIssue(my_issues, my_issue);
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                          height: screenHeight / 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: screenWidth / 5,
                              height: screenHeight / 24,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.pushNamed(context, 'welcome');
                                  Navigator.pop(context);
                                },
                                child: Text('Back'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  fixedSize:
                                      Size(screenWidth / 4, screenHeight / 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight / 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

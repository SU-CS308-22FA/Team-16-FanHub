import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/routes/feed.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<dynamic> posts = [];
  FirebaseAuth _auth1 = FirebaseAuth.instance;
  // void _loadFeed(List<dynamic> posts) async {
  //   FirebaseAuth _auth;
  //   User? _user;
  //   _auth = FirebaseAuth.instance;
  //   _user = _auth.currentUser;
  //   print(_user.toString());
  //   if (_user != null) {
  //     var all = await FirebaseFirestore.instance
  //         .collection("posts")
  //         .get()
  //         .catchError((error) => print("Failed to get posts: $error"));

  //     all.docs.forEach(
  //       (doc) => {
  //         posts.add(
  //           Post(
  //             title: doc['title'],
  //             description: doc['description'],
  //             photo: doc['image'],
  //             uid: doc['uid'],
  //             // like_ct: doc['liked_by'].length,
  //           ),
  //         ),
  //       },
  //     );
  //   }
  // }

  final _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  String image_url = "";

  @override
  Widget build(BuildContext context) {
    // void _loadFeed(List<dynamic> posts) async {
    //   FirebaseAuth _auth;
    //   User? _user;
    //   _auth = FirebaseAuth.instance;
    //   _user = _auth.currentUser;
    //   print(_user.toString());
    //   if (_user != null) {
    //     var all = await FirebaseFirestore.instance
    //         .collection("posts")
    //         .get()
    //         .catchError((error) => print("Failed to get posts: $error"));

    //     // all.docs.forEach(
    //     //   (doc) => {
    //     //     posts.add(
    //     //       Post(
    //     //         title: doc['title'],
    //     //         description: doc['description'],
    //     //         photo: doc['image'],
    //     //         uid: doc['uid'],

    //     //         // like_ct: doc['liked_by'].length,
    //     //       ),
    //     //     ),
    //     //   },
    //     // );
    //   }
    // }

    MediaQueryData _mediaQueryData;
    double screenWidth;
    double screenHeight;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/earn.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        //TODO: add actions for help section
        backgroundColor: Colors.transparent.withOpacity(0.4),
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Create Campaign',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
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
                    'Create',
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
                          'Post Title',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Title field can not be empty!';
                            } else {
                              return null;
                            }
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
                              hintText: 'Enter title: ',
                              hintStyle: TextStyle(color: Colors.white70)),
                        ),
                        SizedBox(
                          height: screenHeight / 24,
                        ),
                        const Text(
                          'Description',
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
                              description = value;
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
                            hintText: 'Enter description: ',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight / 24,
                        ),
                        const Text(
                          'Image',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Photo url field can not be empty!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              image_url = value;
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
                            hintText: 'Enter photo url: ',
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
                                    db.addPost(
                                      title,
                                      image_url,
                                      description,
                                      _auth1.currentUser!,
                                    );
                                    // _loadFeed(posts);
                                    Navigator.pushNamed(context, 'welcome');
                                  }
                                },
                                child: const Text('Done'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
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
                                  Navigator.pushNamed(context, 'welcome');
                                },
                                child: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
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

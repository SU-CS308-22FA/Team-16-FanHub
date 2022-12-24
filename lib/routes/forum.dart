import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/UI/forum_post_tile.dart';
import 'package:fl_fan/models/forum_post.dart';
import 'package:fl_fan/services/auth.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';

class Forum extends StatefulWidget {
  const Forum({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<Forum> createState() => _ForumState();
}

List<ForumPost> forum_posts = [];

class _ForumState extends State<Forum> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService ath = AuthService();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void _loadForum(List<dynamic> forum_posts) async {
    var all = await FirebaseFirestore.instance
        .collection("forum_posts")
        .get()
        .catchError((error) => print("Failed to get posts: $error"));
    forum_posts.clear();
    all.docs.forEach(
      (doc) => {
        forum_posts.add(
          ForumPost(
            title: doc['title'],
            description: doc['description'],
            sender_id: doc['sender_id'],
            post_id: doc['post_id'],
            // comments: doc['comments'],
            // comments:doc['comments'] != null ? doc['sender_id'] : 'No Comments',
          ),
        ),
      },
    );
  }

  // void initState() {
  //   // super.initState();
  //   print("init_forum");
  //   // forum_posts = [];
  //   _loadForum(forum_posts);
  // }

  String title = "";
  String description = "";
  String image_url = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double screenWidth;
    double screenHeight;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    Future<void> showAlertDialog(
      String title,
      String message,
      ForumPost post,
    ) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(message),
                  const SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                const Text(
                                  'Post Title',
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
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.only(top: 10),
                                      prefixIcon: Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Enter title: ',
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                ),
                                SizedBox(
                                  height: screenHeight / 24,
                                ),
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xFF000000)),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(top: 10),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Enter description: ',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight / 24,
                                ),
                                const Text(
                                  'Image',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xFF000000)),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(top: 10),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Enter photo url: ',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight / 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 5,
                                      height: screenHeight / 24,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            DBservice db = DBservice();
                                            db.editForumPost(
                                                post, title, description);
                                            // _loadForum(forum_posts);
                                            Navigator.pushNamed(
                                                context, 'forum');
                                          }
                                        },
                                        child: const Text('Done'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          fixedSize: Size(screenWidth / 4,
                                              screenHeight / 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth / 5,
                                      height: screenHeight / 24,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, 'welcome');
                                        },
                                        child: Text('Cancel'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          fixedSize: Size(screenWidth / 4,
                                              screenHeight / 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('/scaf.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        floatingActionButton: IconButton(
          icon: Icon(Icons.ads_click),
          onPressed: () {
            print(forum_posts);
          },
        ),
        backgroundColor: Colors.transparent.withOpacity(0.3),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'create_forum');
              },
              icon: const Icon(Icons.add),
              tooltip: 'Add to Forum!',
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 100,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _loadForum(forum_posts);
                });
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Forum!',
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 100,
            ),
          ],
          title: const Text(
            'FANHUB',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 100,
              right: MediaQuery.of(context).size.width / 100,
            ),
            child: Column(
              children: forum_posts
                  .map((post) => ForumTile(
                        post: post,
                        icon: post.sender_id == _auth.currentUser!.uid
                            ? Icon(Icons.delete)
                            : SizedBox(),
                        delete: () {
                          setState(() {
                            if (post.sender_id == _auth.currentUser!.uid) {
                              // DBservice().deletePost(_auth.currentUser!, post);
                              _loadForum(forum_posts);
                            }
                          });
                        },
                        edit: () {
                          setState(() {
                            if (post.sender_id == _auth.currentUser!.uid) {
                              showAlertDialog('Edit Campaign',
                                  'Edit your campaign here!', post);
                              print('edit selected');
                            }
                          });
                        },
                        editIcon: post.sender_id == _auth.currentUser!.uid
                            ? Icon(Icons.edit)
                            : SizedBox(),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

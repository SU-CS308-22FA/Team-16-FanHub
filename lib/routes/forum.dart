import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/UI/forum_post_tile.dart';
import 'package:fl_fan/models/forum_post.dart';
import 'package:fl_fan/services/auth.dart';
import 'package:flutter/material.dart';

class Forum extends StatefulWidget {
  const Forum({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<Forum> createState() => _ForumState();
}

List<dynamic> forum_posts = [];

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

  @override
  Widget build(BuildContext context) {
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
                  .map((forum_post) => ForumTile(post: forum_post))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

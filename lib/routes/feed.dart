import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/models/post.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../UI/post_tile.dart';
import '../services/auth.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<dynamic> posts = [];
  List<dynamic> following = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService ath = AuthService();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void _loadFeed(List<dynamic> posts) async {
    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    print(_user.toString());
    if (_user != null) {
      // print("c  ${_user.uid}");
      var all = await FirebaseFirestore.instance
          .collection("posts")
          .get()
          .catchError((error) => print("Failed to get posts: $error"));
      // .where('title', isNull: false)
      // print('-------------');
      // print('${all.docs[0]['title']}');
      // print('-------------');
      // print('${all.docs[0]['description']}');
      // print('-------------');
      // print('${all.docs[0]['date']}');
      // print('-------------');
      // print('${all.docs[0]['image']}');

      // posts.add(
      //   Post(
      //     title: '${all.docs[0]['title']}',
      //     description: '${all.docs[0]['description']}',
      //     date: '${all.docs[0]['date']}',
      //     photo: '${all.docs[0]['image']}',
      //   ),
      // );
      // following = all.docs[0]['following'];
      // print("t ${following[0]}");

      all.docs.forEach(
        (doc) => {
          posts.add(
            Post(
              title: doc['title'],
              description: doc['description'],
              // date: all.docs[0]['date'],
              photo: doc['image'],
            ),
          ),
        },
      );
    }
    // var feed_post = await FirebaseFirestore.instance.collection('posts').get();
    // feed_post.docs.forEach(
    //   (doc) => {
    //     if (doc['active'] == "active")
    //       {
    //         print("a"),
    //         posts.add(Post(
    //           title: doc['title'],
    //           description: doc['description'],
    //           date: doc['date'],
    //           photo: doc['photo'],
    //         ))
    //       }
    //   },
    // );
  }

  void initState() {
    super.initState();
    print("init1");
    _loadFeed(posts);
  }

  final pc = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print(_selectedIndex);
      });

      if (_selectedIndex == 2) {
        pc.jumpToPage(1);
      }
      if (_selectedIndex == 3) {
        pc.jumpToPage(2);
      }
    }

    return PageView(
      controller: pc,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('/scaf.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent.withOpacity(0.3),
            //floatingActionButton: FloatingActionButton(child: Text('+'),onPressed: (){_loadFeed();},),//Navigator.pushNamed(context, 'createPost');},),
            //floatingActionButton: FloatingActionButton(child: Text('+'),onPressed: (){ath.signOut();},),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.red,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  ath.signOut();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'create');
                  },
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Campaign',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 100,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  tooltip: 'Jump to Forum',
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
                  children: posts.map((post) => PostTile(post: post)).toList(),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ],
    );
  }
}

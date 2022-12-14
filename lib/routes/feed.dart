import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/models/post.dart';
import 'package:fl_fan/routes/search.dart';
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
      var curr_user = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();
      if (curr_user.docs[0]['is_team']) {
        setState(() {
          // if team entered
          x = 1;
        });
      } else {
        setState(() {
          // if user entered
          x = 2;
        });
      }
      // print("c  ${_user.uid}");
      var all = await FirebaseFirestore.instance
          .collection("posts")
          .get()
          .catchError((error) => print("Failed to get posts: $error"));

      all.docs.forEach(
        (doc) => {
          posts.add(
            Post(
              title: doc['title'],
              description: doc['description'],
              photo: doc['image'],
              // likeCt: doc['like_ct'],
            ),
          ),
        },
      );
    }
  }

  // void getUserDetails() async {
  //   // _auth.authStateChanges().listen((event) async {
  //   //   if (event == null) {
  //   //     setState(() {
  //   //       // if no one is entered
  //   //       x = 0;
  //   //     });
  //   //   }
  //   // });

  //   var curr_user = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('uid', isEqualTo: _auth.currentUser!.uid)
  //       .get();
  //   if (curr_user.docs[0]['is_team']) {
  //     setState(() {
  //       // if team entered
  //       x = 1;
  //     });
  //   } else {
  //     setState(() {
  //       // if user entered
  //       x = 2;
  //     });
  //   }
  //   // print(curr_user.docs[0]['is_team'] == true
  //   //     ? 'It IS A TEAMMMMM!'
  //   //     : 'NOOOOOOO!');
  // }

  void initState() {
    // super.initState();
    print("init_feed");
    // getUserDetails();
    _loadFeed(posts);
  }

  final pc = PageController(initialPage: 0);
  int x = 0;
  @override
  Widget build(BuildContext context) {
    // _auth.authStateChanges().listen((event) async {
    //   if (event == null) {
    //     setState(() {
    //       // if no one is entered
    //       x = 0;
    //     });
    //   } else {
    //     var curr_user = await FirebaseFirestore.instance
    //         .collection('users')
    //         .where('uid', isEqualTo: _auth.currentUser!.uid)
    //         .get();
    //     if (curr_user.docs[0]['is_team']) {
    //       setState(() {
    //         // if team entered
    //         x = 1;
    //       });
    //     } else {
    //       setState(() {
    //         // if user entered
    //         x = 2;
    //       });
    //     }
    //     // print(curr_user.docs[0]['is_team'] == true
    //     //     ? 'It IS A TEAMMMMM!'
    //     //     : 'NOOOOOOO!');
    //   }
    // });

    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print(_selectedIndex);
      });

      if (_selectedIndex == 1) {
        pc.jumpToPage(1);
      }
      if (_selectedIndex == 2) {
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
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.red,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  _auth.signOut();
                  // ath.signOut();
                },
              ),
              actions: [
                x == 1
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'create');
                        },
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Campaign!',
                      )
                    : IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'forum');
                        },
                        icon: const Icon(Icons.forum),
                        tooltip: 'Jump to Forum!',
                      ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 50,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'issue');
                  },
                  icon: Icon(Icons.help),
                  tooltip: 'Need help?',
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
        SearchView(analytics: widget.analytics, observer: widget.observer),
      ],
    );
  }
}

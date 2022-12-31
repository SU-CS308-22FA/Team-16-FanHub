import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/UI/admin_tile.dart';
import 'package:fl_fan/UI/issue_tile.dart';
import 'package:fl_fan/models/issue.dart';
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
  List<Post> posts = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService ath = AuthService();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String title = "";
  String description = "";
  String image_url = "";
  final _formKey = GlobalKey<FormState>();

  List<dynamic> my_issues = [];

  void _deleteIssue(List<dynamic> my_issues, IssuePiece issue) async {
    // Static part
    my_issues.remove(issue);
    // DB part
    var _db = await FirebaseFirestore.instance;
    _db.collection('issues').doc(issue.did).delete();
  }

  void _adminDelete(List<dynamic> my_issues, IssuePiece issue) async {
    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    // Static part
    my_issues.remove(issue);
    // DB part
    var _db = await FirebaseFirestore.instance;
    _db.collection('issues').doc(issue.did).delete();
    _db
        .collection('posts')
        .where('title', isEqualTo: issue.title)
        .where('description', isEqualTo: issue.description)
        // .where('uid', isEqualTo: _user!.uid)
        .get()
        .then(
          (value) =>
              _db.collection('posts').doc(value.docs[0]['post_id']).delete(),
        );

    _db
        .collection('forum_posts')
        .where('title', isEqualTo: issue.title)
        .where('description', isEqualTo: issue.description)
        // .where('uid', isEqualTo: _user.uid)
        .get()
        .then(
          (value) => _db
              .collection('forum_posts')
              .doc(value.docs[0]['post_id'])
              .delete(),
        );
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

  //TODO: issulerı admin için doldur.
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
        if (curr_user.docs[0]['email'] == 'admin@tff.com') {
          // if admin entered
          x = 3;
        } else {
          setState(() {
            // if user entered
            x = 2;
          });
        }
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
              post_id: doc['post_id'],
              uid: doc['uid'],
              // liked_by: doc['liked_by'],
              // like_ct: doc['liked_by'].length,
              // likeCt: doc['like_ct'],
            ),
          ),
        },
      );
      // var liked = await FirebaseFirestore.instance
      //     .collection('users')
      //     .where('uid', isEqualTo: _user.uid)
      //     .where('liked',whereIn: )
      //     .get();
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
    print(posts);
    print('------');
  }

  final pc = PageController(initialPage: 0);
  int x = 0;
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
      Post post,
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
                                            db.editPost(post, title,
                                                description, image_url);
                                            _loadFeed(posts);
                                            Navigator.pushNamed(
                                                context, 'welcome');
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

    if (x == 3) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/issue.jpg'),
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
                                .map((my_issue) => AdminTile(
                                      issue: my_issue,
                                      delete: () {
                                        setState(() {
                                          _deleteIssue(my_issues, my_issue);
                                        });
                                      },
                                      adminDelete: () {
                                        setState(() {
                                          _adminDelete(my_issues, my_issue);
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
                                    ath.signOut();
                                  },
                                  child: Text('Back'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    fixedSize: Size(
                                        screenWidth / 4, screenHeight / 16),
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
    } else {
      return PageView(
        controller: pc,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/scaf.jpg'),
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
                    _auth.signOut();
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
                    children: posts
                        .map((post) => PostTile(
                              post: post,
                              icon: post.uid == _auth.currentUser!.uid
                                  ? Icon(Icons.delete)
                                  : SizedBox(),
                              delete: () {
                                setState(() {
                                  if (post.uid == _auth.currentUser!.uid) {
                                    DBservice()
                                        .deletePost(_auth.currentUser!, post);
                                    _loadFeed(posts);
                                    print(posts);
                                  }
                                });
                              },
                              edit: () {
                                setState(() {
                                  if (post.uid == _auth.currentUser!.uid) {
                                    showAlertDialog('Edit Campaign',
                                        'Edit your campaign here!', post);
                                    print('edit selected');
                                  }
                                });
                              },
                              editIcon: post.uid == _auth.currentUser!.uid
                                  ? Icon(Icons.edit)
                                  : SizedBox(),
                            ))
                        .toList(),
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/UI/post_tile.dart';
import 'package:fl_fan/models/post.dart';
import 'package:fl_fan/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Post> search_list = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService ath = AuthService();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void _loadSearch(trm) async {
    search_list = [];
    var allPosts = await FirebaseFirestore.instance.collection('posts').get();
    allPosts.docs.forEach((doc) => {
          if (doc['title'] == trm || doc['description'] == trm)
            {
              search_list.add(
                Post(
                  title: doc['title'],
                  description: doc['description'],
                  photo: doc['image'],
                ),
              ),
            }
        });
  }

  /*
  void _loadUserSearch(trm) async{
    search_list = [];
    var allUsers = await FirebaseFirestore.instance.collection('users').get();
    allUsers.docs.forEach((doc) {
      if(doc['username'] == trm){
        search_list.add(Search(
            profile: doc['username'],
            text: doc['text'],
            date: doc['date'],
            likeCt: doc['likeCt'],
            commentCt: doc['commentCt'],
            uid: doc['uid']));
      }
    });
  }
*/

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Explore FanHub Campaigns!');

  final _formKey = GlobalKey<FormState>();
  String search_term = "";
  List<Widget> temp = [];

  Widget clmn(List<Post> list) {
    Widget temp = Column(children: []);
    setState(() {
      temp =
          Column(children: list.map((post) => PostTile(post: post)).toList());
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, 'welcome');
            },
          ),
          backgroundColor: Colors.red,
          title: customSearchBar,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextFormField(
                        onChanged: (value) {
                          search_term = value;
                          _loadSearch(search_term);
                          //_loadUserSearch(search_term);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search Campaigns',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Explore FanHub');
                  }
                });
              },
              icon: customIcon,
            )
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 100,
              right: MediaQuery.of(context).size.width / 100,
            ),
            child: clmn(search_list),
          ),
        ),
      ),
    );
  }
}

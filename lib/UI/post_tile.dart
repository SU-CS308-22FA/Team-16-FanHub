import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/models/forum_post.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/post.dart';

class PostTile extends StatefulWidget {
  const PostTile({
    required this.post,
    required this.delete,
    required this.icon,
    required this.editIcon,
    required this.edit,
  });
  final Post post;
  final VoidCallback delete;
  final VoidCallback edit;
  final Widget icon;
  final Widget editIcon;
  // final VoidCallback dislike;
  // final VoidCallback like;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  String _message = "";
  DBservice db = DBservice();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? url1;
  Future getImage() async {
    if (widget.post.photo != null) {
      final ref =
          FirebaseStorage.instance.ref().child('/uploads/${widget.post.photo}');
      print(ref);
      var url = await ref.getDownloadURL();
      url1 = url;
    }
  }

  void _addLike(User user, Post post) async {
    await db.addLike(user, post);
  }

  Future<bool> contains() {
    return db.contains(_auth.currentUser, widget.post);
  }

  void report_post_as_issue(Post post) async {
    db.addIssue(post.title, post.description, _auth.currentUser!.uid);
  }

/*
  void updateLike(String? postid) async {
    var currPost =
        await FirebaseFirestore.instance.collection('posts').doc(postid).get();
    var currLikes = currPost.get('likes');
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(postid)
        .delete();

    bool flag;
    String notID;
    if (currLikes.contains(username)) {
      currLikes.remove(username);
      var collection = FirebaseFirestore.instance.collection('posts');
      print(currLikes);
      collection.doc(postid);
      collection.doc(postid).update({"likes": currLikes});
      collection.doc(postid);
      collection.doc(postid).update({"likeCt": currLikes.length});
      setState(() {
        widget.post.likeCt = currLikes.length;
      });
    } else {
      currLikes.add(username);
      var collection = FirebaseFirestore.instance.collection('posts');
      print(currLikes);
      collection.doc(postid);
      collection.doc(postid).update({"likes": currLikes});
      collection.doc(postid).update({"likeCt": currLikes.length});
      setState(() {
        widget.post.likeCt = currLikes.length;
      });
    }
  }
*/
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

  int like_ct = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeData.dark().cardColor,
      shadowColor: Colors.red,
      elevation: 8,
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width / 18,
        16,
        MediaQuery.of(context).size.width / 18,
        0,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width / 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: widget.edit,
                        icon: widget.editIcon,
                      ),
                      IconButton(
                        tooltip: 'Click to report',
                        color: Colors.red,
                        onPressed: () {
                          report_post_as_issue(widget.post);
                          showAlertDialog(
                              'Your report has been recieved for this post\nYou can display your issues using help tab above corner!',
                              'Issue title: ${widget.post.title} \nIssue description: ${widget.post.description}');
                        },
                        icon: const Icon(Icons.report_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: widget.post.photo != null
                  ? Image(
                      fit: BoxFit.fitHeight,
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      image: NetworkImage(widget.post.photo!))
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.post.description,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: widget.delete,
                  icon: widget.icon,
                ),
                const Spacer(),
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.thumb_up_alt_outlined,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    //widget.updateLike(widget.post.postid),
                    // updateLike(widget.post.postid);
                    _addLike(_auth.currentUser!, widget.post);
                    print(widget.post.post_id);
                    contains();
                  },
                ),
                Text(
                  '$like_ct',
                ),
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.thumb_down_alt_outlined,
                    color: true ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    //widget.updateLike(widget.post.postid),
                    // updateLike(widget.post.postid);
                    setState(() {
                      like_ct--;
                    });
                  },
                ),
              ],
            ),
            // Container(child: url1 != null ? Image.network(url1!) : Text("")),
          ],
        ),
      ),
    );
  }
}

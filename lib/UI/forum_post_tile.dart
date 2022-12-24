import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/models/forum_post.dart';
import 'package:fl_fan/models/post.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';

class ForumTile extends StatefulWidget {
  const ForumTile({
    required this.post,
    required this.delete,
    required this.icon,
    required this.editIcon,
    required this.edit,
  });
  final ForumPost post;
  final VoidCallback delete;
  final VoidCallback edit;
  final Widget icon;
  final Widget editIcon;

  @override
  State<ForumTile> createState() => _PostTileState();
}

class _PostTileState extends State<ForumTile> {
  DBservice db = DBservice();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void report_post_as_issue(ForumPost post) async {
    db.addIssue(post.title, post.description, _auth.currentUser!.uid);
  }

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
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                Spacer(),
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.thumb_up_alt_outlined,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    //widget.updateLike(widget.post.postid),
                    // updateLike(widget.post.postid);
                    setState(() {
                      like_ct++;
                    });
                  },
                ),
                Text(
                  '$like_ct',
                ),
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.thumb_down_alt_outlined,
                    color: Colors.red,
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
          ],
        ),
      ),
    );
  }
  // void initState() {
  //   super.initState();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     color: ThemeData.dark().cardColor,
  //     shadowColor: Colors.red,
  //     elevation: 8,
  //     margin: EdgeInsets.fromLTRB(
  //       MediaQuery.of(context).size.width / 18,
  //       16,
  //       MediaQuery.of(context).size.width / 18,
  //       0,
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(
  //         MediaQuery.of(context).size.width / 36,
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               widget.post.title,
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 18,
  //           ),
  //           Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               widget.post.description,
  //               style: const TextStyle(fontSize: 18),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

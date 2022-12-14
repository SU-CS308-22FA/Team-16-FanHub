import 'package:fl_fan/models/forum_post.dart';
import 'package:flutter/material.dart';

class ForumTile extends StatefulWidget {
  const ForumTile({required this.post});
  final ForumPost post;

  @override
  State<ForumTile> createState() => _PostTileState();
}

class _PostTileState extends State<ForumTile> {
  // void initState() {
  //   super.initState();
  // }
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

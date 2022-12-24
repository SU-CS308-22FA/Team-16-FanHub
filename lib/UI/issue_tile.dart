import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/models/issue.dart';
import 'package:fl_fan/services/db.dart';
import 'package:flutter/material.dart';

class IssueTile extends StatefulWidget {
  const IssueTile({required this.issue, required this.delete});
  final IssuePiece issue;
  final VoidCallback delete;

  @override
  State<IssueTile> createState() => _IssueTileState();
}

class _IssueTileState extends State<IssueTile> {
  DBservice db = DBservice();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeData.dark().cardColor,
      shadowColor: Colors.blue,
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
                widget.issue.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.issue.description,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            IconButton(
              onPressed: widget.delete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

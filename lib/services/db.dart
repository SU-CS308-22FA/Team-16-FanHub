import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBservice {
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  Future addPost(
      // String poster,
      String title,
      String photo,
      String description
      // String date,
      // int likeCt,
      // List comments,
      // int commentCt,
      // String active,
      ) async {
    postCollection
        .add({
          // 'poster': poster,
          'title': title,
          'description': description,
          'image': photo,
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  final CollectionReference issueCollection =
      FirebaseFirestore.instance.collection('issues');
  Future addIssue(
    String title,
    String message,
    String uid,
  ) async {
    issueCollection
        .add({
          // 'poster': poster,
          'title': title,
          'message': message,
          'uid': uid,
        })
        .then((value) => print("Issue Sent!"))
        .catchError((error) => print("Failed to add issue: $error"));
  }

  final CollectionReference forumPostCollection =
      FirebaseFirestore.instance.collection('forum_posts');
  Future addForumPost(
    // String poster,
    String title,
    String description,
    String sender_id,
    // String date,
    // int likeCt,
    // List comments,
    // int commentCt,
    // String active,
  ) async {
    forumPostCollection
        .add({
          // 'poster': poster,
          'title': title,
          'description': description,
          'sender_id': sender_id,
          'comments': 0,
        })
        .then((value) => print("Forum Post Added"))
        .catchError((error) => print("Failed to add forum post: $error"));
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future addUser(String name, String email, String password, bool is_team,
      String uid) async {
    userCollection
        .doc(email)
        .set({
          'name': name,
          'email': email,
          'password': password,
          'is_team': is_team,
          'uid': uid,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

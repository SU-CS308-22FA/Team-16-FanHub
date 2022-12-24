import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/models/post.dart';
import 'package:flutter/material.dart';

class DBservice {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference likedCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference issueCollection =
      FirebaseFirestore.instance.collection('issues');
  final CollectionReference forumPostCollection =
      FirebaseFirestore.instance.collection('forum_posts');
  var likedCollection_1 = FirebaseFirestore.instance.collection('users');
  List<dynamic> likeds = [];

  Future editPost(
    Post post,
    String title,
    String description,
    String image,
  ) async {
    postCollection.doc(post.post_id).set(
      {
        'title': title,
        'description': description,
        'image': image,
      },
      SetOptions(merge: true),
    );
  }

  Future<bool> contains(User? user, Post post) async {
    List<dynamic>? temp;
    await likedCollection_1
        .doc(user!.email)
        .get()
        .then((value) => temp = (value.get('liked')));
    if (temp!.contains(post.post_id)) {
      print('yes contains');
      return true;
    } else {
      print('no it does not contain');
      return false;
    }
  }

  Future<List<dynamic>?> addLike(
    User user,
    Post post,
  ) async {
    print('User: ${user.uid} Post_id: ${post.post_id}');

    await likedCollection_1
        .doc(user.email)
        .get()
        .then((value) => likeds = (value.get('liked')));

    likeds += [post.post_id];

    await likedCollection
        .doc(user.email)
        .set({'liked': likeds}, SetOptions(merge: true));

    return likeds;
  }

  Future deletePost(User user, Post post) async {
    postCollection.doc(post.post_id).delete();
  }

  Future addPost(
    String title,
    String photo,
    String description,
    User user,
  ) async {
    postCollection
        .add({
          'title': title,
          'description': description,
          'image': photo,
          'post_id': null,
          'uid': user.uid,
        })
        .then(
          (value) => value.set({
            'title': title,
            'post_id': value.id,
            'description': description,
            'image': photo,
            'uid': user.uid,
          }),
        )
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future addIssue(
    String title,
    String message,
    String uid,
  ) async {
    issueCollection
        .add({
          'title': title,
          'message': message,
          'uid': uid,
        })
        .then((value) => value.set({
              'did': value.id,
              'title': title,
              'message': message,
              'uid': uid,
            }))
        .catchError((error) => print("Failed to add issue: $error"));
  }

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
          'liked': [],
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

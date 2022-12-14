import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_fan/services/db.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBservice db = DBservice();

  User? _userFromFirebase(User? user) {
    return user ?? null;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signUpTeam(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      db.addUser(name, email, password, true, userCredential.user!.uid);
      print(userCredential.toString());
    } on FirebaseException catch (e) {
      print(e.toString());
      if (e.code == 'email-already-in-use') {
        print('Email already exists!');
      } else if (e.code == 'weak-password') {
        print('Weak password: add uppercase, lowercase, special char');
      }
    }
  }

  Future<void> signUpUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      db.addUser(name, email, password, false, userCredential.user!.uid);
      print(userCredential.toString());
    } on FirebaseException catch (e) {
      print(e.toString());
      if (e.code == 'email-already-in-use') {
        print('Email already exists!');
      } else if (e.code == 'weak-password') {
        print('Weak password: add uppercase, lowercase, special char');
      }
    }
  }

  Future loginWithMailAndPass(String mail, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

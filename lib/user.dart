import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  User(this.firebaseUser, this.data);

  FirebaseUser firebaseUser;
  Map data;

  static DocumentReference getReference(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return Firestore.instance.collection("users").document(firebaseUser.uid);
  }
}

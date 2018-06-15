import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  User(this.firebaseUser, DocumentSnapshot snapshot) {
    address = snapshot.exists && snapshot.data != null
        ? snapshot.data['address']
        : null;
  }

  FirebaseUser firebaseUser;
  String address;

  static DocumentReference getRef(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return Firestore.instance.collection('users').document(firebaseUser.uid);
  }

  static DocumentReference getAddressRef(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return getRef(firebaseUser).collection('triggers').document('address');
  }

  static DocumentReference getFavCandidatesRef(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return getRef(firebaseUser).collection('favs').document('candidates');
  }
}

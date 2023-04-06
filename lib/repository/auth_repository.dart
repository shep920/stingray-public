import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hero/models/models.dart';

import 'package:hero/repository/firestore_repository.dart';

class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  Future<User?> signUp(
      {required String email, required String password}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    final user = User.genericUser(credential.user!.uid);

    await FirestoreRepository().updateUserData(
      //set all of the user data here
      user: user,
    );

    return user;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  auth.User? get otherUser => _firebaseAuth.currentUser;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(userFromFirebaseUser);
  }

  Stream<auth.User?> get authUser {
    return _firebaseAuth.authStateChanges();
  }

  User? userFromFirebaseUser(auth.User? user) {
    return user != null ? User.genericUser(user.uid) : null;
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get receiveTheUser {
    return firebaseAuth.authStateChanges();
  }

  Future logout() async {
    try {
      await firebaseAuth.signOut();
      return 'success';
    } catch (e) {
      return null;
    }
  }

  Future signup(String? email, String? password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      User? user;
      user = userCredential.user;
      return user != null ? user : null;
    } catch (e) {
      return null;
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential? userCredential;
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user;
      user = userCredential.user;
      return user != null ? user : null;
    } catch (e) {
      return null;
    }
  }
}

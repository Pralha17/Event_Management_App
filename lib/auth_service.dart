import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'email': email,
        'role': role.toLowerCase(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during sign up: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during sign in: $e');
      return null;
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc.get('role');
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  // New logout method
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email, 
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password);
    } on FirebaseAuthException catch (e) {
      // Print error details to help diagnose the issue
      print("FirebaseAuthException code: ${e.code}");
      print("FirebaseAuthException message: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unknown error: $e");
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email, 
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Print error details to help diagnose the issue
      print("FirebaseAuthException code: ${e.code}");
      print("FirebaseAuthException message: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unknown error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}
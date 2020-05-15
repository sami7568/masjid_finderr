import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  final _auth = FirebaseAuth.instance;

  createAccount(email, pass) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
    } catch (e) {
      print('Exception @createAccount: $e');
    }
  }

  signIn(email, pass) {}

  logout() {}
}

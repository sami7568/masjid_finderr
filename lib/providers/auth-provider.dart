import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  bool _isLogin = false;
  bool _isImam = false;
  FirebaseUser _user;
  AuthResultStatus _status;

  ///
  /// *** Getters ***
  ///
  /// Login status variables are made private, so that
  /// they are not changed unintentionally from any other
  /// Except this AuthProvider class with proper protocol
  ///
  FirebaseUser get user => _user;

  bool get isImam => _isImam;

  bool get isLogin => _isLogin;

  ///
  /// Helper Functions
  ///

  void createAccount(email, pass, isImam) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      if (authResult.user != null) {
        _isLogin = true;
        _status = AuthResultStatus.successful;
        _user = authResult.user;
        _isImam = isImam;

        //Todo: Create user in the firestore as well
      } else {
        _status = AuthResultStatus.successful;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    notifyListeners();
  }

  void login({email, pass, isImam}) async {
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        // Todo: Check user in the relevant firestore collection as well.

        _isLogin = true;
        _status = AuthResultStatus.successful;
        _user = authResult.user;
        _isImam = isImam;
      } else {
        _status = AuthResultStatus.successful;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    notifyListeners();
  }

  logout() {
    _auth.signOut();
    _isLogin = false;
    _isImam = false;
    _user = null;

    notifyListeners();
  }
}

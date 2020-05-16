import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/models/user-model.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool loginInProgress = false;

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

  AuthResultStatus get status => _status;

  ///
  /// Helper Functions
  ///

  Future<void> createAccount({user, isImam = false}) async {
//    setLoginInProgress();
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      if (authResult.user != null) {
        _isLogin = true;
        _status = AuthResultStatus.successful;
        _user = authResult.user;
        _isImam = isImam;
        _status = AuthResultStatus.successful;

        //Todo: Create user in the firestore as well
//        if (isImam) {
//          FirestoreHelper.createImamAccount();
//        } else {
//          FirestoreHelper.createUserAccount();
//        }
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    unSetLoginInProgress();
    notifyListeners();
  }

  void setLoginInProgress() {
    loginInProgress = true;
    print('Login in Progress: $loginInProgress)');
    notifyListeners();
  }

  void unSetLoginInProgress() {
    loginInProgress = false;
    print('Login in Progress: $loginInProgress)');
    notifyListeners();
  }

  Future<void> login({email, pass, isImam = false}) async {
//    setLoginInProgress();
    loginInProgress = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 4));
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
    loginInProgress = false;
//    unSetLoginInProgress();
    notifyListeners();
  }

  logout() {
    setLoginInProgress();
    _auth.signOut();
    _isLogin = false;
    _isImam = false;
    _user = null;

    unSetLoginInProgress();
    notifyListeners();
  }
}

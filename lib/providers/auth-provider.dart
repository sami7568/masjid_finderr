import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/enums/user-type.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/services/sharedPrefs-helper.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestoreHelper = FirestoreHelper();
  final _sharedPrefsHelper = SharePrefHelper();
  bool loginInProgress = false;

  bool _isLogin = false;
  UserType _userType;
  FirebaseUser _user;
  AuthResultStatus _status;

  AuthProvider() {
    print('@AuthProvider');
    _userType = _sharedPrefsHelper.getUserType();
    print('userType: $_userType');
    _auth.onAuthStateChanged.listen((firebaseUser) {
      _user = firebaseUser;
//      print(_user.email);
      if (_user != null) {
        _isLogin = true;
//        print('Login status: $_isLogin');
      } else
        _isLogin = false;
      notifyListeners();
      print('@AuthProvider: Login state changed: $isLogin');
    });
    print('User Login status: $_isLogin');
  }

  ///
  /// *** Getters ***
  ///
  /// Login status variables are made private, so that
  /// they are not changed unintentionally from any other
  /// Except this AuthProvider class with proper protocol
  ///
  FirebaseUser get user => _user;

  bool get isLogin => _isLogin;

  AuthResultStatus get status => _status;

  UserType get userType => _userType;

  ///
  /// setters
  ///
  setAsImam() {
    _userType = UserType.imam;
    _sharedPrefsHelper.setAsImam();
    notifyListeners();
  }

  setAsUser() {
    _userType = UserType.user;
    _sharedPrefsHelper.setAsUser();
    notifyListeners();
  }

  ///
  /// Helper Functions
  ///

  Future<void> createAccount({user, isImam = false}) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
        _firestoreHelper.createUser(
            user: user, userId: _user.uid, isImam: isImam);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

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
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        /// If user logs in as an Imam, check if user account was also
        /// created as Imam. If successful, go ahead otherwise logout
        /// from firebase auth.

        _firestoreHelper.createFcmToken(authResult.user.uid);
        if (userType == UserType.imam) {
          final status = await _firestoreHelper.checkIfImam(_user.uid);
          if (status) {
            _status = AuthResultStatus.successful;
          } else {
            logout();
            _status = AuthResultStatus.notImam;
          }
        }

        /// If user logs in as a general user, check if user account was also
        /// created as general user. If successful, go ahead otherwise logout
        /// from firebase auth.
        if (userType == UserType.user) {
          final status = await _firestoreHelper.checkIfUser(_user.uid);
          if (status) {
            _status = AuthResultStatus.successful;
          } else {
            logout();
            _status = AuthResultStatus.notImam;
          }
        }
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();
  }

  logout() {
    _auth.signOut();
    notifyListeners();
  }

//  @override
//  void dispose() {
//    // Todo: Dispose listeners and streams
//    super.dispose();
//  }
}

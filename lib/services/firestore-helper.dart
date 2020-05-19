import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'dart:io';

class FirestoreHelper {
  final _db = Firestore.instance;
  final _userCollection = 'users';
  final _imamCollection = 'imams';
  final _masjidCollection = 'masjid';
  final _registerMasjidCollection = 'registerMasjid';
  Stream<String> fcmStream;

  Future<List<Masjid>> getAllMasjid() {
    List<Masjid> _list = [];
    return _db.collection(_masjidCollection).getDocuments().then(
      (querySnapshot) {
        querySnapshot.documents.forEach((f) {
          Masjid newMasjid = new Masjid.fromJson(f);
          _list.add(newMasjid);
        });
        return _list;
      },
    );
  }

  createUser({user, userId, isImam = false}) async {
    try {
      await isImam
          ? _db
              .collection(_imamCollection)
              .document(userId)
              .setData(user.toJson())
          : _db
              .collection(_userCollection)
              .document(userId)
              .setData(user.toJson());
      if (!isImam) createFcmToken(userId);
    } catch (e) {
      print('Exception @createUser: $e');
    }
  }

  createFcmToken(userId) async {
    try {
      print('@createFcmToken');
      FirebaseMessaging fcm = FirebaseMessaging();
      final fcmToken = await fcm.getToken();
      DocumentReference fcmRef = _db
          .collection(_userCollection)
          .document(userId)
          .collection('fcm_tokens')
          .document(fcmToken);
      final snapshot = await fcmRef.get();

      if (snapshot.data == null) {
        await fcmRef.setData({
          'platform': Platform.operatingSystem,
          'fcmToken': fcmToken,
          'timeStamp': FieldValue.serverTimestamp(),
        });
        print('@createFcm: FCM generated');
      }
    } catch (e) {
      print('Exception @createFcmToken: $e');
    }
  }

  Future<bool> checkIfUser(userId) async {
    try {
      final snapshot =
          await _db.collection(_userCollection).document(userId).get();
      if (snapshot.data != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception @checkIfUser: $e');
      return null;
    }
  }

  Future<bool> checkIfImam(userId) async {
    try {
      final snapshot =
          await _db.collection(_imamCollection).document(userId).get();
      if (snapshot.data != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception @checkIfUser: $e');
      return null;
    }
  }

  createMasjid({Masjid masjid, uid}) async {
    print('@createMasjid');
    print('${masjid.toJson()}');
    try {
      await _db
          .collection(_masjidCollection)
          .document(uid)
          .setData(masjid.toJson());
    } catch (e) {
      print('Exception @creatMasjid: $e');
    }
  }
}

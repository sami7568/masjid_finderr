import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class FirestoreHelper {
  final _db = Firestore.instance;
  final _userCollection = 'users';
  final _imamCollection = 'imams';
  final _masjidCollection = 'masjid';
  final _subscribersCollection = 'subscribers';
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

  updateNamazTime({Masjid masjid, uid}) async {
    print('@updateNamazTime');
    print('${masjid.toJson()}');
    try {
      await _db
          .collection(_masjidCollection)
          .document(uid)
          .updateData(masjid.toJson());
    } catch (e) {
      print('Exception @creatMasjid: $e');
    }
  }

  getMasjid(uid) async {
    try {
      final snapshot = await _db.collection('masjid').document(uid).get();
      if (snapshot != null)
        return Masjid.fromJson(snapshot);
      else
        return null;
    } catch (e) {
      print('Exception @getMasjid: $e');
      return null;
    }
  }

  Future<List<Masjid>> getJamiaMasjidList() async {
    try {
      final snapshot = await _db
          .collection(_masjidCollection)
          .where('isJamiaMasjid', isEqualTo: true)
          .limit(10)
          .getDocuments();
      print(
          '@getJamiaMasjidList: Masjids count is ${snapshot.documents.length}');
      if (snapshot.documents.length > 0) {
        return snapshot.documents.map((masjidData) {
          return Masjid.fromJson(masjidData);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Exception @getJamiaMasjidList: $e');
      return [];
    }
  }

  Future<List<DocumentSnapshot>> getSubscribers(uid) async {
    print('@getSubscribers');
    try {
      final snapshot = await _db
          .collection(_subscribersCollection)
          .where('masjidId', isEqualTo: uid)
          .getDocuments();
      return snapshot.documents;
    } catch (e) {
      print('Exception @getSubscribers: $e');
      return [];
    }
  }

  Future<bool> followMosque({Masjid masjid, FirebaseUser user}) async {
    try {
      final snapshot = await _db
          .collection(_subscribersCollection)
          .where('userId', isEqualTo: user.uid)
          .where('masjidId', isEqualTo: masjid.firestoreId)
          .getDocuments();
      if (snapshot.documents.length == 0) {
        await _db.collection(_subscribersCollection).add({
          'userId': user.uid,
          'masjidId': masjid.firestoreId,
          'fullName': user.displayName,
//          'address': 'User address',
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exceptin @followMosque: $e');
      return false;
    }
  }
}

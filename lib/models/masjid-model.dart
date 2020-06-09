import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:masjid_finder/models/prayer-time-model.dart';

class Masjid {
  String name;
  String address;
  GeoFirePoint position;
  bool isJamiaMasjid;
  bool isFollowing;
  PrayerTime prayerTime;
  int subscribers;
  String status;
  String firestoreId;

  Masjid({
    this.name = 'Masjid Name',
    this.address = 'Address here',
    this.position,
    this.isJamiaMasjid = false,
    this.isFollowing = false,
    this.subscribers,
    this.status = 'applied',
  }) {
    this.prayerTime = PrayerTime();
  }

  Masjid.fromJson(DocumentSnapshot snapshot) {
    final masjidData = snapshot.data;
    this.firestoreId = snapshot.reference.documentID;
    this.name = masjidData['name'];
    this.address = masjidData['address'];
    this.position = GeoFirePoint(
      masjidData['position']['geopoint'].latitude,
      masjidData['position']['geopoint'].longitude,
    );
    this.isJamiaMasjid = masjidData['isJamiaMasjid'];
    this.isFollowing = masjidData['isFollowing'];
    this.subscribers = masjidData['subscribers'];
    this.prayerTime = PrayerTime.fromJSON(masjidData['prayerTime']);
    this.status = masjidData['status'];
    print(this.toJson());
  }

  toJson() {
    return {
      'name': this.name,
      'address': this.address,
      'position': this.position.data,
      'isJamiaMasjid': this.isJamiaMasjid,
      'subscribers': this.subscribers,
      'status': this.status,
      'prayerTime': prayerTime.toJSON(),
      'isFollowing': this.isFollowing,
    };
  }
}

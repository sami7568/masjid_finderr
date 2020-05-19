import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:masjid_finder/models/prayer-time-model.dart';

class Masjid {
  String name;
  String address;
  GeoFirePoint position;
  bool isJamiaMasjid;
  PrayerTime prayerTime;
  int subscribers;
  String status;

  Masjid({
    this.name = 'Masjid Name',
    this.address = 'Address here',
    this.position,
    this.isJamiaMasjid,
    this.subscribers,
    this.status = 'applied',
  }) {
    this.prayerTime = PrayerTime();
  }

  Masjid.fromJson(masjidData) {
    this.name = masjidData['name'];
    this.address = masjidData['address'];
    this.position = GeoFirePoint(
        masjidData['position']['latitude'], masjidData['position']['latitude']);
    this.isJamiaMasjid = masjidData['isJamiaMasjid'];
    this.subscribers = masjidData['subscribers'];
    this.prayerTime = PrayerTime.fromJSON(masjidData['prayerTime']);
    this.status = masjidData['status'];
  }

  toJson() {
    return {
      'name': this.name,
      'address': this.address,
      'geoLocation': this.position.data,
      'isJamiaMasjid': this.isJamiaMasjid,
      'subscribers': this.subscribers,
      'status': this.status,
      'prayerTime': prayerTime.toJSON(),
    };
  }
}

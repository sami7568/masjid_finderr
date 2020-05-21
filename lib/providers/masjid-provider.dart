import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/services/firestore-helper.dart';

class MasjidProvider extends ChangeNotifier {
  Masjid masjid = Masjid(position: GeoFirePoint(null, null));
  bool locationAdded = false;

  MasjidProvider() {
    print('@MasjidProvder');
  }

//  _getInitialMasjidData() async {
//    final snapshot = FirestoreHelper().getMasjidData();
//  }

  setLocationAddedFlat() {
    locationAdded = true;
    notifyListeners();
  }

  setFajarTime(String time) {
    masjid.prayerTime.fajar = time;
    notifyListeners();
  }

  setZuharTime(String time) {
    masjid.prayerTime.zuhar = time;
    notifyListeners();
  }

  setAsarTime(String time) {
    masjid.prayerTime.asar = time;
    notifyListeners();
  }

  setMaghribTime(String time) {
    masjid.prayerTime.maghrib = time;
    notifyListeners();
  }

  setIshaTime(String time) {
    masjid.prayerTime.isha = time;
    notifyListeners();
  }

  setJummahTime(String time) {
    masjid.prayerTime.jummah = time;
    notifyListeners();
  }

  createMasjidInDb(uid) {
    FirestoreHelper().createMasjid(masjid: this.masjid, uid: uid);
  }

  updateNamazTime(uid) {
    FirestoreHelper().updateNamazTime(masjid: this.masjid, uid: uid);
  }
}

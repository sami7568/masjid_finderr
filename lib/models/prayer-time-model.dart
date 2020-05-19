class PrayerTime {
  String fajar, zuhar, asar, maghrib, isha, jummah;

  PrayerTime({
    this.fajar,
    this.zuhar,
    this.asar,
    this.maghrib,
    this.isha,
    this.jummah,
  });

  PrayerTime.fromJSON(prayerData) {
    this.fajar = prayerData['fajar'];
    this.zuhar = prayerData['zuhar'];
    this.asar = prayerData['asar'];
    this.maghrib = prayerData['maghrib'];
    this.isha = prayerData['isha'];
    this.jummah = prayerData['jummah'];
  }

  toJSON() {
    return {
      'fajar': this.fajar,
      'zuhar': this.zuhar,
      'asar': this.asar,
      'maghrib': this.maghrib,
      'isha': this.isha,
      'jummah': this.jummah
    };
  }
}

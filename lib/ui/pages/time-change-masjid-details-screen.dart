import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/directions-helper.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/services/geolocator-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-outlined-button.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-blue-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-alert-dialog.dart';
import 'package:masjid_finder/ui/custom_widgets/login-alert-dialog.dart';
import 'package:masjid_finder/ui/custom_widgets/logo.dart';
import 'package:masjid_finder/ui/custom_widgets/time-change-alert-dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class TimeChangeMasjidDetailsScreen extends StatefulWidget {
  final isAlertRequired;
  final title;
  final body;

  TimeChangeMasjidDetailsScreen(
      {this.isAlertRequired = false, this.title, this.body});

  @override
  _TimeChangeMasjidDetailsScreenState createState() =>
      _TimeChangeMasjidDetailsScreenState();
}

class _TimeChangeMasjidDetailsScreenState
    extends State<TimeChangeMasjidDetailsScreen> {
  bool isFollowed = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Position currentLocation;
  bool showProgressHud = false;

  @override
  void initState() {
    if (widget.isAlertRequired) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAlertDialog());
    }
    if (Provider.of<AuthProvider>(context, listen: false).isLogin) {
      FirestoreHelper()
          .checkIfFollowed(
              masjid:
                  Provider.of<MasjidProvider>(context, listen: false).masjid,
              user: Provider.of<AuthProvider>(context, listen: false).user)
          .then((status) {
        setState(() {
          isFollowed = status;
        });
      });
    }
    super.initState();
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      child: TimeChangeAlertDialog(
        title: widget.title,
        body: widget.body,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgressHud,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: _body(context),
          ),
        ),
        backgroundColor: greyBgColor,
      ),
    );
  }

  _body(context) {
    return Column(
      children: <Widget>[
        _header(),
        _basicInfo(context),
        _prayerTimings(),
      ],
    );
  }

  _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.subject,
            color: mainThemeColor,
          ),
          Logo(color: mainThemeColor),
          Container(),
        ],
      ),
    );
  }

  _basicInfo(context) {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Container(
        padding: EdgeInsets.only(left: 24, right: 32),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(masjidProvider.masjid.name, style: subHeadingTextStyle),
                  SizedBox(height: 10),
                  masjidProvider.masjid.isJamiaMasjid
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: orangeColor, width: 2)),
                          child: Text(
                            masjidProvider.masjid.name,
                            style: jamiaMasjidTS,
                          ),
                        )
                      : Container(),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isFollowed
                      ? CustomBlueButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.notifications,
                                  color: Colors.white, size: 17),
                              SizedBox(width: 4),
                              Text('Subscribed', style: blackBtnTS),
                            ],
                          ),
                          onPressed: () {
                            _unFollowMosque(context);
                          },
                        )
                      : CustomBlackButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.notifications,
                                  color: Colors.white, size: 17),
                              SizedBox(width: 4),
                              Text('Subscribe', style: blackBtnTS),
                            ],
                          ),
                          onPressed: () {
                            _followMosque(context);
                          },
                        ),
                  Text(
                    '${masjidProvider.masjid.subscribers ?? 0} subscribers',
                    style: subscribersTS,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _followMosque(context) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLogin) {
      _showSnackBar('You have successfully subscribed the mosque');
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      final masjid = Provider.of<MasjidProvider>(context, listen: false).masjid;
      setState(() {
        isFollowed = true;
      });
      FirestoreHelper().followMosque(masjid: masjid, user: user);
    } else {
      _showLoginAlert(context);
    }
  }

  _unFollowMosque(context) async {
    _showSnackBar('You have successfully unsubscribed the mosque');
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final masjid = Provider.of<MasjidProvider>(context, listen: false).masjid;
    setState(() {
      isFollowed = false;
    });
    FirestoreHelper().unFollowMosque(masjid: masjid, user: user);
  }

  _showLoginAlert(context) {
    showDialog(context: context, child: CustomLoginAlert());
  }

  _prayerTimings() {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 27, 30, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Location', style: subHeadingTextStyle),
                    SizedBox(height: 10),
                    Text(masjidProvider.masjid.address,
                        style: mainBodyTextStyle),
                  ],
                ),
                CustomBlackOutlinedButton(
                  child: Text(
                    'Direction',
                    style: blackBtnTS.copyWith(color: Colors.black),
                  ),
                  onPressed: () async {
                    setState(() {
                      showProgressHud = true;
                    });
                    await _getCurrentLocation();
                    setState(() {
                      showProgressHud = true;
                    });
                    DirectionsHelper().navigate(
                        origin: LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        destination: LatLng(
                            masjidProvider.masjid.position.geoPoint.latitude,
                            masjidProvider.masjid.position.geoPoint.longitude));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 15),
            child: Text('Prayer Timings', style: subHeadingTextStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 10, top: 9),
            child: Text('Subscribe to get notified of change in timings.'),
          ),
          namazTile(
              namazType: 'Fajar',
              iconUrl: 'assets/static_assets/fajar.png',
              time: masjidProvider.masjid.prayerTime.fajar ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Zuhar',
              iconUrl: 'assets/static_assets/zuhar.png',
              time: masjidProvider.masjid.prayerTime.zuhar ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Asar',
              iconUrl: 'assets/static_assets/asar.png',
              time: masjidProvider.masjid.prayerTime.asar ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Maghrib',
              iconUrl: 'assets/static_assets/maghrib.png',
              time: masjidProvider.masjid.prayerTime.maghrib ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Isha',
              iconUrl: 'assets/static_assets/isha.png',
              time: masjidProvider.masjid.prayerTime.isha ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Jummah',
              iconUrl: 'assets/static_assets/jummah.png',
              time: masjidProvider.masjid.prayerTime.jummah ?? 'Add Time',
              context: context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  namazTile({iconUrl, namazType, time, context}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                iconUrl,
                width: 30,
                height: 16,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 15),
              Text(namazType, style: namazTypeTS),
            ],
          ),
          Row(children: <Widget>[
//            Consumer<MasjidProvider>(
//              builder: (context, masjidProvider, child) => IconButton(
//                icon: Icon(Icons.mode_edit, color: Colors.black),
//                onPressed: () async {
//                  TimeOfDay time = await showTimePicker(
//                      context: context,
//                      initialTime: TimeOfDay(hour: 12, minute: 00));
////                  print(time.format(context));
//                  if (time != null) {
//                    var currentTime;
//                    bool status = false;
//                    final updatedNamazTime = time.format(context);
//                    switch (namazType) {
//                      case 'Fajar':
//                        currentTime = masjidProvider.masjid.prayerTime.fajar;
//                        status = await _showTimeChangeAlert(
//                            context: context,
//                            currentTime: currentTime,
//                            updatedTime: updatedNamazTime,
//                            namazType: namazType);
//                        print('Alert dialog closed with status: $status');
//                        if (status) {
//                          masjidProvider.setFajarTime(updatedNamazTime);
//                          masjidProvider.updateNamazTime(
//                              Provider.of<AuthProvider>(context, listen: false)
//                                  .user
//                                  .uid);
//                        }
//                        break;
//                      case 'Zuhar':
//                        currentTime = masjidProvider.masjid.prayerTime.zuhar;
//                        status = await _showTimeChangeAlert(
//                            context: context,
//                            currentTime: currentTime,
//                            updatedTime: updatedNamazTime,
//                            namazType: namazType);
//                        print('Alert dialog closed with status: $status');
//                        if (status) {
//                          masjidProvider.setZuharTime(updatedNamazTime);
//                          masjidProvider.updateNamazTime(
//                              Provider.of<AuthProvider>(context, listen: false)
//                                  .user
//                                  .uid);
//                        }
//                        break;
//                      case 'Asar':
//                        currentTime = masjidProvider.masjid.prayerTime.asar;
//                        status = await _showTimeChangeAlert(
//                            context: context,
//                            currentTime: currentTime,
//                            updatedTime: updatedNamazTime,
//                            namazType: namazType);
//                        print('Alert dialog closed with status: $status');
//                        if (status) {
//                          masjidProvider.setAsarTime(updatedNamazTime);
//                          masjidProvider.updateNamazTime(
//                              Provider.of<AuthProvider>(context, listen: false)
//                                  .user
//                                  .uid);
//                        }
//                        break;
//                      case 'Maghrib':
//                        currentTime = masjidProvider.masjid.prayerTime.maghrib;
//                        status = await _showTimeChangeAlert(
//                            context: context,
//                            currentTime: currentTime,
//                            updatedTime: updatedNamazTime,
//                            namazType: namazType);
//                        print('Alert dialog closed with status: $status');
//                        if (status) {
//                          masjidProvider.setMaghribTime(updatedNamazTime);
//                          masjidProvider.updateNamazTime(
//                              Provider.of<AuthProvider>(context, listen: false)
//                                  .user
//                                  .uid);
//                        }
//                        break;
//                      case 'Isha':
//                        currentTime = masjidProvider.masjid.prayerTime.isha;
//                        status = await _showTimeChangeAlert(
//                            context: context,
//                            currentTime: currentTime,
//                            updatedTime: updatedNamazTime,
//                            namazType: namazType);
//                        print('Alert dialog closed with status: $status');
//                        if (status) {
//                          masjidProvider.setIshaTime(updatedNamazTime);
//                          masjidProvider.updateNamazTime(
//                              Provider.of<AuthProvider>(context, listen: false)
//                                  .user
//                                  .uid);
//                        }
//                        break;
//                      case 'Jummah':
//                        currentTime = masjidProvider.masjid.prayerTime.jummah;
//                        status = await _showTimeChangeAlert(
//                            context: context,
//                            currentTime: currentTime,
//                            updatedTime: updatedNamazTime,
//                            namazType: namazType);
//                        print('Alert dialog closed with status: $status');
//                        if (status) {
//                          masjidProvider.setJummahTime(updatedNamazTime);
//                          masjidProvider.updateNamazTime(
//                              Provider.of<AuthProvider>(context, listen: false)
//                                  .user
//                                  .uid);
//                        }
//                        break;
//                    }
//                  }
//                },
//              ),
//            ),
            SizedBox(width: 4),
            Text(
              time,
              style: namazTimeTS,
            )
          ]),
        ],
      ),
    );
  }

  Future<bool> _showTimeChangeAlert(
      {context, currentTime, updatedTime, String namazType}) async {
    final status = await showDialog<bool>(
      context: context,
      child: CustomAlertDialog(
        iconUrl: 'assets/static_assets/masjid-icon.png',
        content: RichText(
          text: TextSpan(
            style: alertDialogTS,
            text: 'Do you want to update',
            children: [
              TextSpan(text: ' $namazType ', style: alertDialogTSBold),
              TextSpan(text: 'namaz time from'),
              TextSpan(text: ' $currentTime ', style: alertDialogTSBold),
              TextSpan(text: 'to'),
              TextSpan(text: ' $updatedTime.', style: alertDialogTSBold),
              TextSpan(
                  text: 'All your subscribers will be notified for this change')
            ],
          ),
        ),
        actions: [
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: mainThemeColor,
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: mainThemeColor,
            child: Text(
              'Not Now',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          )
        ],
      ),
    );

    return status;
  }

  _showSnackBar(content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  _getCurrentLocation() async {
    currentLocation = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        locationPermissionLevel: GeolocationPermission.location);

    print('@getNearbyMosquesData Current Location: $currentLocation');

    ///
    /// If unable to get current Location
    ///
    if (currentLocation == null) {
      print('Current Location is null');
      final status = await GeoLocatorHelper().isGpsEnabled();
      if (status) {
        _showPermissionsAlert();
      } else
        await GeoLocatorHelper().enableGps();
      currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          locationPermissionLevel: GeolocationPermission.location);
      return;
    }
  }

  _showPermissionsAlert() {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Permissions disabled'),
            content: Text(
                'Please turn on Location Permissions in settings>Apps>MasjidFinder>Permissions to access nearby Locations'),
          );
        });
  }
}

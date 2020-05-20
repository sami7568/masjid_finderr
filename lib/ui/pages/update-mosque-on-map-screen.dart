import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/geolocator-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-bottom-sheet.dart';
import 'package:masjid_finder/ui/custom_widgets/logo.dart';
import 'package:masjid_finder/ui/pages/mosque-dashboard-screen.dart';
import 'package:provider/provider.dart';

class UpdateMosqueOnMapScreen extends StatefulWidget {
  @override
  _UpdateMosqueOnMapScreenState createState() =>
      _UpdateMosqueOnMapScreenState();
}

class _UpdateMosqueOnMapScreenState extends State<UpdateMosqueOnMapScreen> {
  bool gotCurrentLocation = false;
  final geoLocationHelper = GeoLocatorHelper();
  final baseLocation = LatLng(34.005679, 71.568206);
  final geoLocator = Geolocator();
  LatLng masjidPinLocation;

  GoogleMapController _controller;
  Position currentLocation;
  var initialCameraPosition;
  var mosqueLocationMarker;
  var markers = Set<Marker>();
  var masjidPinIcon;
  var dummyMasjid = Masjid(name: 'Spin Jumat', address: 'University Road');
  bool mosquePinAdded = false;

  @override
  void initState() {
    print('@pinMosqueOnMap');
    _doInitialSetup();
    super.initState();
  }

  _doInitialSetup() async {
    _animateToMosqueLocation();
//    _animateToCurrentLocation();
    initialCameraPosition = CameraPosition(target: baseLocation, zoom: 15);
    await _setCustomMapPins();
    final lat = Provider.of<MasjidProvider>(context, listen: false)
        .masjid
        .geoLocation
        .geoPoint
        .latitude;
    final long = Provider.of<MasjidProvider>(context, listen: false)
        .masjid
        .geoLocation
        .geoPoint
        .longitude;
    print('Lat:$lat, long: $long');
    mosqueLocationMarker = Marker(
      icon: masjidPinIcon,
      position: LatLng(lat, long),
      markerId: MarkerId('majidLocationPin'),
      infoWindow: InfoWindow(title: 'Masjid Location'),
    );
    setState(() {
      markers.add(mosqueLocationMarker);
    });
  }

  _animateToCurrentLocation() async {
    final status = await geoLocationHelper.isGpsEnabled();
    if (!status) await _showTurnOnGpsAlert();
    currentLocation = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print(currentLocation);
    if (currentLocation != null) {
      setState(() {
        gotCurrentLocation = true;
        print('Current Location status: $gotCurrentLocation');
      });
      if (_controller != null) {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target:
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 17),
          ),
        );
      }
    }
  }

  _animateToMosqueLocation() async {
    final status = await geoLocationHelper.isGpsEnabled();
    if (!status) await _showTurnOnGpsAlert();
    currentLocation = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    final lat = Provider.of<MasjidProvider>(context, listen: false)
        .masjid
        .geoLocation
        .geoPoint
        .latitude;
    final long = Provider.of<MasjidProvider>(context, listen: false)
        .masjid
        .geoLocation
        .geoPoint
        .longitude;
    print(currentLocation);
    if (currentLocation != null) {
      setState(() {
        gotCurrentLocation = true;
        print('Current Location status: $gotCurrentLocation');
      });
      if (_controller != null) {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, long), zoom: 17),
          ),
        );
      }
    }
  }

  Future<void> _showTurnOnGpsAlert() async {
    await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Enable GPS'),
        content: Text(
            'Your GPS is disabled. Please enable your gps to get your current location'),
        actions: <Widget>[
          CustomBlackButton(
            child: Text('Enable GPS'),
            onPressed: () {
              geoLocationHelper.enableGps();
            },
          )
        ],
      ),
    );
  }

  Future<void> _setCustomMapPins() async {
    masjidPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/static_assets/masjid-pin.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  _body() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: _maps(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _header(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _addLocationBtn(),
        ),
        Positioned(
          bottom: 115,
          right: 10,
          child: FloatingActionButton(
            child: Icon(
              Icons.my_location,
              color: mainThemeColor,
            ),
            backgroundColor: Colors.white,
            onPressed: _animateToCurrentLocation,
          ),
        ),
        Positioned(
          bottom: 185,
          right: 10,
          child: FloatingActionButton(
            child: Image.asset('assets/static_assets/masjid-pin.png',
                width: 30, height: 30, fit: BoxFit.contain),
            backgroundColor: Colors.white,
            onPressed: _animateToMosqueLocation,
          ),
        ),
      ],
    );
  }

  _maps() {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: (LatLng tapLocation) {
          masjidPinLocation = tapLocation;
          masjidProvider.setLocationAddedFlat();
          setState(
            () {
              markers.add(
                Marker(
                  markerId: MarkerId('majidLocationPin'),
                  position: tapLocation,
                  infoWindow: InfoWindow(title: 'Masjid Location'),
                  icon: masjidPinIcon,
                  draggable: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.subject, color: Colors.black),
          Logo(color: Colors.black),
          Container(),
        ],
      ),
    );
  }

  _addLocationBtn() {
    return Consumer<MasjidProvider>(builder: (context, masjidProvider, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: RaisedButton(
          color: masjidProvider.locationAdded ? mainThemeColor : Colors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12),
            child: Text(
              'Add Location',
              style: blackBtnTS.copyWith(fontSize: 15),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            if (masjidProvider.locationAdded) {
              masjidProvider.masjid.geoLocation = GeoFirePoint(
                  masjidPinLocation.latitude, masjidPinLocation.longitude);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MosqueDashboardScreen()),
                  (r) => false);
            }
          },
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/majid-provider.dart';
import 'package:masjid_finder/services/geolocator-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-bottom-sheet.dart';
import 'package:masjid_finder/ui/custom_widgets/logo.dart';
import 'package:provider/provider.dart';

class PinMosqueOnMapScreen extends StatefulWidget {
  @override
  _PinMosqueOnMapScreenState createState() => _PinMosqueOnMapScreenState();
}

class _PinMosqueOnMapScreenState extends State<PinMosqueOnMapScreen> {
  bool gotCurrentLocation = false;
  final geoLocationHelper = GeoLocatorHelper();
  final baseLocation = LatLng(34.005679, 71.568206);
  final geoLocator = Geolocator();
  LatLng masjidPinLocation;

  GoogleMapController _controller;
  Position currentLocation;
  var initialCameraPosition;
  var dummyMarker;
  var markers = Set<Marker>();
  var masjidPinIcon;
  var dummyMasjid = Masjid(name: 'Spin Jumat', address: 'University Road');
  bool mosquePinAdded = false;

  @override
  void initState() {
    print('@pinMosqueOnMap');
    _animateToCurrentLocation();
    _setCustomMapPins();
    initialCameraPosition = CameraPosition(target: baseLocation, zoom: 15);
    dummyMarker = Marker(
      icon: masjidPinIcon,
      position: baseLocation,
      markerId: MarkerId(baseLocation.toString()),
//      onTap: _showBottomSheet,
    );
//    markers.add(dummyMarker);
    super.initState();
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

  _setCustomMapPins() async {
    masjidPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/static_assets/masjid-pin.png');
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
        )
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
              masjidProvider.masjid.position = GeoFirePoint(
                  masjidPinLocation.latitude, masjidPinLocation.longitude);
              Navigator.pop(context);
            }
          },
        ),
      );
    });
  }
}

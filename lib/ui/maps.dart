import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {

  Position currentPosition;
  LatLng centerPoint = new LatLng(30.3, 30.3);
  static String kGoogleApiKey = 'AIzaSyD-WTAV7cHb6FBO4z0AAGUV-hlgudQXMQs';

  LatLngBounds latLngBounds = new LatLngBounds(southwest: LatLng(28.8060003, 30.273187), northeast: LatLng(30.4309242, 33.2769427));

  var currentAddress;
  bool searching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("اختر مكانك"),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: centerPoint == null ? const LatLng(0, 0) : LatLng(centerPoint.latitude, centerPoint.longitude),
                zoom: 6,
              ),
              markers: _markers.values.toSet(),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onCameraMove: _onCameraMove,
              cameraTargetBounds: CameraTargetBounds(latLngBounds),
            ),
            Container(
              alignment: Alignment.center,
              child: Icon(Icons.place, color: Colors.blue,),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: FlatButton.icon(
                  onPressed: (){
                    saveLocationData();
                  },
                  icon: Icon(Icons.pin_drop, color: Colors.white,),
                  label: Text("اختر المنطقه", style: TextStyle(color: Colors.white),),
                color: Colors.blue,
              ),

            )
          ],
        )
      ),
    );
  }

  Future<void> _onCameraMove(CameraPosition position) async {
    centerPoint = position.target;
    // From coordinates
    if(searching == true){
      return;
    }else{
      searching = true;
      var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(centerPoint.latitude, centerPoint.longitude)).whenComplete(() => {
        searching = false
      });
      currentAddress = addresses.first;
      print("${currentAddress.featureName} : ${currentAddress.coordinates}");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {

    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Navigator.pop(context);
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied');
      }
    }

    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {

    });
    return currentPosition;
  }

  Future<void> saveLocationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lat = await prefs.setDouble('lat', currentAddress.coordinates.latitude);
    var lng = await prefs.setDouble('lng', currentAddress.coordinates.longitude);

    Navigator.pop(context);
  }


}

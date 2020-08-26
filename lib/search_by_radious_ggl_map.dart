import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Geolocator _geolocator = Geolocator();

// For storing the current position
  Position _currentPosition;
  LatLng _createCenter = LatLng(37.43296265331129, -122.08832357078792);
  double _circleRadius = 2000;
  Set<Circle> circles;

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      final GoogleMapController controller = await _controller.future;
      _createCenter = LatLng(position.latitude, position.longitude);
      _currentPosition = position;

      circles = Set.from([
        Circle(
            circleId: CircleId("myCircle1"),
            radius: 40,
            center: LatLng(_createCenter.latitude, _createCenter.longitude),
            fillColor: Color.fromRGBO(171, 39, 133, 0.1),
            strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
            onTap: () {
              print('circle pressed');
            }),
        Circle(
            circleId: CircleId("myCircle2"),
            radius: 100,
            center: LatLng(_createCenter.latitude, _createCenter.longitude),
            fillColor: Color.fromRGBO(171, 39, 133, 0.1),
            strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
            onTap: () {
              print('circle pressed');
            })
      ]);

      circles.clear();

      circles.add(
        Circle(
            circleId: CircleId("myCircle1"),
            radius: 40,
            center: LatLng(_createCenter.latitude, _createCenter.longitude),
            fillColor: Color.fromRGBO(171, 39, 133, 0.1),
            strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
            onTap: () {
              print('circle pressed');
            }),
      );

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );

      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        circles: circles,
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

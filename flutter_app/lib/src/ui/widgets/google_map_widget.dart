import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => MapState();
}

class MapState extends State<GoogleMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _centerToCurrentLocation, // Updated onPressed function
        label: const Text('Center to Current Location'), // Updated button label
        icon: const Icon(Icons.my_location), // Updated button icon
      ),
    );
  }

  Future<void> _centerToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    final Location location = Location();
    try {
      final LocationData currentLocation = await location.getLocation();
      final LatLng currentLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      // Center the map to the current location
      await controller.animateCamera(CameraUpdate.newLatLng(currentLatLng));
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}

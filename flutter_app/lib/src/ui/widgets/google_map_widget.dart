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
  final Location location = Location();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(
        1.380000, 103.800000), // Singapore TODO: Change to current location
    zoom: 11,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false, // TODO: Replace with custom bubble
      ),
      // Center map button on the btm right
      floatingActionButton: FloatingActionButton(
        onPressed: _centerToCurrentLocation,
        backgroundColor: Colors.green,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  // Center the map to the current location when the button is pressed
  Future<void> _centerToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    try {
      final LocationData currentLocation = await location.getLocation();
      final LatLng currentLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      // Adjust the zoom level as per your preference (e.g., 15.0 for a little zoom)
      const double zoomLevel = 14;

      // Center the map to the current location with zoom
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, zoomLevel),
      );
    } catch (e) {
      print("Error getting location: $e"); //TODO: Error popup instead
    }
  }
}
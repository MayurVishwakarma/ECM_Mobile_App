// ignore_for_file: non_constant_identifier_names, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserDetailPopup extends StatefulWidget {
  String? Coordinate;
  UserDetailPopup(String coordinate) {
    Coordinate = coordinate;
  }
  @override
  _UserDetailPopupState createState() => _UserDetailPopupState();
}

class _UserDetailPopupState extends State<UserDetailPopup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userDetails = "";
  double? latitude;
  double? longitude;
  var distance;

  final TextEditingController _lat = TextEditingController();
  final TextEditingController _lon = TextEditingController();
  final TextEditingController _distance = TextEditingController();
  final TextEditingController _rssi = TextEditingController();
  final TextEditingController _snr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    var currentCoordinate = widget.Coordinate!.split(',');

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      // Request location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle denied forever case here
        return;
      }

      if (permission == LocationPermission.denied) {
        // Location permissions are denied, request permission
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          // Handle denied case here
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            double.tryParse(currentCoordinate[0]) ?? 0,
            double.tryParse(currentCoordinate[1]) ?? 0,
          ) /
          1000;
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        _lat.text = position.latitude.toString();
        _lon.text = position.longitude.toString();
        _distance.text = distance.toStringAsFixed(2);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("LORA Signal Details"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(labelText: "Latitude"),
                  controller: _lat,
                  // initialValue: latitude?.toString() ?? "",
                ),
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(labelText: "Longitude"),
                  // initialValue: longitude?.toString() ?? "",
                  controller: _lon,
                ),
                TextFormField(
                  enabled: false,
                  controller: _distance,
                  decoration: const InputDecoration(
                      labelText: "Distance", suffixText: 'KM'),
                ),
                TextFormField(
                  controller: _rssi,
                  decoration: const InputDecoration(
                      labelText: "RSSI", suffixText: 'dB'),
                ),
                TextFormField(
                  controller: _snr,
                  decoration:
                      const InputDecoration(labelText: "SNR", suffixText: 'dB'),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final userDetailString =
                  "${_lat.text} ${_lon.text} ${_distance.text} ${_rssi.text} ${_snr.text}";
              setState(() {
                userDetails = userDetailString;
              });
              Navigator.of(context).pop(userDetails);
            }
          },
          child: const Text("Save"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

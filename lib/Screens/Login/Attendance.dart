// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserAttendance extends StatefulWidget {
  @override
  _UserAttendanceState createState() => _UserAttendanceState();
}

class _UserAttendanceState extends State<UserAttendance> {
  UserAttendanceViewModel? uaVM;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  Future<bool> getLocationPermission() async {
    bool flag = false;
    // int deniedCount = 0;
    try {
      var status = await Permission.locationWhenInUse.status;

      if (status == PermissionStatus.granted) return true;

      if (status == PermissionStatus.denied) {
        // Prompt the user to turn on in settings
        // On iOS once a permission has been denied it may not be requested again from the application
        return false;
      }

      // if (await Permission!.locationWhenInUse.shouldShowRequestRationale()) {
      //   // Prompt the user with additional information as to why the permission is needed
      // }

      var result = await Permission.locationWhenInUse.request();
      if (result == PermissionStatus.granted) return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return flag;
  }

  void onLoad() async {
    try {
      uaVM = UserAttendanceViewModel();
      await uaVM!.downloadData();
      setState(() {});
    } catch (e) {}
  }

  Future<void> btnActionClicked(String buttonText) async {
    bool flag = await getLocationPermission();
    if (flag) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Fetching Location'),
            content: CircularProgressIndicator(),
          );
        },
      );

      Position? position;
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (e) {
        print(e.toString());
      }

      Navigator.of(context).pop(); // Dismiss the location fetching dialog

      if (position != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Retrieved'),
              content: Text(
                  'Latitude: ${position!.latitude}\nLongitude: ${position.longitude}'),
            );
          },
        );

        await uaVM!.insertData(position, buttonText);
        await uaVM!.downloadData();
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Unable to fetch your current location'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Denied to Permission'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Attendance'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(
            uaVM?.userName ?? '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            uaVM?.attendanceStartTime ?? '',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            uaVM?.attendanceDate ?? '',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            uaVM?.attendanceEndTime ?? '',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: uaVM?.isButtonAvailable == true
                ? () => btnActionClicked(uaVM!.buttonText!)
                : null,
            child: Text(uaVM?.buttonText ?? ''),
          ),
        ],
      ),
    );
  }
}

class UserAttendanceViewModel {
  AttendanceModel? attendance;
  String? userName;
  String? attendanceStartTime;
  String? attendanceEndTime;
  String? attendanceDate;
  bool? isButtonAvailable;
  String? buttonText;

  Future<void> downloadData() async {
    attendance = AttendanceModel();
    userName = 'John Doe'; // Fetch the user name from the data source
    attendanceStartTime = attendance?.attendanceStartTime?.toString() ?? '';
    attendanceEndTime = attendance?.attendanceEndTime?.toString() ?? '';
    attendanceDate = attendance?.attendanceDate?.toString() ?? '';
    isButtonAvailable =
        true; // Set the availability of the button based on the data
    buttonText = 'Start Session'; // Set the button text based on the data
  }

  Future<void> insertData(Position location, String buttonText) async {
    if (buttonText == 'Start Session') {
      attendance?.startLocationCoordinate =
          '${location.latitude},${location.longitude}';
    } else if (buttonText == 'End Session') {
      attendance?.endLocationCoordinate =
          '${location.latitude},${location.longitude}';
    }

    // Insert the data to the data source
  }
}

class AttendanceModel {
  String? startLocationCoordinate;
  String? endLocationCoordinate;
  DateTime? attendanceStartTime;
  DateTime? attendanceEndTime;
  DateTime? attendanceDate;
}

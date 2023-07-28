// ignore_for_file: prefer_const_constructors, file_names, empty_catches, non_constant_identifier_names, unused_catch_stack, unused_local_variable

import 'dart:convert';
// import 'dart:io';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import 'package:ecm_application/Model/Project/Login/UserDetailsMasterModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? username;
  bool isAttendanceAvai = false;
  late String now;

  @override
  void initState() {
    super.initState();
    now = DateFormat('yyyy-MMMM-dd').format(DateTime.now());

    fetchUserDetails().whenComplete(() => getProjectList());
  }

  String? currentLocation;

  List<ProjectModel>? projectList;
  ProjectModel? selectProject;
  Future<List<ProjectModel>>? futureProjectList;
  UserDetailsMasterModel? userDetals;
  String? StartLocationAddress, EndLocationAddress;
  String? startLocation = '';
  String? endLocation = '';

  Future<void> getProjectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = '${prefs.getString('firstname')} ${prefs.getString('lastname')}';
    setState(() {
      projectList = [];
      projectList!.add(ProjectModel(id: 0, projectName: 'SELECT PROJECT'));

      futureProjectList = getStateAuthority();
      futureProjectList!.then((value) {
        projectList!.addAll(value);
      });
      selectProject = projectList!.first;
    });
  }

  Future<void> fetchUserDetails() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final int? userid = preferences.getInt('userid');
      final String attendanceEndpoint =
          'http://wmsservices.seprojects.in/api/login/GetTodaysAttendance?UserId=$userid';

      final response = await http.get(Uri.parse(attendanceEndpoint));

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['Status'] == WebApiStatusOk) {
          setState(() {
            isAttendanceAvai = true;
          });
          userDetals =
              UserDetailsMasterModel.fromJson(json['data']['Response']);

          fetchStartLocationAddress();
          fetchEndLocationAddress();
        } else {
          setState(() {
            isAttendanceAvai = false;
          });
          throw Exception("Login Failed");
        }
      } else {
        setState(() {
          isAttendanceAvai = false;
        });
        throw Exception("Login Failed");
      }
    } on Exception catch (_, ex) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                elevation: 8,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('Date : '),
                              Text(
                                now,
                                style: TextStyle(color: Colors.cyan),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('User name : '),
                              Text(
                                username ?? '',
                                style: TextStyle(color: Colors.cyan),
                              )
                            ],
                          ),
                        ),
                        if ((StartLocationAddress ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Start Time : '),
                                    Text(DateFormat('hh:mm:ss a').format(
                                        DateTime.parse(
                                            userDetals!.attendanceStartTime ??
                                                ''))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Start Location : '),
                                    Expanded(
                                        child:
                                            Text(StartLocationAddress ?? '')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if ((EndLocationAddress ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('End Time : '),
                                    Text(DateFormat('hh:mm:ss a').format(
                                        DateTime.parse(
                                            userDetals!.attendanceEndTime!))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('End Location : '),
                                    Expanded(
                                        child: Text(EndLocationAddress ?? '')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if ((EndLocationAddress ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Total Working Hour : '),
                                Text(userDetals!.workingHours ?? ''),
                              ],
                            ),
                          ),
                        if (!isAttendanceAvai)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Working On Project : ',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: DropdownButton<ProjectModel>(
                                      value: selectProject,
                                      items: projectList!
                                          .map((ProjectModel items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Center(
                                              child: Text(
                                            items.projectName!.toUpperCase(),
                                            style: TextStyle(fontSize: 10),
                                          )),
                                        );
                                      }).toList(),
                                      onChanged: (ProjectModel? newValue) {
                                        setState(() {
                                          selectProject = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if ((StartLocationAddress ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Working On Project : ',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  userDetals!.workingOnProjects ?? '',
                                  style: TextStyle(color: Colors.cyan),
                                )
                              ],
                            ),
                          ),
                        if (!isAttendanceAvai)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              bool serviceEnabled;
                              LocationPermission permission;

                              // Check if location services are enabled
                              serviceEnabled =
                                  await Geolocator.isLocationServiceEnabled();
                              if (!serviceEnabled) {
                                return;
                              }

                              // Request location permission
                              permission = await Geolocator.checkPermission();
                              if (permission ==
                                  LocationPermission.deniedForever) {
                                AlertDialog(
                                  title: Text('Enable Location'),
                                  content: Text(
                                      'Please enable location services to proceed.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('CANCEL'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('ENABLE'),
                                      onPressed: () {
                                        _enableLocationService();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }

                              if (permission == LocationPermission.denied) {
                                // Location permissions are denied, request permission
                                permission =
                                    await Geolocator.requestPermission();
                                if (permission !=
                                        LocationPermission.whileInUse &&
                                    permission != LocationPermission.always) {
                                  // Location permissions are denied (again), handle it accordingly
                                  return;
                                }
                              }

                              // Get the current position
                              Position position =
                                  await Geolocator.getCurrentPosition();

                              // Retrieve the latitude and longitude
                              double latitude = position.latitude;
                              double longitude = position.longitude;
                              startLocation =
                                  ('${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}');

                              await StartAttendance().then((value) {
                                if (value) {
                                  fetchUserDetails();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Something went wrong."),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            },
                            child: const Text('Start Session'),
                          ),
                        if (isAttendanceAvai &&
                            userDetals!.endLocationCoordinate!.isEmpty)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              bool serviceEnabled;
                              LocationPermission permission;
                              // Check if location services are enabled
                              serviceEnabled =
                                  await Geolocator.isLocationServiceEnabled();
                              if (!serviceEnabled) {
                                return;
                              }

                              // Request location permission
                              permission = await Geolocator.checkPermission();
                              if (permission ==
                                  LocationPermission.deniedForever) {
                                AlertDialog(
                                  title: Text('Enable Location'),
                                  content: Text(
                                      'Please enable location services to proceed.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('CANCEL'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('ENABLE'),
                                      onPressed: () {
                                        _enableLocationService();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }

                              if (permission == LocationPermission.denied) {
                                // Location permissions are denied, request permission
                                permission =
                                    await Geolocator.requestPermission();
                                if (permission !=
                                        LocationPermission.whileInUse &&
                                    permission != LocationPermission.always) {
                                  // Location permissions are denied (again), handle it accordingly
                                  return;
                                }
                              }

                              Position position =
                                  await Geolocator.getCurrentPosition();
                              double latitude = position.latitude;
                              double longitude = position.longitude;
                              startLocation =
                                  ('${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}');
                              endLocation =
                                  ('${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}');

                              await EndAttendance().then((value) {
                                if (value) {
                                  fetchUserDetails();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Something went wrong."),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            },
                            child: const Text('End Session'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enableLocationService() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // Handle the scenario when the user has previously denied location permission permanently.
      // You may want to show a message or redirect them to settings.
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the scenario when the user denies location permission.
        // You may want to show a message or perform some other action.
        return;
      }
    }

    // Location permission has been granted, and the user has enabled location services.
    // You can now proceed with the location-based functionality.
    // For example, you can start listening for location updates.
  }

  Future<void> fetchStartLocationAddress() async {
    double lat = double.parse(userDetals!.startLocationCoordinate!
        .substring(0, userDetals!.startLocationCoordinate!.indexOf(',')));
    double lon = double.parse(userDetals!.startLocationCoordinate!
        .substring(userDetals!.startLocationCoordinate!.indexOf(',') + 1));
    try {
      String address = await GetAddressFromLatLong(lat, lon);
      setState(() {
        StartLocationAddress = address;
      });
    } catch (ex) {
      // Handle the exception here, e.g., display an error message or fallback behavior
    }
  }

  Future<void> fetchEndLocationAddress() async {
    double lat = double.parse(userDetals!.endLocationCoordinate!
        .substring(0, userDetals!.endLocationCoordinate!.indexOf(',')));
    double lon = double.parse(userDetals!.endLocationCoordinate!
        .substring(userDetals!.endLocationCoordinate!.indexOf(',') + 1));
    try {
      String address = await GetAddressFromLatLong(lat, lon);
      setState(() {
        EndLocationAddress = address;
      });
    } catch (ex) {
      // Handle the exception here, e.g., display an error message or fallback behavior
    }
  }

  Future<String> GetAddressFromLatLong(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemarks[0];
    String? address =
        ' ${place.subLocality}, ${place.locality},${place.administrativeArea}, ${place.postalCode}';
    return address;
  }

  Future<bool> StartAttendance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      int? userId = preferences.getInt('userid');

      var projectId = selectProject!.id;

      var insertObj = <String, dynamic>{
        'attendenceId': '',
        'attendanceStartTime': '',
        'attendanceEndTime': '',
        'startLocationCoordinate': startLocation,
        'endLocationCoordinate': '',
        'workingHours': '',
        'workingOnProjects': projectId,
        'userId': userId,
        'attendanceDate': now,
      };

      var headers = {'Content-Type': 'application/json'};
      final request = http.Request(
        'POST',
        Uri.parse(
          'http://wmsservices.seprojects.in/api/login/InsertAttendanceDetails',
        ),
      );
      request.headers.addAll(headers);
      request.body = json.encode(insertObj);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic jsonResponse =
            jsonDecode(await response.stream.bytesToString());
        if (jsonResponse['Status'] == 'Ok') {
          return true;
        } else {
          throw Exception();
        }
      } else {
        throw Exception();
      }
    } catch (_, ex) {
      return false;
    }
  }

  Future<bool> EndAttendance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      int? userId = preferences.getInt('userid');

      var projectId = userDetals!.workingOnProjects;

      var insertObj = <String, dynamic>{
        'attendenceId': userDetals!.attendanceId,
        'attendanceStartTime': userDetals!.attendanceStartTime,
        'attendanceEndTime': '',
        'startLocationCoordinate': userDetals!.startLocationCoordinate,
        'endLocationCoordinate': endLocation,
        'workingHours': '',
        'workingOnProjects': projectId,
        'userId': userId,
        'attendanceDate': now,
      };

      var headers = {'Content-Type': 'application/json'};
      final request = http.Request(
        'POST',
        Uri.parse(
          'http://wmsservices.seprojects.in/api/login/InsertAttendanceDetails',
        ),
      );
      request.headers.addAll(headers);
      request.body = json.encode(insertObj);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic jsonResponse =
            jsonDecode(await response.stream.bytesToString());
        if (jsonResponse['Status'] == 'Ok') {
          return true;
        } else {
          throw Exception();
        }
      } else {
        throw Exception();
      }
    } catch (_, ex) {
      return false;
    }
  }
}

/*
 ElevatedButton(
                                      // icon: Icon(
                                      //   Icons.gps_fixed,
                                      //   color: Colors.blue,
                                      // ),
                                      child: Text('Get Location'),
                                      onPressed: isEdit()
                                          ? () async {
                                              bool serviceEnabled;
                                              LocationPermission permission;

                                              // Check if location services are enabled
                                              serviceEnabled = await Geolocator
                                                  .isLocationServiceEnabled();
                                              if (!serviceEnabled) {
                                                return;
                                              }

                                              // Request location permission
                                              permission = await Geolocator
                                                  .checkPermission();
                                              if (permission ==
                                                  LocationPermission
                                                      .deniedForever) {
                                                AlertDialog(
                                                  title:
                                                      Text('Enable Location'),
                                                  content: Text(
                                                      'Please enable location services to proceed.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('CANCEL'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('ENABLE'),
                                                      onPressed: () {
                                                        _enableLocationService();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }

                                              if (permission ==
                                                  LocationPermission.denied) {
                                                // Location permissions are denied, request permission
                                                permission = await Geolocator
                                                    .requestPermission();
                                                if (permission !=
                                                        LocationPermission
                                                            .whileInUse &&
                                                    permission !=
                                                        LocationPermission
                                                            .always) {
                                                  // Location permissions are denied (again), handle it accordingly
                                                  return;
                                                }
                                              }

                                              // Get the current position
                                              Position position =
                                                  await Geolocator
                                                      .getCurrentPosition();

                                              // Retrieve the latitude and longitude
                                              double latitude =
                                                  position.latitude;
                                              double longitude =
                                                  position.longitude;
                                              String location = ('lat: ' +
                                                  latitude.toStringAsFixed(4) +
                                                  ' long: ' +
                                                  longitude.toStringAsFixed(4));

                                              item.value = location;
                                            }
                                          : null,
                                    ),
                                 */
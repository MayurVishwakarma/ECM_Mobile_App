// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, unused_catch_stack

import 'dart:convert';

// import 'package:ecm_application/Model/Project/State_list_Model.dart';
// import 'package:ecm_application/Model/project/Constants.dart';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import 'package:ecm_application/Model/Project/Login/UserDetailsMasterModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceScreen extends StatefulWidget {
  final bool showSessionStartedDialog;

  AttendanceScreen({this.showSessionStartedDialog = false});
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  UserDetailsMasterModel? userData;

  DateTime sessionStartTime = DateTime.now();
  DateTime? sessionEndTime;
  String? sessionEndLocation;
  String? currentLocation;
  String username = '';
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSessionStartTime();

    _loadUsername();
    getProjectList();

    if (widget.showSessionStartedDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSessionStartedDialog();
      });
    }
  }

  void _loadUsername() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUsername = prefs.getString('firstname');
      if (storedUsername != null) {
        // print('Stored Username: $storedUsername');
        setState(() {
          username = storedUsername;
        });
      }
    } catch (e) {
      // print('Failed to load username: $e');
    }
  }

  Set<String>? stateList;
  String? selectState;
  List<ProjectModel>? projectList;
  ProjectModel? selectProject;
  Future<List<ProjectModel>>? futureProjectList;
  getProjectList() {
    setState(() {
      projectList = [];
      projectList!.add(ProjectModel(id: 0, projectName: 'ALL PROJECT'));

      selectProject = projectList!.first;
      futureProjectList = getStateAuthority();
      futureProjectList!.then((value) {
        projectList!.addAll(value);
      });
    });
  }

  void _loadSessionStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('sessionStartTime')) {
      int storedTime = prefs.getInt('sessionStartTime')!;
      setState(() {
        sessionStartTime = DateTime.fromMillisecondsSinceEpoch(storedTime);
      });
    } else {
      setState(() {
        sessionStartTime = DateTime.now();
      });
    }
  }

  void _saveSessionStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('sessionStartTime', sessionStartTime.millisecondsSinceEpoch);
  }

  void _startSession() async {
    setState(() {
      sessionStartTime = DateTime.now();
      sessionEndTime = null;
      sessionEndLocation = null;
    });

    _saveSessionStartTime();

    currentLocation = await _getCurrentLocation();

    try {
      userData = await fetchUserDetailsMasterModel();

      setState(() {
        username = userData?.workingOnProjects ?? '';
      });
    } catch (e) {
      print('Failed to fetch user data: $e');
      // Handle the error accordingly
    }
  }

  Future<void> _showSessionStartedDialog() async {
    final UserDetailsMasterModel = await fetchUserDetailsMasterModel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Session Started'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'User Name: ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Working on Project: ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              /* Text(
                '$selectedProject',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              */
              const SizedBox(height: 16),
              const Text(
                'Start Session Time: ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                DateFormat('hh:mm:ss a').format(sessionStartTime),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Current Location: ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                '$currentLocation',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    sessionEndTime = DateTime.now();
                  });

                  sessionEndLocation = await _getCurrentLocation();

                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Session Ended'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'User Name: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Working on Project: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            /* Text(
                              '$selectedProject',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            */
                            const SizedBox(height: 16),
                            const Text(
                              'Start Session Time: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('hh:mm:ss a').format(sessionStartTime),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'End Session Time: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('hh:mm:ss a').format(sessionEndTime!),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Session Duration: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _formatDuration(
                                  sessionEndTime!.difference(sessionStartTime)),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'End Location: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$sessionEndLocation',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                    context); // Close the current dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttendanceScreen()),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('End Session'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Back'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool sessionStarted = sessionStartTime != null && sessionEndTime == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            const Text(
              'Working on Projects:',
              style: TextStyle(fontSize: 18.0),
            ),
            Container(
              decoration: BoxDecoration(
                  color: ColorConstant.gray400,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: DropdownButton(
                  isExpanded: true,
                  value: selectProject,
                  items: projectList!.map((ProjectModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child:
                          Center(child: Text(items.projectName!.toUpperCase())),
                    );
                  }).toList(),
                  onChanged: (ProjectModel? newValue) {
                    setState(() {
                      selectProject = newValue!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _startSession,
              child: const Text('Start Session'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: null,
              child: Text('Session Already Started'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final Placemark placemark = placemarks.first;
    final String postalCode = placemark.postalCode ?? '';
    final String eastWest = placemark.subLocality ?? '';
    final String area = placemark.administrativeArea ?? '';

    return '$postalCode, $eastWest, $area';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<UserDetailsMasterModel> fetchUserDetailsMasterModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userid = preferences.getInt('userid');
    final String attendanceEndpoint =
        'http://wmsservices.seprojects.in/api/login/GetTodaysAttendance?UserId=$userid';

    final response = await http.get(Uri.parse(attendanceEndpoint));

    if (response.statusCode == 200) {
      return UserDetailsMasterModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load UserDetailsMasterModel');
    }
  }

  Future<bool> InsertAttendence(
    final DateTime startTime,
    final DateTime endTime,
    final String startLocationCoordinate,
    final String endLocationCoordinate,
    final String workingHours,
    final String workingOnProjects,
    final int userId,
    final String attendanceDate,
  ) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');

      var Insertobj = Map<String, dynamic>();

      Insertobj["attendenceId"] = '';
      Insertobj["attendanceStartTime"] = startTime.toString();
      Insertobj["attendanceEndTime"] = endTime.toString();
      Insertobj["startLocationCoordinate"] = startLocationCoordinate;
      Insertobj["endLocationCoordinate"] = endLocationCoordinate;
      Insertobj["workingHours"] = workingHours;
      Insertobj["workingOnProjects"] = workingOnProjects;
      Insertobj["userId"] = 70391;
      Insertobj["attendanceDate"] = attendanceDate;

      var headers = {'Content-Type': 'application/json'};
      final request = http.Request(
          "POST",
          Uri.parse(
              'http://wmsservices.seprojects.in/api/login/InsertAttendanceDetails'));
      request.headers.addAll(headers);
      request.body = json.encode(Insertobj);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(await response.stream.bytesToString());
        if (json["Status"] == "Ok") {
          return true;
        } else
          throw Exception();
      } else
        throw Exception();
    } catch (_, ex) {
      return true;
    }
  }
}

class InsertObjectModel {
  String? attendenceId;
  String? attendanceStartTime;
  String? attendanceEndTime;
  String? startLocationCoordinate;
  String? endLocationCoordinate;
  String? workingHours;
  String? workingOnProjects;
  String? userId;
  String? attendanceDate;
}

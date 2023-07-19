// ignore_for_file: prefer_const_constructors, file_names, empty_catches, non_constant_identifier_names, unused_catch_stack

import 'dart:convert';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import 'package:ecm_application/Model/Project/Login/UserDetailsMasterModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchUserDetails().whenComplete(() => getProjectList());
  }

  String? currentLocation;

  List<ProjectModel>? projectList;
  ProjectModel? selectProject;
  Future<List<ProjectModel>>? futureProjectList;
  UserDetailsMasterModel? userDetals;
  String? StartLocationAddress, EndLocationAddress;

  Future<void> getProjectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = '${prefs.getString('firstname')} ${prefs.getString('lastname')}';
    setState(() {
      projectList = [];
      projectList!.add(ProjectModel(id: 0, projectName: 'ALL PROJECTS'));
      selectProject = projectList!.first;
      futureProjectList = getStateAuthority();
      futureProjectList!.then((value) {
        projectList!.addAll(value);
      });
    });
  }

  String? startTime = DateFormat('HH:MM:SS').format(DateTime.now());
  String? endTime = DateFormat('HH:MM:SS').format(DateTime.now());

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
                        if (isAttendanceAvai)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Start Time : '),
                                Text(DateFormat('hh:mm:ss a').format(
                                    DateTime.parse(
                                        userDetals!.attendanceStartTime ??
                                            ''))),
                              ],
                            ),
                          ),
                        if (isAttendanceAvai)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Start Location : '),
                                Expanded(child: Text(StartLocationAddress!)),
                              ],
                            ),
                          ),
                        if (isAttendanceAvai)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('End Time : '),
                                Text(DateFormat('hh:mm:ss a').format(
                                    DateTime.parse(
                                        userDetals!.attendanceEndTime!))),
                              ],
                            ),
                          ),
                        if (isAttendanceAvai)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('End Location : '),
                                Expanded(child: Text(EndLocationAddress!)),
                              ],
                            ),
                          ),
                        if (isAttendanceAvai)
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
                                              child: Text(items.projectName!
                                                  .toUpperCase())),
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
                        if (!isAttendanceAvai)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              InsertAttendance().then((value) {
                                if (value) {
                                  print('Inserted');
                                  fetchUserDetails();
                                } else {
                                  print('Error');
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
                            onPressed: () {
                              InsertAttendance().then((value) {
                                if (value) {
                                  print('Inserted');
                                  fetchUserDetails();
                                } else {
                                  print('Error');
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

  Future<bool> InsertAttendance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      int? userId = preferences.getInt('userid');

      var insertObj = <String, dynamic>{
        'attendenceId': '',
        'attendanceStartTime': '',
        'attendanceEndTime': now,
        'startLocationCoordinate': '',
        'endLocationCoordinate': '',
        'workingHours': '',
        'workingOnProjects': selectProject!.id,
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

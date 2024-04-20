// ignore_for_file: unused_element, avoid_unnecessary_containers, unused_field, prefer_const_constructors, unused_import, non_constant_identifier_names, prefer_final_fields, unused_catch_stack, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, unused_local_variable, prefer_collection_literals, unused_label, empty_statements, curly_braces_in_flow_control_structures, unnecessary_new, empty_catches, prefer_is_empty, sort_child_properties_last, file_names, avoid_print, must_be_immutable, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:ecm_application/Model/Project/RoutineCheck/RoutineCheckModel.dart';
import 'package:ecm_application/Model/Project/RoutineCheck/RoutineScountModel.dart';
import 'package:ecm_application/Model/Project/RoutineCheck/RoutineTimeModel.dart';
import 'package:ecm_application/Screens/Home/RoutineCheck/ManualCheck.dart';
import 'package:flutter/material.dart';
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/math_utils.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RoutineCheckList_Lora extends StatefulWidget {
  String? ProjectName;
  RoutineCheckList_Lora(String project) {
    ProjectName = project;
  }

  @override
  State<RoutineCheckList_Lora> createState() => _RoutineCheckList_LoraState();
}

class _RoutineCheckList_LoraState extends State<RoutineCheckList_Lora> {
  List<RoutineCheckMasterModel> _DisplayList = <RoutineCheckMasterModel>[];
  List<RoutineStatusList> processList = [];
  List<RoutineStatusList> nextScheduleList = [];
  RoutineScountModel? scountList;

  @override
  void initState() {
    super.initState();
    setState(() {
      _DisplayList = [];
    });
    _firstLoad();
    _controller = new ScrollController()..addListener(_loadMore);
    getDropDownAsync();
    getUserType();
    addProcessList();
    addNextScheduleList();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  var area = 'All';
  var distibutory = 'All';
  var process = '3';
  var nextschedule = 0;
  var isDateSort = 0;

  String? _search = '';
  bool? isSubmited;

  AreaModel? selectedArea;
  DistibutroryModel? selectedDistributory;
  RoutineStatusList? selectStatus;
  RoutineStatusList? selectSchedule;

  Future<List<DistibutroryModel>>? futureDistributory;
  Future<List<AreaModel>>? futureArea;
  List<RoutineStatusList>? futureprocess;
  List<RoutineStatusList>? futureschedule;

  TextEditingController _routineTime = TextEditingController();

  String? dateSortImage = 'assets/images/unsort.png';

  List<DistibutroryModel>? DistriList;
  List<RoutineCheckMasterModel>? RoutineList;

  getDropDownAsync() async {
    setState(() {
      futureArea = getAreaid();
      futureDistributory = getDistibutoryid();
    });
  }

  getDist(BuildContext context, List<DistibutroryModel> values) {
    try {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 168, 211, 237),
            borderRadius: BorderRadius.circular(5)),
        child: DropdownButton(
          value: selectedDistributory == null ||
                  (values
                      .where((e) => e.id == selectedDistributory!.id)
                      .isEmpty)
              ? values.first
              : selectedDistributory,
          underline: Container(color: Colors.transparent),
          isExpanded: true,
          items: values.map((DistibutroryModel distibutroryModel) {
            return DropdownMenuItem<DistibutroryModel>(
              value: distibutroryModel,
              child: Center(
                child: Text(
                  distibutroryModel.description!,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
          onChanged: (textvalue) async {
            setState(() {
              // _page = 0;
              // _hasNextPage = true;
              // _isFirstLoadRunning = false;
              // _isLoadMoreRunning = false;
              // _DisplayList = <PMSListViewModel>[];

              selectedDistributory = textvalue as DistibutroryModel;
              distibutory = selectedDistributory!.id == 0
                  ? "All"
                  : selectedDistributory!.id.toString();
            });
            _firstLoad();
            // await GetOmsOverviewModel();
          },
        ),
      );
    } catch (_, ex) {
      return Container();
    }
  }

  getArea(BuildContext context, List<AreaModel> values) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 168, 211, 237),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButton(
        underline: Container(color: Colors.transparent),
        value: selectedArea == null ||
                (values.where((element) => element == selectedArea)) == 0
            ? values.first
            : selectedArea,
        isExpanded: true,
        items: values.map((AreaModel areaModel) {
          return DropdownMenuItem<AreaModel>(
            value: areaModel,
            child: Center(
              child: Text(
                areaModel.areaName!,
                textScaleFactor: 1,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList(),
        onChanged: (textvalue) async {
          var data = textvalue as AreaModel;
          var distriFuture = getDistibutoryid(
              areaId: data.areaid == 0 ? 'All' : data.areaid.toString());
          await distriFuture.then((value) => setState(() {
                selectedDistributory = value.first;
                distibutory = "All";
              }));
          setState(() {
            // _page = 0;
            // _hasNextPage = true;
            // _isFirstLoadRunning = false;
            // _isLoadMoreRunning = false;
            // _DisplayList = <PMSListViewModel>[];

            selectedArea = data;
            futureDistributory = distriFuture;

            area = selectedArea!.areaid == 0
                ? "All"
                : selectedArea!.areaid.toString();
          });
          _firstLoad();

          // await GetOmsOverviewModel();
          // setState(() {
          //   try {
          //     selectedState = textvalue as AreaModel;
          //   } catch (_, ex) {
          //     print(ex);
          //   }
          // });
        },
      ),
    );
  }

  getProcessList(BuildContext context, List<RoutineStatusList> values) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 168, 211, 237),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButton(
        underline: Container(color: Colors.transparent),
        value: selectStatus == null ||
                (values.where((element) => element == selectStatus)) == 0
            ? values.first
            : selectStatus,
        isExpanded: true,
        items: values.map((RoutineStatusList areaModel) {
          return DropdownMenuItem<RoutineStatusList>(
            value: areaModel,
            child: Center(
              child: Text(
                areaModel.name,
                textScaleFactor: 1,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList(),
        onChanged: (textvalue) async {
          //onAreaChange(textvalue);
          var data = textvalue as RoutineStatusList;

          setState(() {
            selectStatus = data;

            process =
                selectStatus!.id == 0 ? "All" : selectStatus!.id.toString();
          });
          _firstLoad();
        },
      ),
    );
  }

  getSchedulelist(BuildContext context, List<RoutineStatusList> values) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 168, 211, 237),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButton(
        underline: Container(color: Colors.transparent),
        value: selectSchedule == null ||
                (values.where((element) => element == selectSchedule)) == 0
            ? values.first
            : selectSchedule,
        isExpanded: true,
        items: values.map((RoutineStatusList areaModel) {
          return DropdownMenuItem<RoutineStatusList>(
            value: areaModel,
            child: Center(
              child: Text(
                areaModel.name.toString(),
                textScaleFactor: 1,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList(),
        onChanged: (textvalue) async {
          //onAreaChange(textvalue);
          var data = textvalue as RoutineStatusList;

          setState(() {
            selectSchedule = data;

            nextschedule = selectSchedule!.id == 0 ? 0 : selectSchedule!.id;
          });
          _firstLoad();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Lora List'), actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () async {
                await fetchRoutineTime();
                await getECMReportStatusCoun()
                    .onError((error, stackTrace) => getErrorPopUp());
                getCountPopup();
              },
              icon: Icon(Icons.info)),
        )
      ]),
      body: RefreshIndicator(
        onRefresh: () async {
          _firstLoad();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Search Bar
                  Stack(
                    children: [
                      Positioned(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                onChanged: (value) async {
                                  setState(() {
                                    _search = value;
                                  });
                                },
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.go,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    hintText: "Search"),
                              )),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  getpop(context);
                                  _firstLoad();
                                  new Future.delayed(new Duration(seconds: 1),
                                      () {
                                    Navigator.pop(context); //pop dialog
                                  });
                                  //_createRow();
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                  //Area Distibutory DropDown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                          future: futureArea,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Expanded(
                                  child: getArea(context, snapshot.data!));
                            } else if (snapshot.hasError) {
                              return Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Something Went Wrong: " +
                                    snapshot.error.toString(),
                                textScaleFactor: 1,
                              );
                            } else {
                              return Center(child: Container());
                            }
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FutureBuilder(
                          future: futureDistributory,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Expanded(
                                  child: getDist(context, snapshot.data!));
                            } else if (snapshot.hasError) {
                              return Container();
                            } else {
                              return Center(
                                child: Container(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  //Sataus and Schedule DropDown
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: getProcessList(context, processList)),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: getSchedulelist(context, nextScheduleList))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Heading Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 80,
                            child: Text(
                              'Gateway Name.\n(DIST-AREA)',
                              textScaleFactor: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 55,
                            child: FittedBox(
                              child: Text(
                                'Rountin Check \nDone',
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 55,
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                'Last Rountin \nDone',
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => dateSortTapped(),
                            child: SizedBox(
                              width: 60,
                              height: 25,
                              child: Row(
                                children: [
                                  FittedBox(
                                    child: Text(
                                      'Next \nSechdeule',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Expanded(
                                      child: Image(
                                    image: AssetImage(dateSortImage!),
                                    height: 50,
                                    width: 50,
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //NodeList Listview
                  getOmsList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getCountPopup() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              color: Colors.black45,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade200),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.info,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            widget.ProjectName.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: InkWell(
                                              onTap: (() {
                                                Navigator.pop(context);
                                              }),
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.white,
                                              )),
                                        )
                                      ]),
                                ),
                              ),
                              /*                                Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade200),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Distributory: ${selectedArea!.areaName!}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Sub Area: ${selectedDistributory!.description!}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                */
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 20,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade200),
                                          child: Center(
                                            child: Text(
                                              'Information',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Lato',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'TOTAL LORA: ',
                                                          ),
                                                          TextSpan(
                                                            text: scountList!
                                                                .sCount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Lato',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: [
                                                          TextSpan(
                                                            text: 'PENDING : ',
                                                          ),
                                                          TextSpan(
                                                            text: scountList!
                                                                .pending
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Lato',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'COMPLETELY DONE: ',
                                                          ),
                                                          TextSpan(
                                                            text: scountList!
                                                                .fullyDone
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: Row(
                                                children: [
                                                  Text(
                                                      'Routine CheckUp Period:'),
                                                  Expanded(
                                                      child: TextField(
                                                    enabled: isEdit(),
                                                    controller: _routineTime,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 45, 51, 74)),
                                                  )),
                                                  Text(' Days'),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (isEdit())
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        updateRoutineTime(
                                                                int.parse(
                                                                    _routineTime
                                                                        .text))
                                                            .whenComplete(
                                                                () =>
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title: Text(isSubmited!
                                                                              ? 'Success'
                                                                              : 'Error'),
                                                                          content: Text(isSubmited!
                                                                              ? 'Routine CheckUp Period Updarted Successfully'
                                                                              : 'Something Went Wrong !!!'),
                                                                          actions: <Widget>[
                                                                            TextButton(
                                                                              child: Text('OK'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ));
                                                      },
                                                      child: Text('Update'),
                                                    )
                                                ],
                                              )),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          );
        });
  }

  FToast? fToast;

  _showToast(String? msg, {int? MessageType = 0}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: MessageType! == 0
            ? Color.fromARGB(255, 57, 255, 159)
            : Color.fromARGB(255, 243, 72, 72),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            MessageType == 0 ? Icons.check : Icons.close,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            msg!,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  String? userType = '';
  getUserType() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userType = pref.getString('usertype');
    } catch (_, ex) {
      userType = '';
    }
  }

  bool isEdit() {
    var flag = userType!.toLowerCase().contains('manager') ||
        userType!.toLowerCase().contains('admin');
    if (flag) {
      return true;
    } else {
      return false;
    }
  }

  getErrorPopUp() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Title"),
          content: Text("Dialog content"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void dateSortTapped() {
    if (isDateSort == 2) {
      isDateSort = 0;
    } else {
      isDateSort++;
    }

    switch (isDateSort) {
      case 0:
        dateSortImage = 'assets/images/unsort.png';
        break;
      case 1:
        dateSortImage = 'assets/images/ascsort.png';
        break;
      case 2:
        dateSortImage = 'assets/images/dessort.png';
        break;
    }
    getpop(context);
    _firstLoad();
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
    });
  }

  getOmsList(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        controller: _controller,
        interactive: true,
        thickness: 12,
        thumbVisibility: true,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _controller,
          child: Container(
            margin: EdgeInsets.only(left: 8.00, right: 8.00, bottom: (13.00)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: _isFirstLoadRunning
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(children: [
                    getBody(),
                    // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // When nothing else to load
                    if (_hasNextPage == false)
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                      ),
                  ]),
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _DisplayList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => RoutineManual_CheckList(
                      _DisplayList[index].gateWayId!,
                      _DisplayList[index].gateWayName!,
                      _DisplayList[index].areaName ?? '',
                      _DisplayList[index].description ?? '',
                      widget.ProjectName!,
                      true,
                      'lora',
                      _DisplayList[index].amsCoordinate ?? '')),
              (Route<dynamic> route) => true,
            );
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //chak No.
                SizedBox(
                    height: 50,
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(_DisplayList[index].gateWayName ?? "",
                              textScaleFactor: 1,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Text(
                            '( ${_DisplayList[index].description ?? ' '} - ${_DisplayList[index].areaName ?? ' '} )',
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Colors.cyan)),
                      ],
                    )),

                SizedBox(
                    width: 55,
                    height: 25,
                    child: FittedBox(
                        child: Text(
                      getlongDate(_DisplayList[index].workedOn!)!,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ))),

                SizedBox(
                    width: 55,
                    height: 25,
                    child: FittedBox(
                        child: Text(
                            getLastRoutineStatus(
                                _DisplayList[index].routineStatus!,
                                _DisplayList[index].nextScheduleDate!),
                            style: getLastRoutineStatusStyle(
                                _DisplayList[index].routineStatus!,
                                _DisplayList[index].nextScheduleDate!)))),

                SizedBox(
                    width: 60,
                    height: 25,
                    child: FittedBox(
                        child: Text(
                      getNextScheduleDate(
                          _DisplayList[index].nextScheduleDate.toString())!,
                      style: TextStyle(fontSize: 10),
                    )))
              ],
            ),
          ),
        );
      },
    );
  }

  String? getlongDate(String date) {
    try {
      final DateTime now = DateTime.parse(date);
      final DateTime nullDate = DateTime(1, 1, 1);
      if (now == nullDate) {
        return 'Not Available';
      }
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      final String formatted = formatter.format(now);
      return formatted;
    } catch (e) {
      return '';
    }
  }

  String? getNextScheduleDate(String date) {
    try {
      final DateTime now = DateTime.parse(date);
      final DateTime nullDate = DateTime(1, 1, 1);
      if (now == nullDate) {
        return '';
      }
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      final String formatted = formatter.format(now);
      return formatted;
    } catch (e) {
      return '';
    }
  }

  getLastRoutineStatus(int status, String schedule) {
    DateTime dt = DateTime.now();
    DateTime scheduleDateTime = DateTime.parse(schedule);

    var result;
    try {
      if (scheduleDateTime.isBefore(dt) && status == 2)
        return "Already Due";
      else if (scheduleDateTime.isAfter(dt) && status == 2)
        return "Done";
      else if (status == 1)
        return "Partially Done";
      else
        return "Pending";
    } catch (_, ex) {
      result = 'Pending';
    }
    return result;
  }

  getLastRoutineStatusStyle(int status, String schedule) {
    DateTime dt = DateTime.now();
    DateTime scheduleDateTime = DateTime.parse(schedule);

    var result;
    try {
      if (scheduleDateTime.isBefore(dt) && status == 2)
        return TextStyle(
            fontSize: 8, backgroundColor: Colors.red, color: Colors.white);
      else if (scheduleDateTime.isAfter(dt) && status == 2)
        return TextStyle(
            fontSize: 4, backgroundColor: Colors.green, color: Colors.white);
      else if (status == 1)
        return TextStyle(
            fontSize: 8,
            backgroundColor: Colors.orange.shade600,
            color: Colors.white);
      else
        return TextStyle(
          fontSize: 8,
        );
    } catch (_, ex) {
      result = TextStyle(
        fontSize: 8,
      );
    }
    return result;
  }

  int _page = 0;
  int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/Routine/RoutineStatus?Search=$_search&areaId=$area&DistributoryId=$distibutory&RoutineStatus=$process&DateSort=$isDateSort&StartDate=01-01-1900&EndDate=01-01-1900&NextSchedule=$nextschedule&pageIndex=$_page&pageSize=$_limit&source=lora&conString=$conString'));

      print(
          'http://wmsservices.seprojects.in/api/Routine/RoutineStatus?Search=$_search&areaId=$area&DistributoryId=$distibutory&RoutineStatus=$process&DateSort=$isDateSort&StartDate=01-01-1900&EndDate=01-01-1900&NextSchedule=$nextschedule&pageIndex=$_page&pageSize=$_limit&source=lora&conString=$conString');

      var json = jsonDecode(res.body);
      List<RoutineCheckMasterModel> fetchedData = <RoutineCheckMasterModel>[];
      json['data']['Response'].forEach(
          (e) => fetchedData.add(new RoutineCheckMasterModel.fromJson(e)));
      _DisplayList = [];
      if (fetchedData.length > 0) {
        setState(() {
          _DisplayList.addAll(fetchedData);
        });
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();

        String? conString = preferences.getString('ConString');

        final res = await http.get(Uri.parse(
            'http://wmsservices.seprojects.in/api/Routine/RoutineStatus?Search=$_search&areaId=$area&DistributoryId=$distibutory&RoutineStatus=$process&DateSort=0&StartDate=01-01-1900&EndDate=01-01-1900&NextSchedule=$nextschedule&pageIndex=$_page&pageSize=$_limit&conString=$conString'));
        var json = jsonDecode(res.body);
        List<RoutineCheckMasterModel> fetchedData = <RoutineCheckMasterModel>[];
        json['data']['Response'].forEach(
            (e) => fetchedData.add(new RoutineCheckMasterModel.fromJson(e)));
        if (fetchedData.length > 0) {
          setState(() {
            _DisplayList.addAll(fetchedData);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void addProcessList() {
    processList = [
      RoutineStatusList(3, "ALL STATUS"),
      RoutineStatusList(0, "PENDING"),
      RoutineStatusList(2, "COMPLETELY DONE"),
    ];
  }

  void addNextScheduleList() {
    nextScheduleList = [
      RoutineStatusList(0, "ALL SCHEDULE"),
      RoutineStatusList(1, "ALREADY DUE"),
      RoutineStatusList(7, "WITHIN NEXT WEEK"),
      RoutineStatusList(15, "IN NEXT 15 DAYS"),
      RoutineStatusList(25, "IN NEXT 25 DAYS"),
    ];
  }

  Future<RoutineScountModel> getECMReportStatusCoun() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? conString = preferences.getString('ConString');

      final response = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/Routine/RoutineStatusCount?Search=$_search&areaId=$area&DistributoryId=$distibutory&RoutineStatus=$process&StartDate=01-01-1900&EndDate=01-01-1900&NextSchedule=$nextschedule&Source=lora&conString=$conString'));
      print(
          'http://wmsservices.seprojects.in/api/Routine/RoutineStatusCount?Search=$_search&areaId=$area&DistributoryId=$distibutory&RoutineStatus=$process&StartDate=01-01-1900&EndDate=01-01-1900&NextSchedule=$nextschedule&Source=lora&conString=$conString');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        RoutineScountModel result =
            RoutineScountModel.fromJson(json['data']['Response']);

        print(result.sCount);
        setState(() {
          scountList = result;
        });
        return result;
      } else {
        throw Exception('Failed to load API');
      }
    } catch (e) {
      throw Exception('Failed to load API');
    }
  }

  var routineTime;

  var scount;
  Future<void> fetchRoutineTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    final url =
        'http://wmsservices.seprojects.in/api/Routine/RoutineTime?conString=$conString';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final routineTimeModel = RoutineTimeModel.fromJson(jsonResponse);

      if (routineTimeModel.data != null &&
          routineTimeModel.data!.response != null) {
        final days = routineTimeModel.data!.response!.days;
        setState(() {
          _routineTime.text = days.toString();
        });
      }
    }
  }

  Future<String> updateRoutineTime(int days) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    try {
      var actionUrl =
          'http://wmsservices.seprojects.in/api/Routine/UpdateRoutineTime?Days=$days&conString=$conString';
      var response =
          await http.post(Uri.parse(actionUrl), body: jsonEncode({}));

      if (response.statusCode != 200) {
        setState(() {
          isSubmited = false;
        });
        return 'Not Ok';
      } else {
        setState(() {
          isSubmited = true;
        });
        return 'OK';
      }
    } catch (error) {
      return error.toString();
    }
  }

  getpop(context) {
    return showDialog(
      barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (ctx) => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class RoutineStatusList {
  final int id;
  final String name;

  RoutineStatusList(this.id, this.name);
}

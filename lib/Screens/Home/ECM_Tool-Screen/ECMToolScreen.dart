// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, sort_child_properties_last, import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, library_private_types_in_public_api, unused_import, unused_element, prefer_interpolation_to_compose_strings, avoid_print, prefer_is_empty, non_constant_identifier_names, use_build_context_synchronously, unused_local_variable, unused_catch_stack

import 'dart:convert';
import 'package:ecm_application/Model/Project/ECMTool/ECMCountMasterModel.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/ECM-Tool/Ams_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/ECM-Tool/Lora_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/ECM-Tool/Oms_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/ECM-Tool/Rms_Ecm_Page.dart';
import 'package:ecm_application/core/SQLite/Screen/Offline_ListMySql.dart';
import 'package:ecm_application/core/SQLite/Screen/Offline_ListSQL.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class EcmToolScreen extends StatefulWidget {
  @override
  _EcmToolScreenState createState() => _EcmToolScreenState();
}

class _EcmToolScreenState extends State<EcmToolScreen> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    getDataString();
    getDropDownAsync();
    getECMReportStatusCoun();
  }

  ECMStatusCountMasterModel? _DisplayList;
  String? ecString = '1111';
  String? dcString;
  String? projectName;
  String? userType = '';

  var area = 'All';
  var distibutory = 'ALL';

  AreaModel? selectedArea;
  DistibutroryModel? selectedDistributory;

  Future<List<DistibutroryModel>>? futureDistributory;
  Future<List<AreaModel>>? futureArea;

  getDataString() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      ecString = preferences.getString('EcString');
      dcString = preferences.getString('DcString');
      projectName = preferences.getString('ProjectName');
      userType = preferences.getString('usertype');
    });
  }

  getDropDownAsync() async {
    setState(() {
      futureArea = getAreaid();
      futureDistributory = getDistibutoryid();
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? project = preferences.getString('project');
  }

  // bool isSwitched = false;
  var source = 'OMS';
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    final pages = [
      if (ecString![0] == '1')
        OmsPage(ProjectName: projectName, Source: source),
      if (ecString![1] == '1')
        AmsPage(ProjectName: projectName, Source: source),
      if (ecString![2] == '1')
        RmsPage(ProjectName: projectName, Source: source),
      if (ecString![3] == '1')
        LoraPage(ProjectName: projectName, Source: source),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('ECM TOOL'),
          actions: [
            if (isEdit())
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Image(
                      image: AssetImage('assets/images/list-text.png'),
                      color: Colors.white,
                      height: 18,
                      width: 18),
                  onTap: () async {
                    conString!.toString().contains('ID=sa')
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Offline_ListSQL(
                                    ProjectName: projectName, Source: source)),
                            (Route<dynamic> route) => true,
                          )
                        : Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Offline_ListMySql(
                                    ProjectName: projectName, Source: source)),
                            (Route<dynamic> route) => true,
                          );
                    setState(() {
                      isToggled = false;
                    });
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () async {
                    await getECMReportStatusCoun()
                        .onError((error, stackTrace) => getErrorPopUp());
                    getCountPopup();
                  },
                  icon: Icon(Icons.info)),
            )
          ],
        ),
        body: pages[pageIndex],
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              // border: Border.all(color: ColorConstant.black900),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  activeColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.blue[200]!,
                  color: Colors.black,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  tabs: [
                    if (ecString![0] == '1')
                      GButton(
                        textColor: Colors.black,
                        icon: Icons.select_all,
                        iconColor: Colors.transparent,
                        leading: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/oms.png'),
                                fit: BoxFit.fitWidth,
                                height: 15,
                                width: 20,
                              ),
                              Text(
                                'OMS',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (ecString![1] == '1')
                      GButton(
                        textColor: Colors.black,
                        icon: Icons.select_all,
                        iconColor: Colors.transparent,
                        leading: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/ams.png'),
                                fit: BoxFit.fitWidth,
                                height: 15,
                                width: 20,
                              ),
                              Text(
                                'AMS',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (ecString![2] == '1')
                      GButton(
                        textColor: Colors.black,
                        icon: Icons.select_all,
                        iconColor: Colors.transparent,
                        leading: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/rms.png'),
                                fit: BoxFit.fitWidth,
                                height: 15,
                                width: 20,
                              ),
                              Text(
                                'RMS',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (ecString![3] == '1')
                      GButton(
                        textColor: Colors.black,
                        icon: Icons.select_all,
                        iconColor: Colors.transparent,
                        leading: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/lora.png'),
                                fit: BoxFit.fitWidth,
                                height: 15,
                                width: 20,
                              ),
                              Text(
                                'LORA',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                  selectedIndex: pageIndex,
                  onTabChange: (index) {
                    setState(() {
                      pageIndex = index;
                      if (index == 0) {
                        source = 'OMS';
                      } else if (index == 1) {
                        source = 'AMS';
                      } else if (index == 2) {
                        if (ecString![2] == '0') {
                          source = 'LORA';
                        } else {
                          source = 'RMS';
                        }
                      } else if (index == 3) {
                        source = 'LORA';
                      }
                    });
                  },
                ),
              ),
            )));
  }

  getErrorPopUp() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ERROR"),
          content: Text("Something Went Wrong!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  getCountPopup() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
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
                                //Heading Part
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
                                              projectName.toString(),
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

                                //DropDown
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// This Future Builder is Used for Area DropDown list
                                      FutureBuilder(
                                        future: futureArea,
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Expanded(
                                                child: getArea(
                                                    context, snapshot.data!));
                                          } else if (snapshot.hasError) {
                                            return Text(
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
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Expanded(
                                                child: getDist(
                                                    context, snapshot.data!));
                                          } else if (snapshot.hasError) {
                                            return Container();
                                          } else {
                                            return Center(child: Container());
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                //Total Node Count
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade200),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Total Node: " +
                                            _DisplayList!.sCount.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),

                                // Count Container
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          //Mechenical
                                          if (_DisplayList!.pendingMechanical !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Mechanical Installation',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingMechanical
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedMechanical
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyMechanical
                                                                          .toString()),
                                                                  Text('FULLY DONE:' +
                                                                      _DisplayList!
                                                                          .fullyMechanical
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedMechanical
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          //Controll Unit
                                          if (_DisplayList!.pendingErection !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Control Unit Erection',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingErection
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedErection
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyErection
                                                                          .toString()),
                                                                  Text('FULLY DONE: ' +
                                                                      _DisplayList!
                                                                          .fullyErection
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedErection
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          //Wet Comm
                                          if (_DisplayList!.pendingWetComm != 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Dry Commissionning',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingDryComm
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedDryComm
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyDryComm
                                                                          .toString()),
                                                                  Text('FULLY DONE: ' +
                                                                      _DisplayList!
                                                                          .fullyDryComm
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedDryComm
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          //Dry Comm
                                          if (_DisplayList!.pendingDryComm != 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Wet Commissionning',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingWetComm
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedWetComm
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyWetComm
                                                                          .toString()),
                                                                  Text('FULLY DONE: ' +
                                                                      _DisplayList!
                                                                          .fullyWetComm
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedWetComm
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          //Tower Installation
                                          if (_DisplayList!.pendingProcess1 !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Tower Installation',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingProcess1
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedProcess1
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyProcess1
                                                                          .toString()),
                                                                  Text('FULLY DONE:' +
                                                                      _DisplayList!
                                                                          .fullyProcess1
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedProcess1
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (_DisplayList!.pendingProcess2 !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Control Unit Erection',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingProcess2
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedProcess2
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyProcess2
                                                                          .toString()),
                                                                  Text('FULLY DONE:' +
                                                                      _DisplayList!
                                                                          .fullyProcess2
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedProcess2
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (_DisplayList!.pendingProcess3 !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Commissioning',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingProcess3
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedProcess3
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyProcess3
                                                                          .toString()),
                                                                  Text('FULLY DONE:' +
                                                                      _DisplayList!
                                                                          .fullyProcess3
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedProcess3
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (_DisplayList!
                                                  .pendingAutoDryComm !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Auto Dry Commissionning',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingAutoDryComm
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedAutoDryComm
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyAutoDryComm
                                                                          .toString()),
                                                                  Text('FULLY DONE: ' +
                                                                      _DisplayList!
                                                                          .fullyAutoDryComm
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedWetComm
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (_DisplayList!
                                                  .pendingAutoWetComm !=
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200),
                                                        child: Center(
                                                          child: Text(
                                                            'Auto Wet Commissionning',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/notcompletted.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Commented.png'),
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Partially.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/Completed.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        'assets/images/fullydone.png'),
                                                                    height: 15,
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('PENDING: ' +
                                                                      _DisplayList!
                                                                          .pendingAutoWetComm
                                                                          .toString()),
                                                                  Text('COMMENTED: ' +
                                                                      _DisplayList!
                                                                          .rejectedAutoWetComm
                                                                          .toString()),
                                                                  Text('PARTIALLY DONE: ' +
                                                                      _DisplayList!
                                                                          .partiallyAutoWetComm
                                                                          .toString()),
                                                                  Text('FULLY DONE: ' +
                                                                      _DisplayList!
                                                                          .fullyAutoWetComm
                                                                          .toString()),
                                                                  Text('FULLY DONE & APPROVED: ' +
                                                                      _DisplayList!
                                                                          .fullyApprovedWetComm
                                                                          .toString())
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      )),
                                ),
                              ]),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          );
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
                child: FittedBox(
                  child: Text(
                    distibutroryModel.description!,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (textvalue) async {
            setState(() {
              selectedDistributory = textvalue as DistibutroryModel;
              distibutory = selectedDistributory!.id == 0
                  ? "All"
                  : selectedDistributory!.id.toString();
            });
            await getECMReportStatusCoun();
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
              child: FittedBox(
                child: Text(
                  areaModel.areaName ?? '',
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (textvalue) async {
          //onAreaChange(textvalue);
          var data = textvalue as AreaModel;
          var distriFuture = getDistibutoryid(
              areaId: data.areaid == 0 ? 'All' : data.areaid.toString());
          await distriFuture.then((value) => setState(() {
                selectedDistributory = value.first;
                distibutory = "All";
              }));
          setState(() {
            selectedArea = data;
            futureDistributory = distriFuture;

            area = selectedArea!.areaid == 0
                ? "All"
                : selectedArea!.areaid.toString();
          });
          await getECMReportStatusCoun();
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

  bool isEdit() {
    var flag = userType!.toLowerCase().contains('manager') ||
        userType!.toLowerCase().contains('admin');
    if (flag) {
      return false;
    } else {
      return true;
    }
  }

  String? conString;
  Future<ECMStatusCountMasterModel> getECMReportStatusCoun() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      conString = preferences.getString('ConString');

      final response = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/PMS/ECMReportStatusCount?Search=&areaId=$area&DistributoryId=$distibutory&Process=all&ProcessStatus=all&Source=$source&conString=$conString'));
      print(
          'http://wmsservices.seprojects.in/api/PMS/ECMReportStatusCount?Search=&areaId=$area&DistributoryId=$distibutory&Process=all&ProcessStatus=all&Source=$source&conString=$conString');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        ECMStatusCountMasterModel result =
            ECMStatusCountMasterModel.fromJson(json['data']['Response']);

        print(result.sCount);
        setState(() {
          _DisplayList = result;
        });
        return result;
      } else {
        throw Exception('Failed to load API');
      }
    } catch (e) {
      throw Exception('Failed to load API');
    }
  }
}

class ProcessModel {
  int? processId;
  String? processName;
  String? processStatusId;
  String? processStatusName;

  ProcessModel(
      {this.processId,
      this.processName,
      this.processStatusId,
      this.processStatusName});
}

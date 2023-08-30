// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, sort_child_properties_last, import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, library_private_types_in_public_api, unused_import, unused_element, prefer_interpolation_to_compose_strings, avoid_print, prefer_is_empty, non_constant_identifier_names, use_build_context_synchronously, unused_local_variable, unused_catch_stack

import 'dart:convert';
import 'package:ecm_application/Model/Project/ECMTool/ECMCountMasterModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/Ams_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/Lora_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/Oms30Ha_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/Oms_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/Rms_Ecm_Page.dart';
import 'package:ecm_application/Screens/Home/RoutineCheck/Lora_routineCheckList.dart';
import 'package:ecm_application/Screens/Home/RoutineCheck/RoutineCheckScreen.dart';
import 'package:ecm_application/Services/RestPmsService.dart';
import 'package:ecm_application/core/SQLite/Screen/Offline_ListMySql.dart';
import 'package:ecm_application/core/SQLite/Screen/Offline_ListSQL.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';

class RoutineCheckScreenCommon extends StatefulWidget {
  @override
  _RoutineCheckScreenCommonState createState() =>
      _RoutineCheckScreenCommonState();
}

class _RoutineCheckScreenCommonState extends State<RoutineCheckScreenCommon> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    getDataString();
    getDropDownAsync();
  }

  String? rcString = '1000';

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
      rcString = preferences.getString('RcString');

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

  var source = 'OMS';
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    final pages = [
      if (rcString![0] == '1') RoutineCheckScreen(projectName!),
      if (rcString![1] == '1') RoutineCheckScreen(projectName!),
      if (rcString![2] == '1') RoutineCheckScreen(projectName!),
      if (rcString![3] == '1') RoutineCheckList_Lora(projectName!),
    ];
    return Scaffold(
        backgroundColor: ColorConstant.whiteA700,
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
                    if (rcString![0] == '1')
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
                    if (rcString![1] == '1')
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
                    if (rcString![2] == '1')
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
                    if (rcString![3] == '1')
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
                        source = 'RMS';
                      } else if (index == 3) {
                        source = 'LORA';
                      }
                    });
                  },
                ),
              ),
            )));
  }
}

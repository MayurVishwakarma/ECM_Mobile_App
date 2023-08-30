// ignore_for_file: use_key_in_widget_constructors, file_names, library_private_types_in_public_api, non_constant_identifier_names, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_catch_stack, unrelated_type_equality_checks, unused_field, unused_import, camel_case_types

import 'package:ecm_application/Model/Project/ECMTool/ECMCountMasterModel.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageInformation/InformationList/AmsInformation.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageInformation/InformationList/LoraInformation.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageInformation/InformationList/OmsInfromation.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/ListFOrMaterialConsumption/Ams.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/ListFOrMaterialConsumption/Lora.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/ListFOrMaterialConsumption/Oms.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/ListFOrMaterialConsumption/Rms.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/DamageReportList/Oms.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageList/DamageAMSList.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageList/DamageLoraList.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageList/DamageOmsList.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageList/DamageRMSList.dart';
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/DamageReportList/Ams.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/DamageReportList/Lora.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/DamageReportList/Rms.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/SelectDamageListScreen.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DamageInformation_Screen extends StatefulWidget {
  @override
  _DamageInformation_ScreenState createState() =>
      _DamageInformation_ScreenState();
}

class _DamageInformation_ScreenState extends State<DamageInformation_Screen> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    getDataString();
    getDropDownAsync();
  }

  ECMStatusCountMasterModel? _DisplayList;

  String? dcString = '1111';
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

  var source = 'OMS';

  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    final pages = [
      if (dcString![0] == '1')
        Oms_information(ProjectName: projectName, Source: source),
      if (dcString![1] == '1')
        Ams_information(ProjectName: projectName, Source: source),
      if (dcString![2] == '1')
        Rms_MaterialConsumption(ProjectName: projectName, Source: source),
      if (dcString![3] == '1')
        Lora_information(ProjectName: projectName, Source: source),
    ];

    return Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: AppBar(
          title: Text('Damage Information'),
        ),
        body: pages[pageIndex],
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                    if (dcString![0] == '1')
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
                    if (dcString![1] == '1')
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
                    if (dcString![2] == '1')
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
                    if (dcString![3] == '1')
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

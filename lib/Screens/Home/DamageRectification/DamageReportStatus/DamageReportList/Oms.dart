// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, non_constant_identifier_names, prefer_const_constructors, avoid_print, prefer_is_empty, avoid_unnecessary_containers, unused_local_variable, must_be_immutable, camel_case_types, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, unused_import, prefer_final_fields, unused_label, unrelated_type_equality_checks, unused_field, file_names

import 'dart:async';
import 'dart:convert';
import 'package:ecm_application/Model/Project/Damage/DamageReportModel.dart';
import 'package:ecm_application/Model/Project/Damage/OmsDamageModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageForms/DamageInsertForm.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/SelectDamageListScreen.dart';
import 'package:ecm_application/Widget/ExpandableTiles.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Oms_ReportList extends StatefulWidget {
  String? ProjectName;
  String? Source;
  Oms_ReportList({this.ProjectName, this.Source});
  @override
  State<Oms_ReportList> createState() => _Oms_ReportListState();
}

class _Oms_ReportListState extends State<Oms_ReportList> {
  List<DamageReport>? _DisplayList = <DamageReport>[];
  List<DamageReport>? _electricalList = <DamageReport>[];
  List<DamageReport>? _mechanicalList = <DamageReport>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _DisplayList = [];
    });
    _firstLoad();
    getDropDownAsync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _firstLoad();
  }

  var area = 'All';
  var distibutory = 'ALL';
  String? selectedProcess;
  String? _search = '';

  AreaModel? selectedArea;
  DistibutroryModel? selectedDistributory;

  Future<List<DistibutroryModel>>? futureDistributory;
  Future<List<AreaModel>>? futureArea;
  List<PMSChaklistModel>? ProcessList;
  List<DistibutroryModel>? DistriList;

  getDropDownAsync() async {
    setState(() {
      futureArea = getAreaid();
      futureDistributory = getDistibutoryid();
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? project = preferences.getString('project');
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
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (textvalue) async {
            setState(() {
              _DisplayList = <DamageReport>[];

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
    } catch (_) {
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
                  areaModel.areaName ?? "",
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 13),
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
            _DisplayList = <DamageReport>[];

            selectedArea = data;
            futureDistributory = distriFuture;

            area = selectedArea!.areaid == 0
                ? "All"
                : selectedArea!.areaid.toString();
          });
          _firstLoad();
        },
      ),
    );
  }

  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    if (_DisplayList!.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _DisplayList = [];
          _firstLoad();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: _DisplayList != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        //dropdown
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// This Future Builder is Used for Area DropDown list
                              FutureBuilder(
                                future: futureArea,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Expanded(
                                        child:
                                            getArea(context, snapshot.data!));
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

                              ///This Future Builder is Used for Distibutory DropDown List
                              FutureBuilder(
                                future: futureDistributory,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Expanded(
                                        child:
                                            getDist(context, snapshot.data!));
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 110, 189),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "TOTAL OMS : " +
                                    (_DisplayList!.first.totalOMS!).toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///Total
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isClicked = false;
                                    });
                                    selectedDamageType = "Total Damage";
                                    _firstLoad();
                                  },
                                  onDoubleTap: () {
                                    setState(() {
                                      color:
                                      Colors.blue;
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListCommonScreen(
                                                  area_: selectedArea,
                                                  dist_: selectedDistributory,
                                                  ListStatus_: _selectedTotalId
                                                      .join(',')
                                                      .toString(),
                                                  Source_: "OMS",
                                                ))).whenComplete(() {
                                      _firstLoad();
                                    });
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 100,
                                    margin: EdgeInsets.only(
                                      bottom: 
                                        12.58,
                                      
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedDamageType!
                                              .toLowerCase()
                                              .contains('total')
                                          ? Colors.lightBlue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 
                                            2.00,
                                         
                                          blurRadius: 
                                            2.00,
                                         
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "TOTAL DAMAGE",
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 
                                                9,
                                              
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              (_DisplayList!.first.total!)
                                                  .toString(),
                                              textScaleFactor: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: selectedDamageType!
                                                        .toLowerCase()
                                                        .contains('total')
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize:
                                                  14,
                                              
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ///Electrical
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isClicked = false;
                                    });
                                    selectedDamageType = "Electrical Damage";
                                    _firstLoad();
                                  },
                                  onDoubleTap: () {
                                    setState(() {
                                      color:
                                      Colors.blue;
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListCommonScreen(
                                                  area_: selectedArea,
                                                  dist_: selectedDistributory,
                                                  ListStatus_: _selectedTotalId
                                                      .join(',')
                                                      .toString(),
                                                  Source_: "OMS",
                                                ))).whenComplete(() {
                                      _firstLoad();
                                    });
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 100,
                                    margin: EdgeInsets.only(
                                      bottom:
                                        12.58,
                                      
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedDamageType!
                                              .toLowerCase()
                                              .contains('electrical')
                                          ? Colors.lightBlue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 
                                            2.00,
                                          
                                          blurRadius: 
                                            2.00,
                                          
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Electrical Damage".toUpperCase(),
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                9,
                                            
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              (_DisplayList!.first.electrical!)
                                                  .toString(),
                                              textScaleFactor: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: selectedDamageType!
                                                        .toLowerCase()
                                                        .contains('electrical')
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize:
                                                  14,
                                            
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ///Mechanical
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isClicked = false;
                                    });

                                    selectedDamageType = "Mechanical Damage";
                                    _firstLoad();
                                  },
                                  onDoubleTap: () {
                                    setState(() {
                                      color:
                                      Colors.blue;
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListCommonScreen(
                                                  area_: selectedArea,
                                                  dist_: selectedDistributory,
                                                  ListStatus_: _selectedTotalId
                                                      .join(',')
                                                      .toString(),
                                                  Source_: "OMS",
                                                ))).whenComplete(() {
                                      _firstLoad();
                                    });
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 100,
                                    margin: EdgeInsets.only(
                                      bottom: 
                                        12.58,
                                    
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedDamageType!
                                              .toLowerCase()
                                              .contains('mechanical')
                                          ? Colors.lightBlue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius:
                                            2.00,
                                         
                                          blurRadius: 
                                            2.00,
                                         
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Mechanical Damage".toUpperCase(),
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 
                                                9,
                                             
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              (_DisplayList!.first.mechanical!)
                                                  .toString(),
                                              textScaleFactor: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: selectedDamageType!
                                                        .toLowerCase()
                                                        .contains('mechanical')
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 
                                                  14,
                                              
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
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

                        if (selectedDamageType!
                                .toLowerCase()
                                .contains('total') ||
                            selectedDamageType!
                                .toLowerCase()
                                .contains('electrical'))
                          //electrica;
                          ExpansionTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 110, 189),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "electrical Damage".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _electricalList!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // Number of columns
                                    crossAxisSpacing:
                                        1.5, // Spacing between columns
                                    childAspectRatio: 1,
                                    mainAxisSpacing: 1.5,
                                  ),
                                  itemBuilder: (BuildContext context, int i) {
                                    bool isSelected = _selectedTotalId.contains(
                                        _electricalList![i].damageId!);

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedTotalId.remove(
                                                _electricalList![i].damageId!);
                                          } else {
                                            _selectedTotalId.add(
                                                _electricalList![i].damageId!);
                                          }
                                        });
                                      },
                                      child: Card(
                                        elevation: 5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _electricalList![i]
                                                  .damage!
                                                  .toUpperCase(),
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                _electricalList![i]
                                                    .cNT
                                                    .toString(),
                                                textScaleFactor: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Checkbox(
                                              activeColor: Colors.white54,
                                              checkColor: Color.fromARGB(
                                                  255, 251, 3, 3),
                                              value: isSelected,
                                              onChanged: (bool? newValue) {
                                                setState(() {
                                                  if (newValue == true) {
                                                    _selectedTotalId.add(
                                                        _electricalList![i]
                                                            .damageId!);
                                                  } else {
                                                    _selectedTotalId.remove(
                                                        _electricalList![i]
                                                            .damageId!);
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (selectedDamageType!
                                .toLowerCase()
                                .contains('total') ||
                            selectedDamageType!
                                .toLowerCase()
                                .contains('mechanical'))
                          ExpansionTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 110, 189),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Mechanical Damage".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ), // Change the title as per your requirement
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _mechanicalList!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // Number of columns
                                    crossAxisSpacing:
                                        1.5, // Spacing between columns
                                    childAspectRatio: 1,
                                    mainAxisSpacing: 1.5,
                                  ),
                                  itemBuilder: (BuildContext context, int i) {
                                    bool isSelected = _selectedTotalId.contains(
                                        _mechanicalList![i].damageId!);

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedTotalId.remove(
                                                _mechanicalList![i].damageId!);
                                          } else {
                                            _selectedTotalId.add(
                                                _mechanicalList![i].damageId!);
                                          }
                                        });
                                      },
                                      child: Card(
                                        elevation: 5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _mechanicalList![i]
                                                  .damage!
                                                  .toUpperCase(),
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                _mechanicalList![i]
                                                    .cNT
                                                    .toString(),
                                                textScaleFactor: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Checkbox(
                                              activeColor: Colors.white54,
                                              checkColor: Color.fromARGB(
                                                  255, 251, 3, 3),
                                              value: isSelected,
                                              onChanged: (bool? newValue) {
                                                setState(() {
                                                  if (newValue == true) {
                                                    _selectedTotalId.add(
                                                        _mechanicalList![i]
                                                            .damageId!);
                                                  } else {
                                                    _selectedTotalId.remove(
                                                        _mechanicalList![i]
                                                            .damageId!);
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      ])
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/soon.gif',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Page under construction',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      );
    } else {
      return _widget = const Center(child: CircularProgressIndicator());
    }
  }

  String? selectedDamageType = "Total Damage";
  Widget? _widget;
  bool isChecked = false;
  List<int> _selectedTotalId = [];
  List<bool> _selectedElectricalItems = [];
  List<bool> _selectedMechanicalItems = [];
  void _firstLoad() async {
    setState(() {
      _selectedTotalId = [];
      _selectedElectricalItems = List.generate(100, (index) => false);
      _selectedMechanicalItems = List.generate(100, (index) => false);
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/OMS/GetOmsDamageCount?areaId=$area&DistributoryId=$distibutory&conString=$conString'));

      print(
          'http://wmsservices.seprojects.in/api/OMS/GetOmsDamageCount?areaId=$area&DistributoryId=$distibutory&conString=$conString');

      var json = jsonDecode(res.body);
      List<DamageReport> fetchedData = <DamageReport>[];
      json['data']['Response']
          .forEach((e) => fetchedData.add(DamageReport.fromJson(e)));
      _DisplayList = [];
      _electricalList = [];
      _mechanicalList = [];

      if (fetchedData.length > 0) {
        setState(() {
          _DisplayList!.addAll(fetchedData);
        });
        _electricalList!.addAll(
            fetchedData.where((element) => element.type == 'Electrical'));
        _mechanicalList!.addAll(
            fetchedData.where((element) => element.type == 'Mechanical'));
      }
    } catch (err) {
      print('Something went wrong');
    }
  }
}

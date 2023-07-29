// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, camel_case_types, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:ecm_application/Model/Project/Damage/DamageHistory.dart';
import 'package:ecm_application/Model/Project/Damage/DamageReportDetails._Model.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageHistory/Details_CommonScreen.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/Project/Constants.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Model/Project/Damage/LoramasterModel.dart';

LoraMasterModel? modelData;
List<DamageHistory>? _DisplayList = <DamageHistory>[];
// List<DamageInsertModel>? imageList = <DamageInsertModel>[];
// List<DamageInsertModel>? Electrical = <DamageInsertModel>[];
// List<DamageInsertModel>? Mechanical = <DamageInsertModel>[];
List<DamageDetailsCommon>? ChakNo = <DamageDetailsCommon>[];

class History_loraScreen extends StatefulWidget {
  String? ProjectName;
  String? Source;

  History_loraScreen(
      LoraMasterModel? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  @override
  State<History_loraScreen> createState() => _History_loraScreenState();
}

class _History_loraScreenState extends State<History_loraScreen> {
  @override
  void initState() {
    super.initState();
    getECMData();
  }

  var workedondate = '';
  var workdoneby = '';
  var remarkval = '';
  var userName = '';
  var chakNo = '';
  var Zone = '';
  var Area = '';
  @override
  Widget build(BuildContext context) {
    if (_DisplayList!.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(modelData!.gatewayNo ?? " ")),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Gateway Name :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                          Text(modelData!.gatewayName ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Gateway No :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                          Text(modelData!.gatewayNo ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _DisplayList!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () async {
                            var projectName;
                            var conString;
                            var source;
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            conString = preferences.getString('ConString');
                            projectName = preferences.getString('ProjectName')!;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History_DetailsScreen(
                                      _DisplayList![index],
                                      projectName,
                                      widget.Source!)),
                            ).whenComplete(() {
                              // _firstLoad();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        height: 100,
                                        // color: Colors.red,
                                        child: Center(
                                            child: Text(
                                          // "date"
                                          DateFormat("dd MMM, yyyy").format(
                                              _DisplayList![index].dateTime!),
                                          style: TextStyle(
                                              // fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 100,
                                        // width: 1,
                                        // color: Colors.green,
                                        child: Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            height: 50,
                                            // color: Colors.grey.shade200,
                                            // color: Colors.amber,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "Electrical",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(
                                                            getLenth(_DisplayList![
                                                                            index]
                                                                        .electDamageList ??
                                                                    "")
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        // color: Colors.grey
                                                        ),
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "Mechanical",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(
                                                            getLenth(_DisplayList![
                                                                            index]
                                                                        .mechDamageList ??
                                                                    "")
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Container(
                                                height: 50,
                                                // color: Colors.orange,
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Reported By:",
                                                        style: TextStyle(
                                                          // fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        // "Api data",
                                                        workdoneby,
                                                        style: TextStyle(
                                                            // fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Remark:",
                                                        style: TextStyle(
                                                          // fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        _DisplayList![index]
                                                            .remark
                                                            .toString(),
                                                        style: TextStyle(
                                                            // fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ]),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(modelData!.gatewayNo ?? " ")),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Gateway Name :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                          Text(modelData!.gatewayName ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Gateway No :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                          Text(modelData!.gatewayNo ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      );
    }
  }

  String getLenth(String value) {
    if (value.isNotEmpty) {
      var list = value.split(",");
      return list.length.toString();
    } else {
      return 0.toString();
    }
  }

  getECMData() {
    _DisplayList = [];
    // selectedProcess = Set();
    try {
      getDamageHistorCommon(modelData!.gateWayId!, widget.Source!)
          .then((value) {
        setState(() {
          remarkval = value.first.remark ?? '';
          workedondate = (value.first.dateTime ?? '').toString();
          getWorkedByNAme((value.first.userId ?? '').toString());
          _DisplayList = value;
        });
      });
    } catch (_) {}
  }

  getWorkedByNAme(String userid) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=""&userid=$userid&conString=$conString'));

      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json['Status'] == WebApiStatusOk) {
          EngineerNameModel loginResult =
              EngineerNameModel.fromJson(json['data']['Response']);
          setState(() {
            workdoneby = loginResult.firstname.toString();
          });

          return loginResult.firstname.toString();
        } else
          return '';
      } else {
        return '';
      }
    } catch (err) {
      userName = '';
      return '';
    }
  }
}

// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, camel_case_types, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:ecm_application/Model/Project/Damage/DamageInformation.dart';
import 'package:ecm_application/Model/Project/Damage/DamageReportDetails._Model.dart';
import 'package:ecm_application/Model/Project/Damage/SelectedInformationDamageModel.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageIssues/IssueDetails_CommonScreen.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/Project/Constants.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SelectedInformationModel? modelData;
List<DamageInformationmodel>? _DisplayList = <DamageInformationmodel>[];
List<DamageDetailsCommon>? ChakNo = <DamageDetailsCommon>[];

class SelectedIssuesList extends StatefulWidget {
  String? ProjectName;
  String? Source;

  SelectedIssuesList(

      SelectedInformationModel? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  @override
  State<SelectedIssuesList> createState() => _SelectedIssuesListState();
}

class _SelectedIssuesListState extends State<SelectedIssuesList> {
  @override
  void initState() {
    super.initState();
    getDamageHistoryData();
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
        appBar: AppBar(title: Text(modelData!.chakNo ?? " ")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                            Text("Distri/Zone :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                )),
                            Text(modelData!.area ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Area/Village:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                )),
                            Text(modelData!.description ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
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
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              conString = preferences.getString('ConString');
                              projectName =
                                  preferences.getString('ProjectName')!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Issues_DetailsScreen(
                                          _DisplayList![index],
                                          projectName,
                                          widget.Source!,
                                        )),
                                // (Route<dynamic> route) => true,
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set the border radius here
                              ),
                              elevation: 8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              width: 1.0, color: Colors.black),
                                        ),
                                      ),
                                      height: 120,
                                      child: Center(
                                          child: Text(
                                        DateFormat("dd MMMM, yyyy").format(
                                            DateTime.parse(_DisplayList![index]
                                                .reportedOn!)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: getColors(getLenth(
                                                _DisplayList![index]
                                                        .informationList ??
                                                    ''))),
                                      )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 100,
                                      child: Column(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Issue Counter : ",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        Text(
                                                          getLenth(_DisplayList![
                                                                          index]
                                                                      .informationList ??
                                                                  "")
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: getLenth(_DisplayList![index]
                                                                              .informationList ??
                                                                          "") !=
                                                                      0
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Reported By : ",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.blue.shade400),
                                                ),
                                                Text(
                                                  // "Api data",
                                                  workdoneby,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Remark : ",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.blue.shade400),
                                                ),
                                                Text(
                                                  NewLine(_DisplayList![index]
                                                              .remark ??
                                                          "")
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ]),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(modelData!.chakNo ?? " ")),
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
                          Text("Distri/Zone :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                          Text(modelData!.area ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Area/Village:",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )),
                          Text(modelData!.description ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              // CircularProgressIndicator()
              ]),
        ),
      );
    }
  }

  getColors(int electrical) {
    try {
      if (electrical == 0) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } catch (ex, _) {
      return Colors.red;
    }
  }

  String NewLine(String value) {
    if (value.isNotEmpty) {
      var stringvalue = value.replaceAll(",", "\n");
      return stringvalue.toString();
    } else {
      return "".toString();
    }
  }

  int getLenth(String value) {
    if (value.isNotEmpty) {
      var list = value.split(",");
      return list.length;
    } else {
      return 0;
    }
  }

  getshortdate(String date) {
    try {
      if (date.isNotEmpty) {
        final DateTime now = DateTime.parse(date);
        final DateFormat formatter = DateFormat('d-MMM-y H:m:s');
        final String formatted = formatter.format(now);
        return formatted;
      } else {
        return '';
      }
    } catch (_) {}
  }

  getDamageHistoryData() {
    _DisplayList = [];
    try {
      if (widget.Source == 'OMS') {
        getDamageInformationCommon(modelData!.omsId!, widget.Source!, 'issue')
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? '';
            workedondate = (value.first.reportedOn ?? '').toString();
            getWorkedByNAme((value.first.reportedBy ?? '').toString());
            _DisplayList = value;
          });
        });
      } else if (widget.Source == 'AMS') {
        getDamageInformationCommon(modelData!.amsId!, widget.Source!, 'issue')
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.reportedOn ?? '').toString();
            getWorkedByNAme((value.first.reportedBy ?? '').toString());
            _DisplayList = value;
          });
        });
      } else if (widget.Source == 'RMS') {
        getDamageInformationCommon(modelData!.rmsId!, widget.Source!, 'issue')
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.reportedOn ?? '').toString();
            getWorkedByNAme((value.first.reportedBy ?? '').toString());
            _DisplayList = value;
          });
        });
      }
      else if (widget.Source=='LORA'){
        getDamageInformationCommon(modelData!.gatewayId!, widget.Source!, 'issue')
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.reportedOn ?? '').toString();
            getWorkedByNAme((value.first.reportedBy ?? '').toString());
            _DisplayList = value;
          });
        });
      }
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

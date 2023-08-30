// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, camel_case_types, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:ecm_application/Model/Project/Damage/MaterialConsumptionHistoryModel.dart';
import 'package:ecm_application/Model/Project/Damage/SelectedMaterialDamageModel.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/MaterialComsumption/DetailsOfMaterialConsumption.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/SelectedMaterialList/SelectedOmsDamageMaterialList.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SelectedMaterialDamageModel? modelData;
List<MaterialConsumptionHistoryDamageModel>? _DisplayList =
    <MaterialConsumptionHistoryDamageModel>[];

class MaterialConsumptionHistory extends StatefulWidget {
  String? ProjectName;
  String? Source;

  MaterialConsumptionHistory(
      SelectedMaterialDamageModel? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  @override
  State<MaterialConsumptionHistory> createState() =>
      _MaterialConsumptionHistoryState();
}

class _MaterialConsumptionHistoryState
    extends State<MaterialConsumptionHistory> {
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
                          Text(modelData!.areaName ?? '',
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
                            projectName = preferences.getString('ProjectName')!;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MaterialConsumptionDetails(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          DateTime.parse(
                                              _DisplayList![index].reportedOn ??
                                                  '')),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: getColors(
                                              getLenth(_DisplayList![index]
                                                      .electRectifyList ??
                                                  ''),
                                              getLenth(_DisplayList![index]
                                                      .mechRectifyList ??
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
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Source!
                                                                    .toLowerCase() !=
                                                                'lora'
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent),
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Electrical",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                      ),
                                                      Text(
                                                        getLenth(_DisplayList![
                                                                        index]
                                                                    .electRectifyList ??
                                                                "")
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: getLenth(_DisplayList![index]
                                                                            .electRectifyList ??
                                                                        "") !=
                                                                    0
                                                                ? Colors.red
                                                                : Colors.green),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                            ),
                                            if (Source!.toLowerCase() == 'oms')
                                              Expanded(
                                                child: Container(
                                                  // height: 45,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Tubing",
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
                                                                      .tubRectifyList ??
                                                                  "")
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: getLenth(_DisplayList![index]
                                                                              .tubRectifyList ??
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
                                            if (Source!.toLowerCase() != 'lora')
                                              Expanded(
                                                child: Container(
                                                  // height: 45,
                                                  decoration: BoxDecoration(
                                                      // color: Colors.grey
                                                      ),
                                                  child: Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Mechanical",
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
                                                                      .mechRectifyList ??
                                                                  "")
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: getLenth(_DisplayList![index]
                                                                              .mechRectifyList ??
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
                                              )
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
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.blue.shade400),
                                              ),
                                              Text(
                                                // "Api data",
                                                _DisplayList![index].username!,
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
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.blue.shade400),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _DisplayList![index].remark ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
  }

  getColors(int electrical, int mechanical) {
    try {
      if (electrical == 0 && mechanical == 0) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } catch (ex, _) {
      return Colors.red;
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

  getDamageHistoryData() {
    _DisplayList = [];
    try {
      if (widget.Source!.toLowerCase() == 'oms') {
        getMaterialConsumptionHistory(modelData!.omsId!, widget.Source!)
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? '';
            workedondate = (value.first.reportedOn ?? '').toString();

            _DisplayList = value;
          });
        });
      } else if (widget.Source!.toLowerCase() == 'ams') {
        getMaterialConsumptionHistory(modelData!.amsId!, widget.Source!)
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.reportedOn ?? '').toString();

            _DisplayList = value;
          });
        });
      } else if (widget.Source!.toLowerCase() == 'rms') {
        getMaterialConsumptionHistory(modelData!.rmsId!, widget.Source!)
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.reportedOn ?? '').toString();

            _DisplayList = value;
          });
        });
      } else if (widget.Source!.toLowerCase() == 'lora') {
        getMaterialConsumptionHistory(modelData!.gatewayId!, widget.Source!)
            .then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.reportedOn ?? '').toString();

            _DisplayList = value;
          });
        });
      }
    } catch (_) {}
  }
}

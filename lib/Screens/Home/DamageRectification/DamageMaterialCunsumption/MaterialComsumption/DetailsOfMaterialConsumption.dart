// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, camel_case_types, avoid_print, unused_catch_stack, use_build_context_synchronously

import 'package:ecm_application/Model/Project/Damage/MaterialConsumptionHistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

MaterialConsumptionHistoryDamageModel? modelData;

class MaterialConsumptionDetails extends StatelessWidget {
  String? ProjectName;
  String? Source;

  MaterialConsumptionDetails(MaterialConsumptionHistoryDamageModel? _modelData,
      String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  String? electrical;
  String? machanical;
  String? tubing;

  getImagePathlist() async {
    try {
      electrical = modelData!.electRectifyList;
      machanical = modelData!.mechRectifyList;
      tubing = modelData!.tubRectifyList;
    } catch (_, ex) {}
  }

  @override
  Widget build(BuildContext context) {
    getImagePathlist();
    return Scaffold(
      appBar: AppBar(title: Text(modelData!.chakNo ?? "")),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (electrical != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Set the border radius here
                    ),
                    elevation: 8,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Electrical Rectification",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              electrical!.replaceAll(",", "\n\n"),
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (machanical != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Set the border radius here
                    ),
                    elevation: 8,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Mechanical Rectification",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              machanical!.replaceAll(",", "\n\n"),
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (tubing != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Set the border radius here
                    ),
                    elevation: 8,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Tubing Rectification",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tubing!.replaceAll(",", "\n\n"),
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Reported By : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            modelData!.username.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Reported On : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat("dd MMM, yyyy").format(
                                DateTime.parse(modelData!.reportedOn ?? '')),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Remark : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              (modelData!.remark ?? '').toString(),
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}

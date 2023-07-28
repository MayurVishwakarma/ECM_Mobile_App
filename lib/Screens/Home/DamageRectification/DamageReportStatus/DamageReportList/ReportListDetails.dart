// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:typed_data';
import 'package:ecm_application/Model/Project/Damage/DamageReportDetails._Model.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/Project/Constants.dart';
import 'package:ecm_application/Model/Project/Damage/DamageCommanModel.dart';
import 'package:ecm_application/Model/Project/Damage/DamageReportCountComon.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

DamageReportCountCommon? modelData;
List<DamageInsertModel>? _DisplayList = <DamageInsertModel>[];
List<DamageInsertModel>? imageList = <DamageInsertModel>[];
List<DamageInsertModel>? Electrical = <DamageInsertModel>[];
List<DamageInsertModel>? Mechanical = <DamageInsertModel>[];
List<DamageDetailsCommon>? ChakNo = <DamageDetailsCommon>[];

class ReportListDetails extends StatefulWidget {
  String? ProjectName;
  String? Source;

  ReportListDetails(
      DamageReportCountCommon? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  @override
  State<ReportListDetails> createState() => _ReportListDetailsState();
}

class _ReportListDetailsState extends State<ReportListDetails> {
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
                if (Electrical!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Electrical Damage",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Electrical!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    Electrical![index].damage ?? "",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                if (Mechanical!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Mechanical Damage",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Mechanical!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(Mechanical![index].damage ?? "",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red)),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                if (imageList!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text("Images",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          // scrollDirection: Axis.horizontal,
                          itemCount: imageList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PreviewImageWidget(imageList![index]
                                                .imageByteArray!))),
                                child: ListTile(
                                  leading: Card(
                                    elevation: 8,
                                    child: Image.memory(
                                      imageList![index].imageByteArray!,
                                      fit: BoxFit.fitWidth,
                                      width: 80,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                if (remarkval.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Update',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'By User: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                workdoneby.toString(),
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
                                'On: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getshortdate(workedondate) ?? "",
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
                                'Remark: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  remarkval,
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
    } else {
      return _widget = const Center(child: CircularProgressIndicator());
    }
  }

  Widget? _widget;

  /*Widget _buildImageListItem(int index) {
    final imageItem = imageList![index];
    return ListTile(
      trailing: imageItem.imageByteArray != null
          ? InkWell(
              onTap: () => previewAlert(
                  imageItem.imageByteArray!, index, imageItem.image),
              child: Image.memory(
                imageItem.imageByteArray!,
                fit: BoxFit.fitWidth,
                width: 50,
                height: 50,
              ),
            )
          : Image(
              image: AssetImage('assets/images/uploadimage.png'),
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
    );
  }
*/
  void previewAlert(var photos, int index, var desc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            iconColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            // title: Text('Please choose media to select'),
            content: Container(
              margin: EdgeInsets.only(left: 4, right: 4, bottom: 7),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // InkWell(
                    //   onTap: () => Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => PreviewImageWidget(photos
                    //               // imagebytearray!
                    //               ))),
                    //   child: Image.memory(
                    //     photos!,
                    //     //to show image, you type like this.

                    //     fit: BoxFit.fitWidth,
                    //     width: 250,
                    //     height: 250,
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    // ElevatedButton(
                    //   //if user click this button, user can upload image from gallery
                    //   onPressed: () {
                    //     setState(() {
                    //       imageList[index].imageByteArray = imagebytearray;
                    //       Navigator.pop(context);
                    //     });
                    //   },
                    //   child: Row(
                    //     // ignore: prefer_const_literals_to_create_immutables
                    //     children: [
                    //       Icon(Icons.delete),
                    //       Text('Delete'),
                    //     ],
                    //   ),
                    // ),
                    // ElevatedButton(
                    //   //if user click this button, user can upload image from gallery
                    //   onPressed: () {
                    //     // hasData = false;
                    //     Navigator.pop(context);
                    //     getImage(ImageSource.gallery, index);
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.image),
                    //       Text('From Gallery'),
                    //     ],
                    //   ),
                    // ),
                    // ElevatedButton(
                    //   //if user click this button. user can upload image from camera
                    //   onPressed: () {
                    //     // hasData = false;
                    //     Navigator.pop(context);
                    //     getImage(ImageSource.camera, index);
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.camera),
                    //       Text('From Camera'),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
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

  getECMData() {
    _DisplayList = [];
    Electrical = [];
    Mechanical = [];
    imageList = [];
    // selectedProcess = Set();
    try {
      if (widget.Source == 'OMS') {
        getDamageformOms(modelData!.omsId!).then((value) {
          setState(() {
            remarkval = value.first.remark ?? '';
            workedondate = (value.first.datetime ?? '').toString();
            getWorkedByNAme((value.first.userId ?? '').toString());
            _DisplayList = value;
            imageList!.addAll(value.where((element) =>
                element.type == 'Image' && element.imageByteArray != null));
            Electrical!.addAll(value.where((element) =>
                element.type == 'Electrical' && element.value == "1"));
            Mechanical!.addAll(value.where((element) =>
                element.type == 'Mechanical' && element.value == "1"));
          });
          // selectedProcess = "Damage Form";
        });
      } else if (widget.Source == 'AMS') {
        getDamageformAms(modelData!.amsId!).then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.datetime ?? '').toString();
            getWorkedByNAme((value.first.userId ?? '').toString());
            _DisplayList = value;
            imageList!.addAll(value.where((element) =>
                element.type == 'Image' && element.imageByteArray != null));
            Electrical!.addAll(value.where((element) =>
                element.type == 'Electrical' && element.value == "1"));
            Mechanical!.addAll(value.where((element) =>
                element.type == 'Mechanical' && element.value == "1"));
            // selectedProcess = "Damage Form";
          });
        });
      } else if (widget.Source == 'RMS') {
        getDamageformRms(modelData!.rmsId!).then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.datetime ?? '').toString();
            getWorkedByNAme((value.first.userId ?? '').toString());
            _DisplayList = value;
            imageList!.addAll(value.where((element) =>
                element.type == 'Image' && element.imageByteArray != null));
            Electrical!.addAll(value.where((element) =>
                element.type == 'Electrical' && element.value == "1"));
            Mechanical!.addAll(value.where((element) =>
                element.type == 'Mechanical' && element.value == "1"));
          });
          // selectedProcess = "Damage Form";
        });
      } else if (widget.Source == 'LORA') {
        getDamageformLora(modelData!.gateWayId!).then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.datetime ?? '').toString();
            getWorkedByNAme((value.first.userId ?? '').toString());
            _DisplayList = value;
            imageList!.addAll(value.where((element) =>
                element.type == 'Image' && element.imageByteArray != null));
            Electrical!.addAll(value.where((element) =>
                element.type == 'Electrical' && element.value == "1"));
            Mechanical!.addAll(value.where((element) =>
                element.type == 'Mechanical' && element.value == "1"));
          });
          // selectedProcess = "Damage Form";
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

class PreviewImageWidget extends StatelessWidget {
  Uint8List? bytearray;
  PreviewImageWidget(this.bytearray) {
    super.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview Image')),
      body: PhotoView(imageProvider: MemoryImage(bytearray!)),
    );
  }
}

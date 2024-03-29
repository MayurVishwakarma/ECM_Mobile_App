// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, unused_element, prefer_typing_uninitialized_variables, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_collection_literals, duplicate_ignore, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, unnecessary_null_in_if_null_operators, must_be_immutable, avoid_function_literals_in_foreach_calls, unused_local_variable, use_build_context_synchronously, curly_braces_in_flow_control_structures, unnecessary_null_comparison, unnecessary_new, unused_import, camel_case_types, library_private_types_in_public_api, file_names, unused_catch_stack
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:ecm_application/Model/Project/Damage/DamageCommanModel.dart';
import 'package:ecm_application/Model/Project/Damage/LoramasterModel.dart';
import 'package:ecm_application/Model/Project/Damage/MaterialConsumption.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:ecm_application/core/SQLite/DbHepherSQL.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/Project/ImageMasterModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:ecm_application/Services/RestPmsService.dart';
import 'package:ecm_application/Widget/ExpandableTiles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

LoraMasterModel? modelData;
List<DamageInsertModel>? _DisplayList = <DamageInsertModel>[];

EngineerNameModel? usernameData;
List<EngineerNameModel>? _UserList = <EngineerNameModel>[];

class LoraDamage_Screen extends StatefulWidget {
  String? ProjectName;
  String? Source;

  LoraDamage_Screen(
      LoraMasterModel? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }
  @override
  _LoraDamage_ScreenState createState() => _LoraDamage_ScreenState();
}

class _LoraDamage_ScreenState extends State<LoraDamage_Screen> {
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    super.initState();
    setState(() {
      processList = Set();
      // selectedProcess = '';
      selectedProcess = 'Damage Form';
      _widget = const Center(child: CircularProgressIndicator());
    });
    getECMData(selectedProcess);
  }

  var subProcessname = '';
  var workedondate = '';
  var workdoneby = '';
  var remarkval = '';
  var userName = '';
  XFile? image;
  bool? isFetchingData = true;
  bool? isSubmited = false;
  bool? hasData = false;
  final ImagePicker picker = ImagePicker();
  Uint8List? imagebytearray;
  String? _remarkController;
  String? _siteEngineerTeamController;
  Widget? _widget;
  var selectedProcess;
  List<DamageInsertModel> imageList = [];
  List<DamageInsertModel>? _ChecklistModel;
  List<MaterialConsumptionModel>? _ChecklistModel2;
  var listdistinctProcess = [
    "Damage Form",
    "Material Consumption",
    "Info",
    "Issues"
  ];

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var byte = await img!.readAsBytes();
    setState(() {
      image = img;
      imageList[index].image = img;
      imageList[index].imageByteArray = byte;
      hasData = false;
    });
  }

  Widget _buildImageList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildImageListItem(index);
      },
    );
  }

  Widget _buildImageListItem(int index) {
    final imageItem = imageList[index];
    return ListTile(
      trailing: imageItem.imageByteArray != null
          ? InkWell(
              onTap: () => previewAlert(
                  imageItem.imageByteArray!, index, imageItem.damage),
              child: Image.memory(
                imageItem.imageByteArray!,
                fit: BoxFit.fitWidth,
                width: 50,
                height: 50,
              ),
            )
          : GestureDetector(
              onTap: () {
                uploadAlert(index);
              },
              child: Image(
                image: AssetImage('assets/images/uploadimage.png'),
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
      title: SizedBox(
        width: 140,
        child: Text(
          imageItem.damage!,
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
      ),
    );
  }

  Future<void> imageListpopup() async {
    await showDialog(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Container(width: 500, child: _buildImageList(context)),
        );
      },
    );
  }

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
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewImageWidget(photos
                                  // imagebytearray!
                                  ))),
                      child: Image.memory(
                        photos!,
                        //to show image, you type like this.

                        fit: BoxFit.fitWidth,
                        width: 250,
                        height: 250,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        setState(() {
                          imageList[index].imageByteArray = imagebytearray;
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Icon(Icons.delete),
                          Text('Delete'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        // hasData = false;
                        Navigator.pop(context);
                        getImage(ImageSource.gallery, index);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text('From Gallery'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      //if user click this button. user can upload image from camera
                      onPressed: () {
                        // hasData = false;
                        Navigator.pop(context);
                        getImage(ImageSource.camera, index);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text('From Camera'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void uploadAlert(int index) {
    if (isEdit == true)
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Please choose media to select'),
              content: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery, index);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text('From Gallery'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      //if user click this button. user can upload image from camera
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera, index);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text('From Camera'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }

  void _showAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText:
                      'Enter Remark*', // Placeholder text for Remark field
                ),
                onChanged: (value) {
                  _remarkController = value;
                },
                validator: (value) {
                  if (value! == '') {
                    return 'Please enter Remark'; // Validation for Remark field
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('OK'),
              onPressed: () {
                //
                if (_remarkController != null) {
                  Navigator.of(context).pop();
                  if (_ChecklistModel!.isNotEmpty) {
                    damageCheckListData(_ChecklistModel!).then((value) =>
                        _showToast(
                            isSubmited!
                                ? "Data Updated Successfully"
                                : "Something Went Wrong!!!",
                            MessageType: isSubmited! ? 0 : 1));
                  } else if (_ChecklistModel2!.isNotEmpty) {
                    damageCheckListDataForMaterial(_ChecklistModel2!).then(
                        (value) => _showToast(
                            isSubmited!
                                ? "Data Updated Successfully"
                                : "Something Went Wrong!!!",
                            MessageType: isSubmited! ? 0 : 1));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> damageCheckListDataForMaterial(
      List<MaterialConsumptionModel> _checkList) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int flagCounter = 0;
        if (widget.Source == 'lora') {
          respflag = await insertRectifyCommon(_checkList);
        }

        if (respflag) {
          getECMData(selectedProcess!);
          setState(() {
            isSubmited = true;
          });
          flag = true;
        }
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  Future<bool> insertRectifyCommon(
      List<MaterialConsumptionModel> checklist) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      var project = preferences.getString('ProjectName');
      var projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int proUserId = preferences.getInt('ProUserId')!;
      // var source = widget.Source!;
      // int gatewayId = modelData!.omsId!;

      // var imagePath = "$projectName/$source/$gatewayId/";
      int countflag = 0;
      int uploadflag = 0;

      var checkListId = checklist.map((e) => e.id).toList().join(",");
      var valueData = checklist.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      Insertobj["id"] = modelData!.gateWayId;
      Insertobj["rectifydata"] = checkListId;
      Insertobj["valuedata"] = valueData;
      Insertobj["reportedby"] = proUserId.toString();
      Insertobj["remark"] = _remarkController;
      Insertobj["source"] = "lora";
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/Rectify/InsertRectifyReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            return true;
          } else
            throw new Exception();
        } else {}
      } else {}
      throw new Exception();
    } catch (_) {
      throw new Exception();
    }
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

  String buttonText = 'Edit';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listdistinctProcess.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(getAppbarName(widget.Source!)),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("No:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          Text(modelData!.gateWayId.toString(),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Name:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          Text(modelData!.gatewayName ?? '',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0)),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: listdistinctProcess
                        .map((e) => Text(
                              e.replaceAll(' ', '\n'),
                              softWrap: true,
                              style: TextStyle(fontSize: 10),
                            ))
                        .toList(),
                    onTap: (value) async {
                      setState(() {
                        selectedProcess = listdistinctProcess.elementAt(value);
                      });
                      getECMData(selectedProcess!);
                    },
                  ),
                ),
                if (selectedProcess == "Damage Form" ||
                    selectedProcess == "Material Consumption")
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //Expandable Tile
                            getDamageFeed(),
                            //Image Selection Tile
                            if (imageList.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: imageList
                                                .where((element) =>
                                                    element.type == 'Image' &&
                                                    element.value != null)
                                                .isNotEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  imageListpopup();
                                                },
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/imagepreview.png'),
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 80,
                                                ))
                                            : GestureDetector(
                                                onTap: () {
                                                  imageListpopup();
                                                },
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/uploadimage.png'),
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 80,
                                                ))),
                                    imageList
                                            .where((element) =>
                                                element.type == 'Image' &&
                                                element.value != null)
                                            .isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: SizedBox(
                                                child: Center(
                                                    child: Text(
                                                        'Image Uploaded'))))
                                        : Center(
                                            child: Text(
                                              "No Image Uploaded",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                  ],
                                ),
                              ),

                            // Row(
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.only(left: 80),
                            //       child: ElevatedButton(
                            //         child: Text("Back To List"),
                            //         onPressed: (() async {
                            //           Navigator.pop(context);
                            //         }),
                            //         style: ElevatedButton.styleFrom(
                            //             backgroundColor: Colors.blueGrey),
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.only(left: 80),
                            //       child: ElevatedButton(
                            //         child: Text(buttonText),
                            //         onPressed: (() async {
                            //           if (buttonText == 'Edit') {
                            //             showDialog(
                            //               context: context,
                            //               builder: (BuildContext context) {
                            //                 return AlertDialog(
                            //                   title: Text("Do you want edit ?"),
                            //                   actions: [
                            //                     TextButton(
                            //                         child: Text("Cencel"),
                            //                         onPressed: () {
                            //                           Navigator.of(context)
                            //                               .pop();
                            //                         }),
                            //                     TextButton(
                            //                         child: Text("OK"),
                            //                         onPressed: () async {
                            //                           Navigator.of(context)
                            //                               .pop();
                            //                           buttonText = 'Update';
                            //                           isEdit = true;
                            //                         }),
                            //                   ],
                            //                 );
                            //               },
                            //             );
                            //           } else {
                            //             _showAlert(context);
                            //           }
                            //         }),
                            //         style: ElevatedButton.styleFrom(
                            //             backgroundColor: Colors.blueGrey),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          
                            ElevatedButton(
                              child: Text(buttonText),
                              onPressed: (() async {
                                if (buttonText == 'Edit') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Do you want edit ?"),
                                        actions: [
                                          TextButton(
                                              child: Text("Cencel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                          TextButton(
                                              child: Text("OK"),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                buttonText = 'Update';
                                                isEdit = true;
                                              }),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  _showAlert(context);
                                }
                              }),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey),
                            ),
                            if (remarkval.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    width: double.infinity,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                workdoneby.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                getshortdate(workedondate) ??
                                                    "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  remarkval,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            //Site Engineer Name
                          ]),
                    ),
                  ),
              ],
            ),
          )),
    );
  }

  getECMData(String processname) {
    if (processname == "Info" || processname == "Issues") {
      return null;
    } else if (processname == "Material Consumption" &&
        widget.Source == 'lora') {
      _ChecklistModel2 = [];
      _ChecklistModel = [];
      imageList = [];
      processList = Set();
      selectedProcess = Set();
      // else if () {
      getDamageformCommon(modelData!.gateWayId!, widget.Source!).then((value) {
        setState(() {
          remarkval = value.first.remark ?? '';
          workedondate = (value.first.reportedOn ?? '').toString();
          getWorkedByNAme((value.first.reportedBy ?? '').toString());
          _ChecklistModel2 = value;
          for (var element in _ChecklistModel2!) {
            processList!.add(element.type!);
          }
        });
        selectedProcess = "Material Consumption";
      });
      // }
    } else {
      _ChecklistModel = [];
      imageList = [];
      selectedProcess = Set();
      try {
        getDamageformLora(modelData!.gateWayId!).then((value) {
          setState(() {
            remarkval = value.first.remark ?? "";
            workedondate = (value.first.datetime ?? '').toString();
            getWorkedByNAme((value.first.userId ?? '').toString());
            _ChecklistModel = value;
            imageList.addAll(value.where((element) =>
                element.type == 'Image' &&
                element.gatewayId == modelData!.gateWayId!));
            for (var element in _ChecklistModel!) {
              processList!.add(element.type!);
            }
          });
          selectedProcess = "Damage Form";
        });

        getECMData(selectedProcess!);
      } catch (_) {}
    }
  }

  getAppbarName(String source) {
    var title;
    try {
      if (source == 'lora') {
        title = modelData!.gatewayName;
      } else {
        title = '';
      }
    } catch (_) {
      title = '';
    }
    return title;
  }

  Set<String>? processList;
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
    } catch (_) {} // print(formatted);
    // return formatted; // something like 2013-04-20
  }

  getWorkedByNAme(String userid) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=""&userid=$userid&conString=$conString'));

      print(
          'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=""&userid=$userid&conString=$conString');

      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json['Status'] == WebApiStatusOk) {
          EngineerNameModel loginResult =
              EngineerNameModel.fromJson(json['data']['Response']);
          setState(() {
            workdoneby = loginResult.firstname.toString();
          });
          print(loginResult.firstname.toString());
          return loginResult.firstname.toString();
        } else
          return '';
        // throw Exception("Login Failed");
      } else {
        return '';
      }
    } catch (err) {
      userName = '';
      return '';
    }
  }

  Future<String?> uploadImage(String ImagePath, XFile? image) async {
    try {
      var imgData = await http.MultipartFile.fromPath('Image', image!.path);
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://wmsservices.seprojects.in/api/PMS?imgDirPath=$ImagePath&Api=2'));

      request.files.add(imgData);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var path = await response.stream.bytesToString();
        if (path == '""')
          return '';
        else
          return path.replaceAll('"', '');
      } else {
        return '';
      }
    } catch (_) {}
    return '';
  }

  var getworkby;
  var getapproveby;
  bool isLoading = false;
  bool isEdit = false;
  getDamageFeed() {
    Widget? widget = const Center(child: CircularProgressIndicator());
    if (processList!.isNotEmpty && _ChecklistModel!.isNotEmpty) {
      widget = Column(
        children: [
          for (var subProcess in processList!)
            if (subProcess == "Electrical" || subProcess == "Mechanical")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ExpandableTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subProcess.toString().toUpperCase(),
                          softWrap: true,
                        ),
                        Text("Damage",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            )),
                      ],
                    ),
                    body: Column(children: [
                      for (var item in _ChecklistModel!.where((e) =>
                          e.type.toString() == subProcess && e.type != 'Image'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(item.damage!,
                                    textAlign: TextAlign.left, softWrap: true),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              if (item.damage == 'text')
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: item.value,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            // inline-size: 1,
                                            color: Colors.blue), //<-- SEE HERE
                                      ),
                                      suffixText: (item.damage != null &&
                                              item.value!.isNotEmpty)
                                          ? item.value!
                                          : '',
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        item.value = value;
                                        value = item.value = value;
                                      });
                                    },
                                  ),
                                ),
                              Expanded(
                                  flex: 0,
                                  child: Checkbox(
                                    activeColor: Colors.white54,
                                    checkColor: Color.fromARGB(255, 251, 3, 3),
                                    value: item.value == '1' ? true : false,
                                    onChanged: isEdit
                                        ? (value) {
                                            setState(() {
                                              item.value = value! ? '1' : '';
                                            });
                                          }
                                        : null,
                                  ))
                            ],
                          ),
                        )
                    ])),
              )
        ],
      );
    } else if (processList!.isNotEmpty && _ChecklistModel2!.isNotEmpty) {
      widget = Column(
        children: [
          for (var subProcess in processList!)
            if (subProcess == "Electrical" ||
                subProcess == "Mechanical" ||
                subProcess == "Tubing")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ExpandableTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subProcess.toString().toUpperCase(),
                          softWrap: true,
                        ),
                        Text("Qty",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            )),
                      ],
                    ),
                    body: Column(children: [
                      for (var item in _ChecklistModel2!
                          .where((e) => e.type.toString() == subProcess))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 15,
                                child: Text(item.rectification!,
                                    textAlign: TextAlign.left, softWrap: true),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              // if (item.rectification == 'text')
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  initialValue: item.value,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          // inline-size: 1,
                                          color: Colors.blue), //<-- SEE HERE
                                    ),
                                    // suffixText: (item.rectification != null &&
                                    //         item.value!.isNotEmpty)
                                    //     ? item.value!
                                    //     : '',
                                  ),
                                  onChanged: isEdit
                                      ? (value) {
                                          setState(() {
                                            item.value = value;
                                            value = item.value = value;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(""),
                              ),
                              // Expanded(
                              //     flex: 0,
                              //     child: Checkbox(
                              //       activeColor: Colors.white54,
                              //       checkColor: Color.fromARGB(255, 251, 3, 3),
                              //       value: item.value == '1' ? true : false,
                              //       onChanged: isEdit!
                              //           ? (value) {
                              //               setState(() {
                              //                 item.value = value! ? '1' : '';
                              //               });
                              //             }
                              //           : null,
                              //     ))
                            ],
                          ),
                        )
                    ])),
              )
        ],
      );
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }

  Future<bool> damageCheckListData(List<DamageInsertModel> _checkList) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int flagCounter = 0;
        respflag = await insertLoraDamageReport(_checkList);

        if (respflag) {
          getECMData(selectedProcess!);
          setState(() {
            isSubmited = true;
          });
          flag = true;
        }
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  Future<bool> insertLoraDamageReport(List<DamageInsertModel> imageList) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      var project = preferences.getString('ProjectName');
      var projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int proUserId = preferences.getInt('ProUserId')!;
      var source = widget.Source;
      int omsId = modelData!.gateWayId!;
      var imagePath = "$projectName/$source/$omsId/";
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(imageList
          .where((element) => element.type == 'Image' && element.image != null)
          .map((element) async {
        String? imagePathValue = await uploadImage(imagePath, element.image);
        if (imagePathValue!.isNotEmpty) {
          element.value = imagePathValue;
          uploadflag++;
        }
        countflag++;
      }));

      var checkListId = imageList.map((e) => e.id).toList().join(",");
      var valueData = imageList.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      Insertobj["gatewayid"] = modelData!.gateWayId!;
      Insertobj["userid"] = proUserId.toString();
      Insertobj["Damagedata"] = checkListId;
      Insertobj["Valuedata"] = valueData;
      Insertobj["conString"] = conString;
      Insertobj["status"] = "ok";
      Insertobj["remark"] = _remarkController;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/LoRa/InsertLoRaDamageReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            return true;
          } else
            throw new Exception();
        } else {}
      } else {}
      throw new Exception();
    } catch (_) {
      throw new Exception();
    }
  }
}

class InsertObjectModel {
  String? processId;
  String? subProcessId;
  String? checkListData;
  String? Id;
  String? userId;
  String? valuedata;
  String? Remark;
  String? TempDT;
  String? ApprovedStatus;
  String? Source;
  String? conString;
  bool? IsSiteTeamEngineerAvailable;
  String? SiteTeamEngineer;
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
      body: Container(
        child: PhotoView(imageProvider: MemoryImage(bytearray!)),
      ),
    );
  }
}

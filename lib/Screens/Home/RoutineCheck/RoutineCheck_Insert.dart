// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, unused_element, prefer_typing_uninitialized_variables, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_collection_literals, duplicate_ignore, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, unnecessary_null_in_if_null_operators, must_be_immutable, avoid_function_literals_in_foreach_calls, unused_local_variable, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_catch_stack, unnecessary_null_comparison
import 'dart:convert';

import 'package:ecm_application/Model/Project/RoutineCheck/RoutineCheckListModel.dart';
import 'package:ecm_application/Model/Project/RoutineCheck/RoutineCheckModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:flutter/foundation.dart';
import 'package:ecm_application/Services/RestPmsService.dart';
import 'package:ecm_application/Widget/ExpandableTiles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// RoutineCheckMasterModel? modelData;
List<RoutineCheckMasterModel>? _DisplayList = <RoutineCheckMasterModel>[];

EngineerNameModel? usernameData;
List<EngineerNameModel>? _UserList = <EngineerNameModel>[];

class RoutineCheck_Insert extends StatefulWidget {
  String? ProjectName;
  int? OmsId;
  String? Chakno;
  String? Areaname;
  String? Description;
  bool? Mode;
  String? Source;

  RoutineCheck_Insert(int omsid, String chakno, String areaname,
      String descripton, String project, bool mode, String source) {
    OmsId = omsid;
    Chakno = chakno;
    Areaname = areaname;
    Description = descripton;
    ProjectName = project;
    Mode = mode;
    Source = source;
  }

  @override
  _RoutineCheck_InsertState createState() => _RoutineCheck_InsertState();
}

class _RoutineCheck_InsertState extends State<RoutineCheck_Insert> {
  String? userType = '';
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    super.initState();
    setState(() {
      listProcess = [];
      listdistinctProcess = Set();
      subProcessName = Set();
      selectedProcess = '';
      _widget = const Center(child: CircularProgressIndicator());
    });
    firstLoad();
    getUserType();
  }

  var subProcessname = '';
  var workedondate = '';
  var nextscheduledate = '';
  var workdoneby = '';
  var routinecheckType = '';
  var remarkval = '';
  var siteTeamMember = '';
  var approvedon = '';
  var approvedremark = '';
  var approvedby = '';
  var userName = '';
  var userTypr = '';
  var approvedStatus;
  DateTime? currDate;

  XFile? image;
  bool? isFetchingData = true;
  bool? isSubmited = false;
  bool? hasData = false;
  final ImagePicker picker = ImagePicker();
  Uint8List? imagebytearray;
  String? _remarkController;
  String? _siteEngineerTeamController;

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var byte = await img!.readAsBytes();

    setState(() {
      imageList[index].mediaFile = img;
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
                  imageItem.imageByteArray!, index, imageItem.description),
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
          imageItem.description,
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
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
              SizedBox(height: 16.0),
              if (conString!.contains('ID=dba'))
                TextFormField(
                  decoration: InputDecoration(
                    hintText:
                        'Enter Site Team Members', // Placeholder text for Site Team Members field
                  ),
                  onChanged: (value) {
                    _siteEngineerTeamController = value;
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
                if (_remarkController != null) {
                  currDate = DateTime.now();

                  insertRoutineCheckListData(
                          _ChecklistModel!, _remarkController!, 0)
                      .then(
                    (value) {
                      switch (value) {
                        case 1:
                          _showToast(
                              "Partially done is not allow in this process",
                              MessageType: 1);
                          break;
                        case 2:
                          _showToast("Data Updated Successfully",
                              MessageType: 0);

                          // await widget.viewModel.refresh();
                          break;
                        case 3:
                          _showToast("Minimum 3 Images are required to proceed",
                              MessageType: 1);
                          break;
                        case 4:
                          _showToast("Something Went Wrong!!!", MessageType: 1);
                          break;
                      }
                    },
                  );
                  Navigator.pop(context);
                  // .whenComplete(() => _showToast(
                  //     isSubmited!
                  //         ? "Data Updated Successfully"
                  //         : "Something Went Wrong!!!",
                  //     MessageType: isSubmited! ? 0 : 1));
                }
              },
            ),
          ],
        );
      },
    );
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

  firstLoad() async {
    await getRoutineCheckList(
            widget.OmsId.toString(), widget.Source!.toString())
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listProcess = value;
        });
      }
    }).whenComplete(() {
      setState(() {
        for (var element in listProcess!) {
          listdistinctProcess!.add(element.routineTestType!);
        }
        selectedProcess = listdistinctProcess!.first;
        imageList = [];
      });
    });
    getECMData(selectedProcess!);
  }

  Widget? _widget;
  String? selectedProcess;
  List imageList = [];
  List<RoutineCheckListModel>? _ChecklistModel;
  List<RoutineCheckListModel>? listProcess;
  Set<String>? subProcessName;
  Set<String>? listdistinctProcess;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listdistinctProcess!.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.Chakno!),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(5.0)),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: listdistinctProcess!
                        .map((e) => Text(
                              e.replaceAll(' ', '\n'),
                              softWrap: true,
                              style: TextStyle(fontSize: 10),
                            ))
                        .toList(),
                    onTap: (value) async {
                      setState(() {
                        selectedProcess = listdistinctProcess!.elementAt(value);
                      });
                      getECMData(selectedProcess!);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedProcess == 'MANUAL CHECK')
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Distibutory : ' + widget.Areaname!),
                                  Text('Sub Area : ' + widget.Description!)
                                ],
                              ),
                            ),
                          //Expandable Tile
                          getECMFeed(),
                          //Image Selection Tile
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: imageList
                                            .where((element) =>
                                                element.inputType == 'image' &&
                                                element.routineTestType ==
                                                    selectedProcess &&
                                                element.value != null)
                                            .isNotEmpty
                                        ? GestureDetector(
                                            onTap: () async {
                                              await imageListpopup();
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/imagepreview.png'),
                                              fit: BoxFit.cover,
                                              height: 80,
                                              width: 80,
                                            ))
                                        : GestureDetector(
                                            onTap: () async {
                                              await imageListpopup();
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
                                            element.inputType == 'image' &&
                                            element.routineTestType ==
                                                selectedProcess &&
                                            element.value != null)
                                        .isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SizedBox(
                                            child: Center(
                                                child: Text('Image Uploaded'))))
                                    : Center(
                                        child: Text(
                                          "No Image Uploaded",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          //Submit Button

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    "Submit",
                                  ),
                                  onPressed: (() async {
                                    await btnSubmit_Clicked();
                                    // _showAlert(context);
                                  }),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white
                                      ),
                                ),
                              ],
                            ),
                          ),

                          if (siteTeamMember.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Site Team Member: ',
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    siteTeamMember,
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,

                                      // color: Colors.black,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          //Submittion Tile
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
                                      // Text(
                                      //   'Submited',
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Last Routine check done By: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
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
                                              'Last Routine check Type : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              routinecheckType.toString(),
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
                                              'On Date : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              getshortdate(workedondate),
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
                                              'Next Schedule Date : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              getshortdate(nextscheduledate),
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
                                                  fontWeight: FontWeight.bold),
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
                        ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  getECMData(String processName) async {
    _ChecklistModel = [];
    imageList = [];
    subProcessName = Set();
    try {
      getRoutineCheckList(widget.OmsId.toString(), widget.Source!.toString())
          .then((value) {
        for (var element in value) {
          if (element.inputType != 'image' &&
              element.routineTestType == selectedProcess) {
            setState(() {
              subProcessName!.add(element.processType!);
              subProcessname = (element.processType ?? '').toString();
              workedondate = (element.workedOn ?? '').toString();
              nextscheduledate = (element.nextScheduleDate ?? '').toString();
              remarkval = (element.remark ?? '').toString();
              getWorkedByNAme((element.workedBy ?? '').toString());
              routinecheckType = ((element.routineTestType ?? '')).toString();
            });
          }
        }
        setState(() {
          _ChecklistModel!.addAll(value
              .where((element) => element.routineTestType == selectedProcess!));

          imageList.addAll(value.where((element) =>
              element.inputType == 'image' &&
              element.routineTestType == selectedProcess));
        });
      });
    } catch (_) {}
  }

  getECMFeed() {
    Widget? widget = const Center(child: CircularProgressIndicator());
    if (subProcessName!.isNotEmpty && _ChecklistModel!.isNotEmpty) {
      widget = Column(
        children: [
          for (var subProcess in subProcessName!)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ExpandableTile(
                  title: Text(
                    subProcess.toUpperCase(),
                    softWrap: true,
                  ),
                  body: Column(children: [
                    for (var item in _ChecklistModel!.where((e) =>
                        e.processType == subProcess &&
                        e.routineTestType == selectedProcess &&
                        e.inputType != 'image' &&
                        e.processType != 'image'))
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(item.description!,
                                  textAlign: TextAlign.left, softWrap: true),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            if (item.inputType == 'boolean')
                              Expanded(
                                  flex: 0,
                                  child: Checkbox(
                                    activeColor: Colors.white54,
                                    checkColor: Colors.green,
                                    value: item.value == 'OK' ? true : false,
                                    onChanged: (value) {
                                      setState(() {
                                        item.value = value! ? 'OK' : '';
                                      });
                                    },
                                  )),
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

  getshortdate(String date) {
    try {
      if (date.length > 0) {
        final DateTime now = DateTime.parse(date);
        final DateFormat formatter = DateFormat('d-MMM-y H:m:s');
        final String formatted = formatter.format(now);
        return formatted;
      } else {
        return '';
      }
    } catch (_, ex) {} // print(formatted);
    // return formatted; // something like 2013-04-20
  }

  getUserType() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userType = pref.getString('usertype');
    } catch (_, ex) {
      userType = '';
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

  Future<String> GetImagebyPath(String imgPath) async {
    String img64base = "";
    try {
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://wmsservices.seprojects.in/api/Image/GetImage?imgPath=$imgPath'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        img64base = await response.stream.bytesToString();
      } else {
        print(response.reasonPhrase);
      }
    } catch (_, ex) {}
    return img64base;
  }

  Future btnSubmit_Clicked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool allow = true;
      String _proj = prefs.getString("ProjectName")!.toLowerCase();

      if (allow) {
        _showAlert(context);
      }
    } catch (ex, _) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(ex.toString()),
            actions: <Widget>[
              TextButton(
                child: Text(WebApiStatusOk),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<int> insertRoutineCheckListData(List<RoutineCheckListModel> _checkList,
      String _remark, int _processIndex) async {
    bool flag = false;
    int _routineStatus = 0;
    try {
      var _list = _checkList
          .where((item) =>
              !item.inputType!.contains("image") &&
              item.routineTestType!.toString().contains(selectedProcess!))
          .toList();

      var _listdataWithoutNullValue = _checkList
          .where((item) =>
              !item.inputType!.contains("image") &&
              item.value != null &&
              item.value!.isNotEmpty &&
              item.routineTestType!.toString().contains(selectedProcess!))
          .toList();

      var _imglist = _checkList
          .where((item) =>
              item.inputType!.contains("image") &&
              item.routineTestType!.toString().contains(selectedProcess!))
          .toList();

      var _imglistdataWithoutNullValue = _checkList
          .where((item) =>
              item.inputType!.contains("image") &&
              item.mediaFile != null &&
              item.routineTestType!.toString().contains(selectedProcess!))
          .toList();

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      String? project = preferences.getString('ProjectName');
      String? projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int? proUserId = preferences.getInt('ProUserId');
      var omsId = widget.OmsId;
      String submitDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currDate!);
      final _userName = preferences.getString('firstname');

      final dirPath = "${projectName}/$omsId/${_userName}-${submitDate}";
      final _routineStatus = 2;

      int countflag = 0;
      int uploadflag = 0;

      if (_listdataWithoutNullValue.isEmpty) {
        return 1; // refer no checklist selected
      }

      if (_imglistdataWithoutNullValue.length <= 3) {
        return 3; // refer mandatary 3 image conaition is not satisfied
      } else {
        await Future.wait(_imglistdataWithoutNullValue
            .where((element) =>
                element.inputType == 'image' && element.mediaFile != null)
            .map((element) async {
          String? imagePathValue =
              await uploadImage(dirPath, element.mediaFile);
          if (imagePathValue!.isNotEmpty) {
            element.value = imagePathValue;
            uploadflag++;
          }
          countflag++;
        }));
      }

      final _checkListData = _list.map((x) => x.id.toString()).join(',') +
          ',' +
          _imglist.map((x) => x.id.toString()).join(',');

      final _valueData = _list.map((x) => x.value?.trim() ?? '').join(',') +
          ',' +
          _imglist.map((x) => x.value?.trim() ?? '').join(',');

      // var _checkListData = imageList.map((e) => e.id).toList().join(",");
      // var _valueData = imageList.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      Insertobj["checkListData"] = _checkListData;
      Insertobj["OmsId"] = widget.OmsId;
      Insertobj["userId"] = proUserId.toString();
      Insertobj["valuedata"] = _valueData;
      Insertobj["Remark"] = _remark;
      Insertobj["RoutineStatus"] = _routineStatus;
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/Routine/InsertRoutineReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            isSubmited = true;
            getECMData(selectedProcess!);
            return 2;
          } else
            throw Exception();
        } else
          throw Exception();
      } else {
        throw Exception();
      }
    } catch (_) {
      return 4; // refer to something went wrong in insertion api
    }
  }

  /*Future<bool> insertCheckListDataWithSiteTeamEngineer(
      List<RoutineCheckListModel> _checkList) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int approveStatus = 0;
        int checkCount = _checkList
            .where((e) =>
                (e.value == null || e.value!.isEmpty) && e.inputType != "image")
            .length;
        int imageCount = _checkList
            .where((e) =>
                ((e.value == null || e.value!.isEmpty) ||
                    e.mediaFile != null) &&
                e.inputType == "image")
            .length;
        bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');
        if (checkCount !=
                _checkList.where((e) => e.inputType != "image").length ||
            imageCount != 0) {
          if (imageCount >= 3 && checkCount == 0)
            approveStatus = isPartialProcess ? 1 : 2;
          else if (!isPartialProcess) {
            approveStatus = 1;
          } else {
            if (imageCount < 3)
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Message"),
                    content: Text("Minimum 3 Images are required to proceed"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            if (checkCount != 0)
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Message"),
                    content:
                        Text("Partially done is not allow in this process"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            // print("Partially done is not allow in this process");
            return false;
          }
        } else {
          return false;
        }

        int flagCounter = 0;
        for (var subpro in subProcessName!) {
          var list = _checkList
              .where((element) =>
                  element.routineTestType!.toLowerCase() ==
                  subpro.toLowerCase())
              .toList();

          respflag = await insertCheckListDataWithSiteTeamEngineer_func(
              list, list.first.routineTestType!,
              apporvedStatus: approveStatus);
          if (respflag) {
            flagCounter++;
          }
        }
        if (flagCounter == subProcessName!.length) {
          getECMData(selectedProcess!);
          setState(() {
            isSubmited = true;
          });
          flag = true;
        } else
          throw new Exception();
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  Future<bool> insertCheckListDataWithSiteTeamEngineer_func(
      List<RoutineCheckListModel> imageList, String subprocessname,
      {int apporvedStatus = 0}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      String? project = preferences.getString('ProjectName');
      String? projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int? proUserId = preferences.getInt('ProUserId');
      var omsId = widget.OmsId;
      String submitDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currDate!);

      var imagePath = "$projectName/$omsId/";

      int countflag = 0;
      int uploadflag = 0;

      // Map each element in imageList to a Future returned by uploadImage,
      // then use Future.wait to wait for all the Futures to complete
      // before continuing
      await Future.wait(imageList
          .where((element) =>
              element.inputType == 'image' && element.mediaFile != null)
          .map((element) async {
        String? imagePathValue =
            await uploadImage(imagePath, element.mediaFile);
        if (imagePathValue!.isNotEmpty) {
          element.value = imagePathValue;
          uploadflag++;
        }
        countflag++;
      }));

      var checkListId = imageList.map((e) => e.id).toList().join(",");
      var valueData = imageList.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      Insertobj["checkListData"] = checkListId;
      Insertobj["omsid"] = widget.OmsId;
      Insertobj["userId"] = proUserId.toString();
      Insertobj["valuedata"] = valueData;
      Insertobj["RoutineStatus"] = 2;
      Insertobj["Remark"] = _remarkController;
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/Routine/InsertRoutineReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            return true;
          } else
            throw new Exception();
        } else
          throw new Exception();
      } else {
        throw new Exception();
      }
    } catch (_, ex) {
      return false;
    }
  }
*/
}

class InsertObjectModel {
  String? checkListData;
  String? OmsId;
  String? userId;
  String? valuedata;
  String? Remark;
  String? RoutineStatus;
  String? conString;
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

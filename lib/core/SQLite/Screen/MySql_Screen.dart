// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, camel_case_types, must_be_immutable, unused_catch_stack, unused_field, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, unused_element, prefer_collection_literals

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/Common/EngineerModel.dart';
import '../../../Model/Project/Constants.dart';
import '../../../Model/Project/ECMTool/ECM_Checklist_Model.dart';
import '../../../Model/Project/ECMTool/PMSListViewModel.dart';
import '../../../Screens/Home/ECM_Tool-Screen/NodeDetails_new.dart';
import '../../../Widget/ExpandableTiles.dart';
import '../DbHepherSQL.dart';

PMSListViewModel? modelDatas;
List<PMSListViewModel>? _Listdata = <PMSListViewModel>[];

class MySql_Screen extends StatefulWidget {
  int? omsId;
  int? amsId;
  int? getwayId;
  int? rmsId;
  int? processId;
  int? deviceId;
  String? ProjectName;
  String? Source;
  PMSListViewModel? modelDatas;

  MySql_Screen(
      {this.modelDatas,
      this.ProjectName,
      this.Source,
      this.omsId,
      this.amsId,
      this.rmsId,
      this.getwayId,
      this.processId,
      this.deviceId});
  @override
  State<MySql_Screen> createState() => _MySql_ScreenState();
}

class _MySql_ScreenState extends State<MySql_Screen> {
  bool isLoading = false;
  var proccessid;
  var subprocessid;
  var deviceId;
  var deviceids;
  String? processName;
  String? subprocessName;
  String? project;
  String? projectName;
  int? proUserId;
  int? omsId;
  String? source;
  var Source;
  var imagePath;
  String subProcessId = "";
  var approved;

  List<PMSListViewModel> Listdata = [];
  List<ECM_Checklist_Model> datas = [];
  List<ECM_Checklist_Model> datas11 = [];

  @override
  void initState() {
    setState(() {
      listProcess = [];
      listdistinctProcess = Set();
      subProcessName = Set();
      selectedProcess = '';
      _widget = const Center(child: CircularProgressIndicator());
    });
    if (datas.isEmpty) {
      fatchFirstloadAms(widget.amsId!);
      fatchFirstloadOms(widget.omsId!);
      fatchFirstloadLora(widget.getwayId!);
      fatchFirstloadRms(widget.rmsId!);
    }

    super.initState();
  }

  firstLoad() async {
    if (datas.isNotEmpty) {
      setState() {
        listProcess = datas;
        proccessid = datas.first.processId;
        deviceId = datas.first.deviceId;
        subprocessid = datas.first.subProcessId;
        processName = datas.first.processName;
        subprocessName = datas.first.subProcessName;
        selectedProcess = listdistinctProcesss.first.processName;
      }
    }

    getECMData(selectedProcess!);
    setState(() {
      Source = widget.Source;
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
    } catch (_, ex) {}
  }

  List<ECM_Checklist_Model>? lsitdata;
  List<ECM_Checklist_Model>? datasimg;
  var subProcessname = '';
  var workedondate = '';
  var workdoneby = '';
  var remarkval = '';
  var siteTeamMember = '';
  var approvedon = '';
  var approvedremark = '';
  var approvedby = '';
  var userName = '';
  DateTime? currDate;

  XFile? image;
  bool? isFetchingData = true;
  bool? isSubmited = false;
  bool? hasData = false;
  final ImagePicker picker = ImagePicker();
  Uint8List? imagebytearray;
  String? _remarkController;
  String? _siteEngineerTeamController;

  var values;
  List<PMSChaklistModel> listdistinctProcesss = [];
  PMSListViewModel? modelData;
  String? selectedProcess;

//oms
  Future fatchFirstloadOms(int omsid) async {
    if (omsid != 0) {
      setState(() => isLoading = true);
      Listdata = await ListViewModel.instance.fatchdataPMSView11oms(omsid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance.fatchdataSQCommon(omsid);
      await firstLoad();
      setState(() => isLoading = false);
    }
  }

  //ams
  Future fatchFirstloadAms(int amsid) async {
    if (amsid != 0) {
      setState(() => isLoading = true);
      Listdata = await ListViewModel.instance.fatchdataPMSView11Ams(amsid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance.fatchdataSQCommon(amsid);
      // listdistinctProcesss.first.processId!, Listdata.first.deviceType);
      await firstLoad();
      setState(() => isLoading = false);
    }
  }

  //lora
  Future fatchFirstloadLora(int getwayid) async {
    if (getwayid != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11getway(getwayid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance.fatchdataSQCommon(getwayid);
      await firstLoad();
      setState(() => isLoading = false);
    }
  }

  //rms
  Future fatchFirstloadRms(int rmsid) async {
    if (rmsid != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance.fatchdataPMSView11rms(rmsid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance.fatchdataSQCommon(rmsid);
      await firstLoad();
      setState(() => isLoading = false);
    }
  }

//oms
  Future fatchFirstloadOmsoff(int omsid, String processName) async {
    if (omsid != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance.fatchdataPMSView11oms(omsid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance
          .fatchdataSQLfatch(omsid, processIds!, processName);
      setState(() => isLoading = false);
      subProcessName = Set();
      for (var element in datas) {
        setState(() {
          getWorkedByNAme((element.workedBy ?? '').toString());
          subProcessName!.add(element.subProcessName!);
          workedondate = (element.workedOn ?? '').toString();
        });
      }
    }
  }

  //ams
  Future fatchFirstloadAmsoff(int amsid, String processName) async {
    if (amsid != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance.fatchdataPMSView11Ams(amsid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance
          .fatchdataSQLfatch(amsid, processIds!, processName);
      setState(() => isLoading = false);
      subProcessName = Set();
      for (var element in datas) {
        setState(() {
          getWorkedByNAme((element.workedBy ?? '').toString());
          subProcessName!.add(element.subProcessName!);
          workedondate = (element.workedOn ?? '').toString();
        });
      }
    }
  }

  //lora
  Future fatchFirstloadLoraoff(int getwayid, String processName) async {
    if (getwayid != 0) {
      // setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11getway(getwayid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance
          .fatchdataSQLfatch(getwayid, processIds!, processName);
      // setState(() => isLoading = false);
      subProcessName = Set();
      for (var element in datas) {
        setState(() {
          getWorkedByNAme((element.workedBy ?? '').toString());
          subProcessName!.add(element.subProcessName!);
          workedondate = (element.workedOn ?? '').toString();
        });
      }
    }
  }

  //rms
  Future fatchFirstloadRmsoff(int rmsid, String processName) async {
    if (rmsid != 0) {
      // setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance.fatchdataPMSView11rms(rmsid);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datas = await DBSQL.instance
          .fatchdataSQLfatch(rmsid, processIds!, processName);
      // setState(() => isLoading = false);
      subProcessName = Set();
      for (var element in datas) {
        setState(() {
          getWorkedByNAme((element.workedBy ?? '').toString());
          subProcessName!.add(element.subProcessName!);
          workedondate = (element.workedOn ?? '').toString();
        });
      }
    }
  }

  List<ECM_Checklist_Model> allchecklist = [];
  Future fatchdataSQL(String selectprocess, int processId) async {
    setState(() => isLoading = true);
    allchecklist = await DBSQL.instance.fatchdataSQCommon(widget.omsId!);
    Listdata = await ListViewModel.instance.fatchdataPMSViewData();
    listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
    datas = await DBSQL.instance.fatchdataSQLProcess(
        widget.deviceId!, processId, widget.Source!, selectprocess);
    setState(() => isLoading = false);
  }

  bool ischecked() {
    return false;
  }

  Widget? _widget;
  int? processId;
  int? processIds;
  List<ECM_Checklist_Model> imageList = [];
  List<ECM_Checklist_Model>? _ChecklistModel;
  List<ECM_Checklist_Model>? listProcess;
  Set<String>? subProcessName;
  Set<String>? listdistinctProcess;

  //we can upload image from camera or from gallery based on parameter
  Future<bool> storeImagesInSharedPref(
      String imagePath, String checkListId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(checkListId, imagePath);
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var imageselected = File(img!.path);
    var byte = await img.readAsBytes();
    await storeImagePath(img);
    final duplicateFilePath = await getExternalStorageDirectory();
    final fileName = basename(img.path);
    await img.saveTo('${duplicateFilePath!.path}/$fileName');
    storeImagesInSharedPref(img.path, imageList[index].checkListId.toString());
    setState(() {
      // image = img;
      // preferences.setString("imagePath", img.path);
      // imageList[index].value = img.path;
      (datas.where((e) => e.inputType == "image").toList())[index].value =
          img.path;
      //imageList[index].image = img;
      (datas.where((e) => e.inputType == "image").toList())[index]
          .imageByteArray = byte;
      hasData = false;
    });
  }

// Store XFile path in SharedPreferences
  Future<void> storeImagePath(XFile file) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', file.path);
    print(prefs);
  }

// Retrieve XFile path from SharedPreferences
  Future<XFile?> retrieveImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      return XFile(imagePath);
    }
    return null;
  }

  void imageListpopup() {
    // fatchdataSQLImage();
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Container(
            height: 300,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  (datas.where((e) => e.inputType == "image").toList()).length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  trailing: (datas
                                  .where((e) => e.inputType == "image")
                                  .toList())[index]
                              .imageByteArray !=
                          null
                      ? InkWell(
                          onTap: () => previewAlert(
                            (datas
                                    .where((e) => e.inputType == "image")
                                    .toList())[index]
                                .imageByteArray!,
                            index,
                            (datas
                                    .where((e) => e.inputType == "image")
                                    .toList())[index]
                                .description,
                          ),
                          child: Image.memory(
                            (datas
                                    .where((e) => e.inputType == "image")
                                    .toList())[index]
                                .imageByteArray!,
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
                      (datas
                              .where((e) => e.inputType == "image")
                              .toList())[index]
                          .description!,
                      style: const TextStyle(color: Colors.green, fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
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
                      children: const [
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
                      children: const [
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

//update fun
  void _showAlert_off(BuildContext context) async {
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
                final snackBar = SnackBar(
                  content: const Text('Update Sucessfully'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (_remarkController != null) {
                  currDate = DateTime.now();
                  Navigator.of(context).pop();
                  // addAll(datas);
                }
                for (int j = 0; j <= datas.length; j++) {
                  datas[j].remark = _remarkController;
                  datas[j].deviceId = widget.omsId;
                  datas[j].approvedBy = approved;
                  datas[j].source = widget.Source;
                  // _ChecklistModel![j].processName = processName;
                  datas[j].conString = conString;
                  datas[j].approvalRemark = approvedremark;
                  lsitdata = datas;
                }
              },
            ),
          ],
        );
      },
    );

    await update();
  }

  Future update() async {
    if (datas.isNotEmpty) {
      for (int i = 0; i <= lsitdata!.length; i++) {
        final data = lsitdata![i];
        DBSQL.instance.SQLUpdatedata(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (listdistinctProcesss.isNotEmpty) {
      return DefaultTabController(
        length: listdistinctProcesss.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Listdata.first.chakNo ?? ""),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.0)),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: listdistinctProcesss
                      .map((e) => FittedBox(
                            child: Text(
                              e.processName?.replaceAll(' ', '\n') ?? "",
                              softWrap: true,
                              style: TextStyle(fontSize: 10),
                            ),
                          ))
                      .toList(),
                  onTap: (value) async {
                    setState(() {
                      selectedProcess =
                          listdistinctProcesss.elementAt(value).processName;
                    });
                    getECMData(selectedProcess!);
                  },
                ),
              ),
              if (datas.isNotEmpty)
                Expanded(
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              getECMFeed(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: (datas
                                                .where((element) =>
                                                    element.processId ==
                                                        processId &&
                                                    element.inputType ==
                                                        'image' &&
                                                    element.value != null)
                                                .isNotEmpty)
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
                                    (datas
                                            .where((element) =>
                                                element.processId ==
                                                    processId &&
                                                element.inputType == 'image' &&
                                                element.value != null)
                                            .isNotEmpty)
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),

                                // Text("data"),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (() async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'ARE YOU SURE TO UPLOAD'),
                                              // content: Text('30Ha node'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text('OK'),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    if (datas.isNotEmpty) {
                                                      await insertCheckListDataWithSiteTeamEngineer_off(
                                                          datas);
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.5)),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.amber),
                                      child: Text(
                                        "upload offline data",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                          'Submited',
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
                                                'By: ',
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
                                                getshortdate(
                                                    datas.first.tempDT!),
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
                                                "Remark: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  // datas.first.approvalRemark!,
                                                  datas.first.remark ?? "",
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
                            ]))),
            ]),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
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
                          datas[index].imageByteArray = imagebytearray;
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
                        children: const [
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
                        children: const [
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

  Future fatchdataSQLbyprocessid(String Source, int processid) async {}
  getECMData(String processName) async {
    setState(() {
      processId = listdistinctProcesss
          .singleWhere(
            (item) => item.processName == processName,
          )
          .processId;
    });
    setState(() {
      processIds = processId;
    });
    // await fatchdataSQL(processName, processId!);
    // if (processName == datas.first.processName) {
    fatchFirstloadAmsoff(widget.amsId!, processName);
    fatchFirstloadOmsoff(widget.omsId!, processName);
    fatchFirstloadLoraoff(widget.getwayId!, processName);
    fatchFirstloadRmsoff(widget.rmsId!, processName);
    // }
  }

  getWorkedByNAme(String userid) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=""&userid=$userid&conString=$conString'));

      // print(
      //     'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=""&userid=$userid&conString=$conString');

      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json['Status'] == WebApiStatusOk) {
          EngineerNameModel loginResult =
              EngineerNameModel.fromJson(json['data']['Response']);
          setState(() {
            workdoneby = loginResult.firstname.toString();
          });
          return loginResult.firstname.toString();
        } //else
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
        if (path == '""') {
          return '';
        } else {
          return path.replaceAll('"', '');
        }
      } else {
        return '';
      }
    } catch (_) {}
    return '';
  }

  Future<bool> insertCheckListDataWithSiteTeamEngineer_off(
      List<ECM_Checklist_Model> _checkList) async {
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
                    e.imageByteArray != null) &&
                e.inputType == "image")
            .length;
        int imagewithvalue = _checkList
            .where((e) =>
                ((e.value == null || e.value!.isEmpty) || e.image != null) &&
                e.inputType == "image")
            .length;
        bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');

        var _imglistdataWithoutNullValue = _checkList
            .where((item) =>
                item.inputType!.contains("image") &&
                item.imageByteArray != null)
            .toList();

        if (checkCount !=
                _checkList.where((e) => e.inputText != "image").length ||
            imageCount != 0) {
          if (checkCount == 0 && _imglistdataWithoutNullValue.length < 3) {
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
            return false;
          } else if (imageCount >= 3 && checkCount == 0) {
            approveStatus = isPartialProcess ? 1 : 2;
          } else if (!isPartialProcess) {
            approveStatus = 1;
          } else {
            if (imageCount < 3) {
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
            }
            if (checkCount != 0) {
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
            }
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
                  element.subProcessName!.toLowerCase() == subpro.toLowerCase())
              .toList();
          respflag = await insertCheckListDataWithSiteTeamEngineer_Send(
              list, list.first.subProcessId!,
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
          setState(() {
            Source = widget.Source;
          });

          await listdatacheckup();
          await DBSQL.instance.deleteCheckListData(
              datas.first.deviceId!, datas.first.processId!);
          await DeviceAllDAta();
          if (nodedata.isEmpty) {
            await listdatacheckup();
            Navigator.of(context).pop(true);
          }

          setState(() {
            isSubmited = true;
          });
          setState(() {
            Source = widget.Source;
          });
          flag = true;
        } else {
          throw new Exception();
        }
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  List<ECM_Checklist_Model> nodedata = [];
  DeviceAllDAta() async {
    if (widget.omsId != 0) {
      nodedata = await DBSQL.instance.fatchdataSQLbyDeviceId(widget.omsId!);
    }
    if (widget.amsId != 0) {
      nodedata = await DBSQL.instance.fatchdataSQLbyDeviceId(widget.amsId!);
    }
    if (widget.rmsId != 0) {
      nodedata = await DBSQL.instance.fatchdataSQLbyDeviceId(widget.rmsId!);
    }
    if (widget.getwayId != 0) {
      nodedata = await DBSQL.instance.fatchdataSQLbyDeviceId(widget.getwayId!);
    }
    // await DBSQL.instance.fatchdataSQLbyDeviceId(widget.omsId!);
  }

  Future listdatacheckup() async {
    if (widget.modelDatas!.omsId != 0) {}
    await ListViewModel.instance.deleteListDataoms(widget.modelDatas!.omsId!);
    if (widget.modelDatas!.amsId != 0) {
      await ListViewModel.instance.deleteListDataams(widget.modelDatas!.amsId!);
    }
    if (widget.modelDatas!.rmsId != 0) {
      await ListViewModel.instance.deleteListDatarms(widget.modelDatas!.rmsId!);
    }
    if (widget.modelDatas!.gateWayId != 0) {
      await ListViewModel.instance
          .deleteListDatagetway(widget.modelDatas!.gateWayId!);
    }
  }

  Future<XFile> getPrefImage(checkListId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var imagePath1 = pref.getString("${checkListId.toString()}");
    return XFile(imagePath1!);
  }

  int deletecounter = 0;
  Future<bool> insertCheckListDataWithSiteTeamEngineer_Send(
      List<ECM_Checklist_Model> imageList, int subprocessId,
      {int apporvedStatus = 0}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      project = preferences.getString('ProjectName');
      projectName = preferences.getString('ProjectName')!.replaceAll(' ', '_');
      proUserId = imageList.first.workedBy;
      source = widget.Source;

      omsId = getDeviceid(widget.Source!);
      String submitDate = imageList.first.tempDT!;

      imagePath = "$projectName/$source/$omsId/";

      int countflag = 0;
      int uploadflag = 0;

      await Future.wait(imageList
          .where((element) =>
              element.inputType == 'image' && element.imageByteArray != null)
          .map((element) async {
        int index = imageList.indexOf(element);
        String? imagePathValue =
            await uploadImageNew(imagePath, index, imageList);
        if (imagePathValue!.isNotEmpty) {
          element.value = imagePathValue;
          uploadflag++;
        }
        countflag++;
      }));

      var checkListId = imageList.map((e) => e.checkListId).toList().join(",");
      var valueData = imageList.map((e) => e.value ?? '').toList().join(",");
      var aproveStatus = apporvedStatus;
      var Insertobj = new Map<String, dynamic>();
      Insertobj["processId"] = processId;
      Insertobj["subProcessId"] = subprocessId;
      Insertobj["checkListData"] = checkListId;
      Insertobj["deviceId"] = getDeviceid(widget.Source!);
      Insertobj["userId"] = proUserId.toString();
      Insertobj["valuedata"] = valueData;
      Insertobj["Remark"] = imageList.first.remark;
      Insertobj["TempDT"] = submitDate;
      Insertobj["ApprovedStatus"] = aproveStatus;
      Insertobj["Source"] = widget.Source;
      Insertobj["conString"] = conString;

      // if (countflag == uploadflag) {
      var headers = {'Content-Type': 'application/json'};
      final request = http.Request(
          "POST",
          Uri.parse(
              'http://wmsservices.seprojects.in/api/PMS/InsertECMReport_New'));
      request.headers.addAll(headers);
      request.body = json.encode(Insertobj);
      http.StreamedResponse response = await request.send();

      //await getWorkedByNAmeOff(proUserId.toString());
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(await response.stream.bytesToString());
        if (json["Status"] == "Ok") {
          if (subprocessId == subProcessName!.length) {
            await listdatacheckup();
            await DBSQL.instance
                .deleteCheckListData(imageList.first.deviceId!, processId!);
            Navigator.pop(context);
            Navigator.pop(context);
          }
          return true;
        } else {
          throw new Exception();
        }
      } else {}
      // } else {}
      throw new Exception();
    } catch (_, ex) {
      throw new Exception();
    }
  }

  Future<String?> uploadImageoff(String ImagePath, XFile? image) async {
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
        if (path == '""') {
          return '';
        } else {
          return path.replaceAll('"', '');
        }
      } else {
        return '';
      }
    } catch (_) {}
    return '';
  }

  Future<String?> uploadImageNew(String ImagePath, int index,
      List<ECM_Checklist_Model> imageListNew) async {
    try {
      if (
          // imageListNew[index].value == null &&
          imageListNew[index].imageByteArray != null) {
        XFile? image = await getPrefImage(imageListNew[index].checkListId);
        await clearImageFromSharedPreferences(
            imageListNew[index].checkListId.toString());
        String? testpath = await uploadImage(ImagePath, image);
        return testpath;
      } else {
        return '';
      }
    } catch (_) {}
    return '';
  }

  Future<void> clearImageFromSharedPreferences(checkListId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(
        checkListId); // Replace 'imageKey' with the key you used to store the image
  }

//display function
  getECMFeed() {
    Widget? widget = const Center(child: CircularProgressIndicator());
    if (subProcessName!.isNotEmpty && datas.isNotEmpty) {
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
                    for (var item in datas.where((e) =>
                        e.subProcessName == subProcess &&
                        e.processId == processId &&
                        e.inputType != 'image'))
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
                            if (item.inputType == 'text' ||
                                item.inputType == 'float')
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  initialValue: item.value,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.blue), //<-- SEE HERE
                                    ),
                                    suffixText: (item.inputText != null &&
                                            item.inputText!.isNotEmpty)
                                        ? item.inputText!
                                        : '',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      item.value = value;
                                    });
                                  },
                                ),
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
                                  ))
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

  getAppbarName(String source) {
    var title;
    try {
      if (source == 'oms') {
        title = modelData!.chakNo.toString();
      } else if (source == 'ams') {
        title = modelData!.amsNo.toString();
      } else if (source == 'rms') {
        title = modelData!.rmsNo.toString();
      } else if (source == 'lora') {
        title = modelData!.gatewayName;
      } else {
        title = '';
      }
    } catch (_, ex) {
      title = '';
    }
    return title;
  }

  getDeviceid(String source) {
    var deviceId;
    try {
      if (source == 'oms') {
        deviceId = widget.modelDatas!.omsId;
      } else if (source == 'ams') {
        deviceId = widget.modelDatas!.amsId;
      } else if (source == 'rms') {
        deviceId = widget.modelDatas!.rmsId;
      } else if (source == 'lora') {
        deviceId = widget.modelDatas!.gatewayName;
      } else {
        deviceId = '1';
      }
    } catch (_, ex) {
      deviceId = '1';
    }
    setState(() {
      deviceids = deviceId;
    });
    return deviceId;
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

  Future<List<ECM_Checklist_Model>> getECMProcess(String source) async {
    try {
      List<ECM_Checklist_Model> result = [];
      datas = await DBSQL.instance.fatchdataSQL1(source);
      return result;
    } on Exception catch (_, ex) {
      throw Exception("API Consumed Failed");
    }
  }

  Future<List<ECM_Checklist_Model>> getECMCheckListByProcessId(
      int _deviceId, int _processId, String _source) async {
    try {
      List<ECM_Checklist_Model> result = [];
      result = await DBSQL.instance.getdatabyId(_deviceId, _processId, _source);
      return result;
    } on Exception catch (_, ex) {
      throw Exception("API Consumed Failed");
    }
  }

  Future<List<ECM_Checklist_Model>> getOMSECMCheckListByProcessId(
      int _deviceId, int _processId) async {
    try {
      List<ECM_Checklist_Model> result = [];
      result = await DBSQL.instance.getdataby(_deviceId, _processId);
      return result;
    } on Exception catch (_, ex) {
      throw Exception("API Consumed Failed");
    }
  }
}

// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, unused_element, prefer_typing_uninitialized_variables, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_collection_literals, duplicate_ignore, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, unnecessary_null_in_if_null_operators, must_be_immutable, avoid_function_literals_in_foreach_calls, unused_local_variable, use_build_context_synchronously, curly_braces_in_flow_control_structures, unnecessary_null_comparison, unnecessary_new, unused_import, camel_case_types, library_private_types_in_public_api, unused_catch_stack
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/core/SQLite/DbHepherSQL.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/Project/ImageMasterModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:ecm_application/Model/Project/ECMTool/ECM_Checklist_Model.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Services/RestPmsService.dart';
import 'package:ecm_application/Widget/ExpandableTiles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

PMSListViewModel? modelData;
List<PMSListViewModel>? _DisplayList = <PMSListViewModel>[];

EngineerNameModel? usernameData;
List<EngineerNameModel>? _UserList = <EngineerNameModel>[];

class NodeDetails_SQL extends StatefulWidget {
  String? ProjectName;
  String? Source;
  int? listdatas;

  NodeDetails_SQL(PMSListViewModel? _modelData, String project, String source,
      this.listdatas) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }
  @override
  _NodeDetails_SQLState createState() => _NodeDetails_SQLState();
}

class _NodeDetails_SQLState extends State<NodeDetails_SQL> {
  var proccessid;
  var subprocessid;
  var deviceId;
  var deviceids;
  var userId;
  var approvedId;
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
  var lst;
  int? psId;
  bool sendData = false;
  String? userType = '';

  @override
  void initState() {
    sendData = false;
    lst = modelData!.deviceId;
    datas;
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
    getDeviceid(widget.Source!);
    getECMData(selectedProcess!);
  }

  List<PMSListViewModel> Listdata = [];
  List<PMSListViewModel> alllistItem = [];
  List<ECM_Checklist_Model> datas = [];
  Future fatchdataSQL() async {
    setState(() => isLoading = true);
    Listdata = await ListViewModel.instance.fatchdataPMSViewData();
    datas = await DBSQL.instance.fatchdataSQLAll(deviceids, processId!);
    //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
    setState(() => isLoading = false);
  }

  //List<PMSListViewModel> Listdata = [];
  List<PMSChaklistModel> listdistinctProcesss = [];
  List<ECM_Checklist_Model> datasoff = [];
  //fatch for oms
  Future fatchFirstloadoms() async {
    if (modelData!.omsId != 0) {
      setState(() => isLoading = true);
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff =
          await DBSQL.instance.fatchdataSQLAll(modelData!.omsId!, proccessid!);
      setState(() => isLoading = false);
    }
  }

//fatch for ams
  Future fatchFirstloadams() async {
    if (modelData!.amsId != 0) {
      setState(() => isLoading = true);
      datasoff = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff =
          await DBSQL.instance.fatchdataSQLAll(modelData!.amsId!, proccessid!);

      setState(() => isLoading = false);
    }
  }

//fatch for lora
  Future fatchFirstloadlora() async {
    if (modelData!.gateWayId != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff = await DBSQL.instance
          .fatchdataSQLAll(modelData!.gateWayId!, proccessid!);

      setState(() => isLoading = false);
    }
  }

//fatch for rms
  Future fatchFirstloadRms() async {
    if (modelData!.rmsId != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff =
          await DBSQL.instance.fatchdataSQLAll(modelData!.rmsId!, proccessid!);

      setState(() => isLoading = false);
    }
  }

  //offline data fatch and checking the data save or not
  Future fatchdata11() async {
    if (widget.listdatas == modelData!.omsId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11oms(widget.listdatas!);
      setState(() => isLoading = false);
    }
    if (widget.listdatas == modelData!.amsId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11Ams(widget.listdatas!);
      setState(() => isLoading = false);
    }
    if (widget.listdatas == modelData!.rmsId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11rms(widget.listdatas!);
      setState(() => isLoading = false);
    }
    if (widget.listdatas == modelData!.gateWayId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata = await ListViewModel.instance
          .fatchdataPMSView11getway(widget.listdatas!);
      setState(() => isLoading = false);
    }
  }

  List<ECM_Checklist_Model>? lsitdata;
  var subProcessname = '';
  var workedondate = '';
  var workdoneby = '';
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
      imageList[index].image = img;
      //  _copyFileToLocalPath(imageList[index].image!);
      // imageList[index].value = img.path;
      imageList[index].imageByteArray = byte;
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
          imageItem.description!,
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
                          imageList[index].image = null;
                          imageList[index].imageByteArray = null;
                          imageList[index].value = null;
                          // imageList[index].imageByteArray = imagebytearray;
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white),
              child: Text('OK'),
              onPressed: () {
                //
                if (_remarkController != null) {
                  currDate = DateTime.now();
                  Navigator.of(context).pop();
                  insertCheckListDataWithSiteTeamEngineer(_ChecklistModel!)
                      .whenComplete(() => _showToast(
                          isSubmited!
                              ? "Data Updated Successfully"
                              : "Something Went Wrong!!!",
                          MessageType: isSubmited! ? 0 : 1));

                  // }
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

  void _showApproveAlert(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Approve'),
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
                  Navigator.of(context).pop();
                  approveCheckListDataWithSiteTeamEngineer(_ChecklistModel!)
                      .whenComplete(() => _showToast(
                          isSubmited!
                              ? "Data Updated Successfully"
                              : "Something Went Wrong!!!",
                          MessageType: isSubmited! ? 0 : 1));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showCommentAlert(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText:
                      'Enter Comment*', // Placeholder text for Remark field
                ),
                onChanged: (value) {
                  _remarkController = value;
                },
                validator: (value) {
                  if (value! == '') {
                    return 'Please enter Comment'; // Validation for Remark field
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
                  Navigator.of(context).pop();
                  commentCheckListDataWithSiteTeamEngineer(_ChecklistModel!)
                      .whenComplete(() => _showToast(
                          isSubmited!
                              ? "Data Updated Successfully"
                              : "Something Went Wrong!!!",
                          MessageType: isSubmited! ? 0 : 1));
                }
              },
            ),
          ],
        );
      },
    );
  }

  firstLoad() async {
    await getECMProcess(widget.Source!).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listProcess = value;
          proccessid = value.first.processId;
          deviceId = value.first.deviceId;
          subprocessid = value.first.subProcessId;
          processName = value.first.processName;
          subprocessName = value.first.subProcessName;
        });
      }
    }).whenComplete(() {
      setState(() {
        for (var element in listProcess!) {
          listdistinctProcess!.add(element.processName!);
        }
        selectedProcess = listdistinctProcess!.first;
        imageList = [];
      });
    });
    getECMData(selectedProcess!);
    setState(() {
      Source = widget.Source;
    });
  }

  Widget? _widget;
  String? selectedProcess;
  int? processId;
  List<ECM_Checklist_Model> imageList = [];
  List<ECM_Checklist_Model>? _ChecklistModel;
  List<ECM_Checklist_Model>? listProcess;
  Set<String>? subProcessName;
  Set<String>? listdistinctProcess;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listdistinctProcess!.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(getAppbarName(widget.Source!)),
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
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        color: Colors.blue,
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
                                                element.processId ==
                                                    processId &&
                                                element.inputType == 'image' &&
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
                                            element.processId == processId &&
                                            element.inputType == 'image' &&
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
                          if (datasoff.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(datasoff.first.issaved!),
                              ),
                            ),
                          //
                          if (isSubmit())
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!datasoff.isNotEmpty)
                                    ElevatedButton(
                                      child: Text(
                                        "Submit",
                                      ),
                                      onPressed: (() async {
                                        await btnSubmit_Clicked();
                                      }),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  //Save evennt
                                  ElevatedButton(
                                    child: Text(
                                      "Save",
                                    ),
                                    onPressed: (() async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('ARE YOU SURE TO SAVE'),
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
                                                  _showAlert_off(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueGrey,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  if (datasoff.isNotEmpty)
                                    ElevatedButton(
                                      child: Text(
                                        "Upload",
                                      ),
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
                                                    if (datasoff.isNotEmpty) {
                                                      await insertCheckListDataWithSiteTeamEngineer_off(
                                                          datasoff);
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        // if (datasoff.isNotEmpty) {
                                        //   await insertCheckListDataWithSiteTeamEngineer_off(
                                        //       datasoff);
                                        // }
                                      }),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(255, 82, 226, 66)),
                                    ),
                                ],
                              ),
                            ),
                          if (isApproved())
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    child: Text(
                                      "Approve",
                                    ),
                                    onPressed: (() async {
                                      await btnApproveClicked();
                                      // _showAlert(context);
                                    }),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                  ),
                                  ElevatedButton(
                                    child: Text(
                                      "Comment",
                                    ),
                                    onPressed: (() async {
                                      await btnCommentClicked();
                                      // _showAlert(context);
                                    }),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange),
                                  ),
                                ],
                              ),
                            ),

                          //Site Engineer Name
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
                                              'On: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
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
                          if (approvedremark.isNotEmpty)
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
                                        approvedTitle(),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              approvedby.toString(),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              getshortdate(approvedon),
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
                                                approvedremark,
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
                                ))
                        ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String approvedTitle() {
    if (selectedProcess!.toLowerCase().contains('dry comm')) {
      return approvedStatus == 3 ? 'Commented' : 'Approved';
    } else {
      return approvedStatus == 4 ? 'Commented' : 'Approved';
    }
  }

  bool isApproved() {
    var flag = userType!.toLowerCase().contains('manager') ||
        userType!.toLowerCase().contains('admin');
    if (!selectedProcess!.toLowerCase().contains('dry commissioning')) {
      return approvedStatus == 2 && flag;
    } else {
      return approvedStatus == 1 && flag;
    }
  }

  bool isSubmit() {
    var flag = userType!.toLowerCase().contains('manager') ||
        userType!.toLowerCase().contains('admin');
    if (flag) {
      return false;
    } else {
      if (!selectedProcess!.toLowerCase().contains('dry comm')) {
        return (approvedStatus == 3) ? false : true;
      } else {
        return (approvedStatus == 2) ? false : true;
      }
    }
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
        deviceId = modelData!.omsId;
      } else if (source == 'ams') {
        deviceId = modelData!.amsId;
      } else if (source == 'rms') {
        deviceId = modelData!.rmsId;
      } else if (source == 'lora') {
        deviceId = modelData!.gateWayId;
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

  getECMData(String processName) async {
    _ChecklistModel = [];
    String? source;
    int? deviceId;

    imageList = [];
    subProcessName = Set();
    setState(() {
      processId = listProcess!
          .firstWhere(
            (item) => item.processName == processName,
          )
          .processId;
      psId = processId;
      source = widget.Source!;
      deviceId = getDeviceid(source!);
    });

    //fatching offline data
    await fatchFirstloadoms();
    await fatchFirstloadams();
    await fatchFirstloadlora();
    await fatchFirstloadRms();
    // await autosend();
    try {
      if (widget.Source == 'oms') {
        getOMSECMCheckListByProcessId(deviceId!, processId!).then((value) {
          for (var element in value) {
            setState(() {
              subProcessName!.add(element.subProcessName!);
              subProcessname = (element.subProcessName ?? '').toString();
              workedondate = (element.workedOn ?? '').toString();
              remarkval = (element.remark ?? '').toString();
              getWorkedByNAme((element.workedBy ?? '').toString());
              siteTeamMember = (element.siteTeamEngineer ?? '').toString();
              approvedon = (element.approvedOn ?? '').toString();
              getApprovedbyName((element.approvedBy ?? '').toString());
              approvedremark = (element.approvalRemark ?? '').toString();
              approvedStatus = element.approvedStatus;
            });
          }
          setState(() {
            _ChecklistModel = value;
            imageList.addAll(value.where((element) =>
                element.inputType == 'image' &&
                element.processId == processId));
          });
        });
      } else {
        getECMCheckListByProcessId(deviceId!, processId!, source!)
            .then((value) {
          for (var element in value) {
            setState(() {
              subProcessName!.add(element.subProcessName!);
              subProcessname = (element.subProcessName ?? '').toString();
              workedondate = (element.workedOn ?? '').toString();
              remarkval = (element.remark ?? '').toString();
              getWorkedByNAme((element.workedBy ?? '').toString());
              siteTeamMember = (element.siteTeamEngineer ?? '').toString();
              approvedon = (element.approvedOn ?? '').toString();
              getApprovedbyName((element.approvedBy ?? '').toString());
              approvedremark = (element.approvalRemark ?? '').toString();
              approvedStatus = element.approvedStatus;
            });
          }
          setState(() {
            _ChecklistModel = value;
            imageList.addAll(value.where((element) =>
                element.inputType == 'image' &&
                element.processId == processId));
          });
        });
      }
    } catch (_) {}
  }

  var getworkby;
  var getapproveby;
  bool isLoading = false;

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
                                  enabled: isEdit(),
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
                                    onChanged: isEdit()
                                        ? (value) {
                                            setState(() {
                                              item.value = value! ? 'OK' : '';
                                            });
                                          }
                                        : null,
                                  )),
                            if (item.description!
                                .toLowerCase()
                                .contains('site location :'))
                              Expanded(
                                flex: 0,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1)),
                                      width: 160,
                                      height: 25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: FittedBox(
                                            child: Text(
                                                item.value ?? ''.toString())),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      // icon: Icon(
                                      //   Icons.gps_fixed,
                                      //   color: Colors.blue,
                                      // ),
                                      child: Text('Get Location'),
                                      onPressed: isEdit()
                                          ? () async {
                                              bool serviceEnabled;
                                              LocationPermission permission;

                                              // Check if location services are enabled
                                              serviceEnabled = await Geolocator
                                                  .isLocationServiceEnabled();
                                              if (!serviceEnabled) {
                                                return;
                                              }

                                              // Request location permission
                                              permission = await Geolocator
                                                  .checkPermission();
                                              if (permission ==
                                                  LocationPermission
                                                      .deniedForever) {
                                                AlertDialog(
                                                  title:
                                                      Text('Enable Location'),
                                                  content: Text(
                                                      'Please enable location services to proceed.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('CANCEL'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('ENABLE'),
                                                      onPressed: () {
                                                        _enableLocationService();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }

                                              if (permission ==
                                                  LocationPermission.denied) {
                                                // Location permissions are denied, request permission
                                                permission = await Geolocator
                                                    .requestPermission();
                                                if (permission !=
                                                        LocationPermission
                                                            .whileInUse &&
                                                    permission !=
                                                        LocationPermission
                                                            .always) {
                                                  // Location permissions are denied (again), handle it accordingly
                                                  return;
                                                }
                                              }

                                              // Get the current position
                                              Position position =
                                                  await Geolocator
                                                      .getCurrentPosition();

                                              // Retrieve the latitude and longitude
                                              double latitude =
                                                  position.latitude;
                                              double longitude =
                                                  position.longitude;
                                              String location = ('lat: ' +
                                                  latitude.toStringAsFixed(4) +
                                                  ' long: ' +
                                                  longitude.toStringAsFixed(4));

                                              item.value = location;
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
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

  bool isEdit() {
    var flag = userType!.toLowerCase().contains('manager') ||
        userType!.toLowerCase().contains('admin');
    if (flag) {
      return false;
    } else {
      if (!selectedProcess!.toLowerCase().contains('dry comm')) {
        return (approvedStatus == 3) ? false : true;
      } else {
        return (approvedStatus == 2) ? false : true;
      }
    }
  }

  void _enableLocationService() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // Handle the scenario when the user has previously denied location permission permanently.
      // You may want to show a message or redirect them to settings.
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the scenario when the user denies location permission.
        // You may want to show a message or perform some other action.
        return;
      }
    }

    // Location permission has been granted, and the user has enabled location services.
    // You can now proceed with the location-based functionality.
    // For example, you can start listening for location updates.
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

  getApprovedbyName(String userid) async {
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
            approvedby = loginResult.firstname.toString();
          });
          print('Approved By' + loginResult.firstname.toString());
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

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, handle it accordingly
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle it accordingly
      return;
    }

    if (permission == LocationPermission.denied) {
      // Location permissions are denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permissions are denied (again), handle it accordingly
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();

    // Retrieve the latitude and longitude
    double latitude = position.latitude;
    double longitude = position.longitude;
    setState(() {});
  }

  getUserType() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userType = pref.getString('usertype');
    } catch (_, ex) {
      userType = '';
    }
  }

// get image path for uploaded
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

  Future<bool> approveCheckListDataWithSiteTeamEngineer(
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
                ((e.value == null || e.value!.isEmpty) || e.image != null) &&
                e.inputType == "image")
            .length;
        if (!selectedProcess!.toLowerCase().contains('dry comm')) {
          approveStatus = 3;
        } else {
          approveStatus = 2;
        }

        int flagCounter = 0;
        for (var subpro in subProcessName!) {
          var list = _checkList
              .where((element) =>
                  element.subProcessName!.toLowerCase() == subpro.toLowerCase())
              .toList();

          respflag = await approveCheckListDataWithSiteTeamEngineer_func(
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
          flag = true;
        } else
          throw new Exception();
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  Future<bool> commentCheckListDataWithSiteTeamEngineer(
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
                ((e.value == null || e.value!.isEmpty) || e.image != null) &&
                e.inputType == "image")
            .length;
        if (!selectedProcess!.toLowerCase().contains('dry comm')) {
          approveStatus = 4;
        } else {
          approveStatus = 3;
        }
        /*bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');
        if (checkCount !=
                _checkList.where((e) => e.inputText != "image").length ||
            imageCount != 0) {
          if (imageCount >= 3 && checkCount == 0)
            approveStatus = isPartialProcess ? 1 : 2;
          else if (!isPartialProcess) {
            approveStatus = 1;
          } else {
            if (imageCount < 3) 
            print("atleast 3 image must be uploaded");
            if (checkCount != 0)
            print("Partially done is not allow in this process");
            return false;
          }
        } else {
          return false;
        }*/

        int flagCounter = 0;
        for (var subpro in subProcessName!) {
          var list = _checkList
              .where((element) =>
                  element.subProcessName!.toLowerCase() == subpro.toLowerCase())
              .toList();

          respflag = await approveCheckListDataWithSiteTeamEngineer_func(
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
          flag = true;
        } else
          throw new Exception();
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  Future<bool> approveCheckListDataWithSiteTeamEngineer_func(
      List<ECM_Checklist_Model> imageList, int subprocessId,
      {int apporvedStatus = 0}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      String? project = preferences.getString('ProjectName');
      String? projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int? proUserId = preferences.getInt('ProUserId');

      var omsId = getDeviceid(widget.Source!);
      String submitDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currDate!);
      var source = widget.Source;
      var imagePath = "$projectName/$source/$omsId/";

      int countflag = 0;
      int uploadflag = 0;

      // Map each element in imageList to a Future returned by uploadImage,
      // then use Future.wait to wait for all the Futures to complete
      // before continuing
      await Future.wait(imageList
          .where((element) =>
              element.inputType == 'image' && element.image != null)
          .map((element) async {
        String? imagePathValue = await uploadImage(imagePath, element.image);
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
      Insertobj["OmsId"] = getDeviceid(widget.Source!);
      Insertobj["userId"] = proUserId.toString();
      Insertobj["valuedata"] = valueData;
      Insertobj["Remark"] = _remarkController;
      Insertobj["TempDT"] = currDate.toString();
      Insertobj["ApprovedStatus"] = aproveStatus;
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/PMS/UpdateECMApprovedStatus'));
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

// send to server
  Future<bool> insertCheckListDataWithSiteTeamEngineer(
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
        int imagewithvalue = imageList
            .where((e) =>
                ((e.value == null || e.value!.isEmpty) || e.image != null) &&
                e.inputType == "image")
            .length;
        bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');

        var _imglistdataWithoutNullValue = imageList
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
                  element.subProcessName!.toLowerCase() == subpro.toLowerCase())
              .toList();
          respflag = await insertCheckListDataWithSiteTeamEngineer_func(
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
          flag = true;
        } else
          throw new Exception();
      }
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

  /*Future<bool> insertCheckListDataWithSiteTeamEngineer(
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
                ((e.value == null || e.value!.isEmpty) || e.image != null) &&
                e.inputType == "image")
            .length;
        bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');
        if (checkCount !=
                _checkList.where((e) => e.inputText != "image").length ||
            imageCount != 0) {
          if (imageCount >= 3 && checkCount == 0)
            approveStatus = isPartialProcess ? 1 : 2;
          else if (!isPartialProcess) {
            approveStatus = 1;
          } else {
            if (imageCount < 3) print("atleast 3 image must be uploaded");
            if (checkCount != 0)
              print("Partially done is not allow in this process");
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

          respflag = await insertCheckListDataWithSiteTeamEngineer_func(
              list, list.first.subProcessId!,
              apporvedStatus: approveStatus);
          if (respflag) {
            flagCounter++;
          }
          //lsitdata = _ChecklistModel;
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
*/
  Future<bool> insertCheckListDataWithSiteTeamEngineer_func(
      List<ECM_Checklist_Model> imageList, int subprocessId,
      {int apporvedStatus = 0}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      project = preferences.getString('ProjectName');
      projectName = preferences.getString('ProjectName')!.replaceAll(' ', '_');
      proUserId = preferences.getInt('ProUserId');
      source = widget.Source;
      omsId = getDeviceid(widget.Source!);
      String submitDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currDate!);
      imagePath = "$projectName/$source/$omsId/";
      int countflag = 0;
      int uploadflag = 0;

      // Map each element in imageList to a Future returned by uploadImage,
      // then use Future.wait to wait for all the Futures to complete
      // before continuing
      await Future.wait(imageList
          .where((element) =>
              element.inputType == 'image' && element.image != null)
          .map((element) async {
        String? imagePathValue = await uploadImage(imagePath, element.image);
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
      Insertobj["Remark"] = _remarkController;
      Insertobj["TempDT"] = currDate.toString();
      Insertobj["ApprovedStatus"] = aproveStatus;
      Insertobj["Source"] = widget.Source;
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/PMS/InsertECMReport_New'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        print(request.body);
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
    } catch (_, ex) {
      throw new Exception();
    }
  }

  bool connectivity = false;

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
      bool allow = false;
      String mech = prefs.getString("Mechanical")!;
      String erec = prefs.getString("Erection")!;
      String dry = prefs.getString("DryComm")!;
      String autodry = prefs.getString("AutoDryComm")!;
      String _proj = prefs.getString("ProjectName")!.toLowerCase();
      String? process1;
      String? process2;
      String? process3;
      if (widget.Source! == 'lora') {
        process1 = prefs.getString("TowerInst")!;
        process2 = prefs.getString("ControlUnit")!;
        process3 = prefs.getString("Comission")!;
      }

      if (widget.Source! == 'lora') {
        // if (processId! == 14 ) {
          if (selectedProcess!.toLowerCase().contains("tower"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("erection"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("commiss") &&
              (process1 == 2.toString() || process1 == 3.toString()) &&
              (process2 == 2.toString() || processId == 3.toString()))
            allow = true;
          else
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text("Please complete the previous process"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
       /* } else {
          if (selectedProcess!.toLowerCase().contains("mechanical"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("erection"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("dry comm") &&
              (erec == 2.toString() || erec == 3.toString()))
            allow = true;
          else if (selectedProcess!
                  .toLowerCase()
                  .contains("wet commissioning") &&
              (erec == 2.toString() || erec == 3.toString()) &&
              (dry == 1.toString() || dry == 2.toString()))
            allow = true;
          else
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text("Please complete the previous process"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
        }*/
      } else {
        if (processId! == 4) {
          if (selectedProcess!.toLowerCase().contains("mechanical"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("erection"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("dry") &&
              (mech == 2.toString() || mech == 3.toString()) &&
              (erec == 2.toString() || erec == 3.toString()))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("wet") &&
              (mech == 2.toString() || mech == 3.toString()) &&
              (erec == 2.toString() || erec == 3.toString()) &&
              ((dry == 1.toString() || dry == 2.toString()) ||
                  (autodry == 1.toString() || autodry == 2.toString())))
            allow = true;
          else
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text("Please complete the previous process"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
        } else {
          if (selectedProcess!.toLowerCase().contains("mechanical"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("erection"))
            allow = true;
          else if (selectedProcess!.toLowerCase().contains("dry comm") &&
              (erec == 2.toString() || erec == 3.toString()))
            allow = true;
          else if (selectedProcess!
                  .toLowerCase()
                  .contains("wet commissioning") &&
              (erec == 2.toString() || erec == 3.toString()) &&
              (dry == 1.toString() || dry == 2.toString()))
            allow = true;
          else
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text("Please complete the previous process"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
        }
      }
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

  Future<void> btnApproveClicked() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bool isAllow = prefs.getBool("isAllowed")!;

      if (isAllow) {
        _showApproveAlert(context);
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Contact to Administrator"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (ex) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(ex.toString()),
            actions: [
              TextButton(
                child: Text("OK"),
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

  Future<void> btnCommentClicked() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bool isAllow = prefs.getBool("isAllowed")!;

      if (isAllow) {
        _showCommentAlert(context);
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Contact to Administrator"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (ex) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(ex.toString()),
            actions: [
              TextButton(
                child: Text("OK"),
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

//offline store Dialog
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
              child: Text('Cancel',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white),
              child: Text('OK',style: TextStyle(color: Colors.white),),
              onPressed: () {
                final snackBar = SnackBar(
                  content: const Text('Save Sucessfully'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (_remarkController != null) {
                  currDate = DateTime.now();
                  Navigator.of(context).pop();
                }
                //adding all required components add store it
                for (int j = 0; j <= _ChecklistModel!.length; j++) {
                  _ChecklistModel![j].remark = _remarkController;
                  _ChecklistModel![j].deviceId = deviceids;
                  _ChecklistModel![j].source = widget.Source;
                  _ChecklistModel![j].conString = conString;
                  _ChecklistModel![j].approvalRemark = approvedremark;
                  _ChecklistModel![j].image = image;
                  _ChecklistModel![j].workedBy =
                      preferences.getInt('ProUserId');
                  _ChecklistModel![j].approvedOn = approvedon;
                  _ChecklistModel![j].siteTeamEngineer = siteTeamMember;
                  _ChecklistModel![j].approvalRemark = approvedremark;
                  _ChecklistModel![j].issaved = "Save Offline Data!";
                  _ChecklistModel![j].approvedBy = approvedId;
                  _ChecklistModel![j].tempDT =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                  lsitdata = _ChecklistModel;
                }
              },
            ),
          ],
        );
      },
    );

    await fatchdata11();
    await addList();
    await fatchdataSQL();
    await addSQL();
  }

//pms Checklist data
  Future addSQL() async {
    if (datas.isEmpty) {
      for (int i = 0; i <= lsitdata!.length; i++) {
        final data = lsitdata![i];
        DBSQL.instance.insert(data.toJson());
      }
    }
    for (int i = 0; i <= lsitdata!.length; i++) {
      final data = lsitdata![i];
      DBSQL.instance.SQLUpdatedata(data);
    }
  }

// add pms list
  Future addList() async {
    if (Listdata.isEmpty) {
      modelData!.projectName = widget.ProjectName;
      modelData!.deviceType = widget.Source;
      final data = modelData!;
      ListViewModel.instance.insert(data.toJson());
    } else {
      modelData!.projectName = widget.ProjectName;
      modelData!.deviceType = widget.Source;
      final data = modelData!;
      ListViewModel.instance.NewUpdatedata(data);
    }
  }

//offline  data upload to server
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
        bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');
        if (checkCount !=
                _checkList.where((e) => e.inputText != "image").length ||
            imageCount != 0) {
          if (imageCount >= 3 && checkCount == 0)
            approveStatus = isPartialProcess ? 1 : 2;
          else if (!isPartialProcess) {
            approveStatus = 1;
          } else {
            if (imageCount < 3) print("atleast 3 image must be uploaded");
            if (checkCount != 0)
              print("Partially done is not allow in this process");
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
          final snackBar = SnackBar(
            content: const Text('Uploaded Sucessfully'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await listdatacheckup();
          await DBSQL.instance.deleteCheckListData(
              datasoff.first.deviceId!, datasoff.first.processId!);

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

//using delete check list data
  Future listdatacheckup() async {
    if (modelData!.omsId != 0) {}
    await ListViewModel.instance.deleteListDataoms(modelData!.omsId!);
    if (modelData!.amsId != 0) {
      await ListViewModel.instance.deleteListDataams(modelData!.amsId!);
    }
    if (modelData!.rmsId != 0) {
      await ListViewModel.instance.deleteListDatarms(modelData!.rmsId!);
    }
    if (modelData!.gateWayId != 0) {
      await ListViewModel.instance.deleteListDatagetway(modelData!.gateWayId!);
    }
  }

//get path by id
  Future<XFile> getPrefImage(checkListId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var imagePath1 = pref.getString("${checkListId.toString()}");
    return XFile(imagePath1!);
  }

//delete path by id
  Future<void> clearImageFromSharedPreferences(checkListId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(
        checkListId); // Replace 'imageKey' with the key you used to store the image
  }

// create path by image uploaded
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

//
  Future<bool> insertCheckListDataWithSiteTeamEngineer_Send(
      List<ECM_Checklist_Model> imageList, int subprocessId,
      {int apporvedStatus = 0}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      project = preferences.getString('ProjectName');
      projectName = preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int? proUserId = imageList.first.workedBy;
      source = widget.Source;

      omsId = getDeviceid(widget.Source!);
      String submitDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

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

      //     await Future.wait(imageList
      //     .where((element) =>
      //         element.inputType == 'image' && element.image != null)
      //     .map((element) async {
      //   String? imagePathValue = await uploadImage(imagePath, element.image);
      //   if (imagePathValue!.isNotEmpty) {
      //     element.value = imagePathValue;
      //     uploadflag++;
      //   }
      //   countflag++;
      // }));

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
      await listdatacheckup();
      DBSQL.instance.deleteCheckListData(imageList.first.deviceId!, processId!);
      await getWorkedByNAme(proUserId.toString());
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(await response.stream.bytesToString());
        if (json["Status"] == "Ok") {
          return true;
        } else
          throw new Exception();
      } else {}
      // } else {}
      throw new Exception();
    } catch (_, ex) {
      throw new Exception();
    }
  }

  // convert image base64 to image
  Future<String?> convertbaseToimg(
      String imahepath, byteArry, int index) async {
    Image _convertBase64ToImage(
      String base64Image,
    ) {
      Uint8List bytes = base64Decode(base64Image);
      return Image.memory(bytes);
    }

    return null;
  }
}

class InsertObjectModel {
  String? processId;
  String? subProcessId;
  String? checkListData;
  String? deviceId;
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

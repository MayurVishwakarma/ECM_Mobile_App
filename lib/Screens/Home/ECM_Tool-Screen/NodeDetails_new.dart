// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, unused_element, prefer_typing_uninitialized_variables, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_collection_literals, duplicate_ignore, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, unnecessary_null_in_if_null_operators, must_be_immutable, avoid_function_literals_in_foreach_calls, unused_local_variable, empty_catches, unnecessary_new, curly_braces_in_flow_control_structures, use_build_context_synchronously, file_names, library_private_types_in_public_api, unused_catch_stack, unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Screens/Home/ECM-History/Ecm-HistoryPage.dart';
import 'package:ecm_application/core/SQLite/DbHepherSQL.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:flutter/foundation.dart';
import 'package:ecm_application/Model/Project/ECMTool/ECM_Checklist_Model.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Services/RestPmsService.dart';
import 'package:ecm_application/Widget/ExpandableTiles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
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

class NodeDetails extends StatefulWidget {
  String? ProjectName;
  String? Source;
  PMSListViewModel? viewdata;
  int? listdatas;

  NodeDetails(PMSListViewModel? _modelData, String project, String source,
      this.viewdata, this.listdatas) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  @override
  _NodeDetailsState createState() => _NodeDetailsState();
}

class _NodeDetailsState extends State<NodeDetails> {
  bool _isConnected = false;
  StreamSubscription<InternetConnectionStatus>? _connectivitySubscription;
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
    getDeviceid(widget.Source!);
    getUserType();
    _initConnectivity();
    _connectivitySubscription = InternetConnectionCheckerPlus()
        .onStatusChange
        .listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    InternetConnectionStatus status = (await InternetConnectionCheckerPlus()
        .hasConnection) as InternetConnectionStatus;
    _updateConnectionStatus(status);
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    setState(() {
      _isConnected = status == InternetConnectionStatus.connected;
    });
  }

  //fatch data offline
  List<PMSChaklistModel> listdistinctProcesss = [];
  List<ECM_Checklist_Model> datasoff = [];
  Future fatchFirstloadoms() async {
    if (modelData!.omsId != 0) {
      setState(() => isLoading = true);
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff = await DBSQL.instance.fatchdataSQLAll(modelData!.omsId!, psId!);
      setState(() => isLoading = false);
    }
  }

  Future fatchFirstloadams() async {
    if (modelData!.amsId != 0) {
      setState(() => isLoading = true);
      datasoff = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff = await DBSQL.instance.fatchdataSQLAll(modelData!.amsId!, psId!);

      setState(() => isLoading = false);
    }
  }

  Future fatchFirstloadlora() async {
    if (modelData!.gateWayId != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff =
          await DBSQL.instance.fatchdataSQLAll(modelData!.gateWayId!, psId!);

      setState(() => isLoading = false);
    }
  }

  Future fatchFirstloadRms() async {
    if (modelData!.rmsId != 0) {
      setState(() => isLoading = true);
      // datas11 = await DBSQL.instance.fatchdataSQLNew();
      Listdata = await ListViewModel.instance
          .fatchdataPMSViewList(widget.ProjectName!, widget.Source!);
      listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      datasoff = await DBSQL.instance.fatchdataSQLAll(modelData!.rmsId!, psId!);

      setState(() => isLoading = false);
    }
  }

//fatch specific data
  List<PMSListViewModel>? Listdata = [];
  List<PMSListViewModel>? alllistItem = [];
  List<ECM_Checklist_Model> datas = [];
  List<ECM_Checklist_Model>? Addchecklist = [];
  bool isLoading = false;
  String? pdfString;
  Future fatchdataSQL() async {
    setState(() => isLoading = true);
    Listdata = await ListViewModel.instance.fatchdataPMSViewData();
    datas = await DBSQL.instance.fatchdataSQLAll(deviceids, processId!);
    //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
    setState(() => isLoading = false);
  }

  //send adata
  Future fatchdataSend() async {
    setState(() => isLoading = true);
    Listdata = await ListViewModel.instance.fatchdataPMSViewData();
    datas = await DBSQL.instance
        .fatchdataSQL(deviceids, processId!, Listdata!.first.deviceType);
    //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
    setState(() => isLoading = false);
  }

  String? conString;
  var Source;
  String subProcessId = "";
  var approved;
  var deviceids;
  var psId;
  var subProcessname = '';
  var workedondate = '';
  var workdoneby = '';
  var remarkval = '';
  var siteTeamMember = '';
  var approvedon = '';
  var approvedremark = '';
  var approvedby = '';
  var userType = '';
  var userName = '';
  var approvedStatus;
  DateTime? currDate;
  bool sendData = false;

  XFile? image;
  bool? isFetchingData = true;
  bool? isSubmited = false;
  bool? hasData = false;
  final ImagePicker picker = ImagePicker();
  Uint8List? imagebytearray;
  String? _remarkController;
  String? _siteEngineerTeamController = '';
  bool? issiteEngAvailable = false;

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
    storeImagesInSharedPref(img.path, imageList![index].checkListId.toString());
    setState(() {
      imageList![index].image = img;
      imageList![index].imageByteArray = byte;
      hasData = false;
    });
  }

  //we can upload image from camera or from gallery based on parameter
  Future getPdf(ECM_Checklist_Model model) async {
    var pdf = await picker.pickMedia();
    var imageselected = File(pdf!.path);
    var byte = await pdf.readAsBytes();
    await storeImagePath(pdf);
    final duplicateFilePath = await getExternalStorageDirectory();
    final fileName = basename(pdf.path);
    await pdf.saveTo('${duplicateFilePath!.path}/$fileName');
    // storeImagesInSharedPref(pdf.path, imageList![index].checkListId.toString());
    setState(() {
      hasData = false;
      model.image = pdf;
    });
  }

// Store XFile path in SharedPreferences
  Future<void> storeImagePath(XFile file) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', file.path);
    // print(prefs);
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
      itemCount: imageList!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildImageListItem(index);
      },
    );
  }

  Widget _buildImageListItem(int index) {
    final imageItem = imageList![index];
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
                          imageList![index].image = null;
                          imageList![index].imageByteArray = null;
                          imageList![index].value = null;
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

  void _showAlert(BuildContext context) {
    String? remark; // to store the value of Remark field
    String? siteTeamMembers; // to store the value of Site Team Members field

    showDialog(
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
                  remark = value;
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
              TextFormField(
                decoration: InputDecoration(
                  hintText:
                      'Enter Site Team Members', // Placeholder text for Site Team Members field
                ),
                onChanged: (value) {
                  siteTeamMembers = value;
                  _siteEngineerTeamController = value;
                  issiteEngAvailable =
                      _siteEngineerTeamController!.isNotEmpty ? true : false;
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
              onPressed: () async {
                // final snackBar = SnackBar(
                //   content: const Text('Save Sucessfully'),
                // );
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (remark != null) {
                  currDate = DateTime.now();

                  await Future.sync(() =>
                      insertCheckListDataWithSiteTeamEngineer(_ChecklistModel!)
                          .whenComplete(() => _showToast(
                              isSubmited!
                                  ? "Data Updated Successfully"
                                  : "Something Went Wrong!!!",
                              MessageType: isSubmited! ? 0 : 1)));
                  // for (int j = 0; j <= _ChecklistModel!.length; j++) {
                  //   _ChecklistModel![j].remark = _remarkController;
                  // lsitdata = _ChecklistModel;
                  // }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
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

  Future<bool> addAll(List<ECM_Checklist_Model> imageList) async {
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

      return true;
    } catch (_, ex) {
      return false;
    }
  }

  FToast? fToast;

  _showToast(String? msg, {int? MessageType}) {
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
    await getECMProcess(widget.Source!).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listProcess = value;
        });
      }
    }).whenComplete(() {
      setState(() {
        for (var element in listProcess!
            .where((e) => e.processId != 17 && e.processId != 18)) {
          listdistinctProcess!.add(element.processName!);
        }
        selectedProcess = listdistinctProcess!.first;
        imageList = [];
      });
    });
    getECMData(selectedProcess!);
  }

  Widget? _widget;
  String? selectedProcess;
  int? processId;
  List<ECM_Checklist_Model>? imageList = [];
  List<ECM_Checklist_Model>? _ChecklistModel;
  List<ECM_Checklist_Model>? listProcess;
  Set<String>? subProcessName;
  Set<String>? listdistinctProcess;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listdistinctProcess?.length ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(getAppbarName(widget.Source ?? "")),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EcmHistoryScreen(
                              nodeDetails: widget.viewdata!,
                              source: widget.Source,
                            )),
                    (Route<dynamic> route) => true,
                  );
                },
                icon: Icon(Icons.info_outline_rounded))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getECMFeed(),
                      _buildImageSelectionTile(),
                      if (datasoff.isNotEmpty) _buildOfflineSaveText(),
                      if (isSubmit()) _buildSubmitButtons(),
                      if (isApproved()) _buildApprovalButtons(),
                      if (siteTeamMember.isNotEmpty) _buildSiteTeamMemberText(),
                      if (remarkval.isNotEmpty)
                        _buildRemarkTile(
                            "Submitted", workdoneby, workedondate, remarkval),
                      if (approvedremark.isNotEmpty)
                        _buildRemarkTile(
                            "Approved", approvedby, approvedon, approvedremark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: listdistinctProcess!
            .map((e) => FittedBox(
                  child: Text(
                    e.replaceAll(' ', '\n'),
                    softWrap: true,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
        onTap: (value) async {
          setState(() {
            selectedProcess = listdistinctProcess!.elementAt(value);
            subProcessName?.clear(); // Clear existing subprocesses
            _ChecklistModel = []; // Clear existing checklist items
          });
          getECMData(selectedProcess!);
        },
        // onTap: (value) async {
        //   setState(() {
        //     selectedProcess = listdistinctProcess!.elementAt(value);
        //   });
        //   getECMData(selectedProcess!);
        // },
      ),
    );
  }

  Widget _buildImageSelectionTile() {
    final hasImage = imageList!.any((element) =>
        element.processId == processId &&
        element.inputType == 'image' &&
        element.value != null);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: imageListpopup,
            child: Image(
              image: AssetImage(hasImage
                  ? 'assets/images/imagepreview.png'
                  : 'assets/images/uploadimage.png'),
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
          ),
          SizedBox(
            child: Center(
              child: Text(hasImage ? 'Image Uploaded' : 'No Image Uploaded',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineSaveText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(datasoff.first.issaved!),
      ),
    );
  }

  Widget _buildSubmitButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!datasoff.isNotEmpty || _isConnected)
            ElevatedButton(
              child: Text("Submit"),
              onPressed: btnSubmit_Clicked,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          if (!_isConnected)
            ElevatedButton(
              child: Text("Save"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: () {
                _showSaveConfirmationDialog();
              },
            ),
          if (datasoff.isNotEmpty)
            ElevatedButton(
              child: Text("Upload"),
              onPressed: () {
                _showUploadConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
        ],
      ),
    );
  }

  Widget _buildApprovalButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: Text("Approve"),
            onPressed: btnApproveClicked,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton(
            child: Text("Comment"),
            onPressed: btnCommentClicked,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteTeamMemberText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Site Team Member: ',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            siteTeamMember,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarkTile(String title, String by, String date, String remark) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
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
                    by,
                    style: TextStyle(color: Colors.black, fontSize: 14),
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
                    getshortdate(date),
                    style: TextStyle(color: Colors.black, fontSize: 14),
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
                      remark,
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSaveConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ARE YOU SURE TO SAVE'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _showAlert_off(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUploadConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ARE YOU SURE TO UPLOAD'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                if (datasoff.isNotEmpty) {
                  await insertCheckListDataWithSiteTeamEngineer_off(datasoff);
                }
              },
            ),
          ],
        );
      },
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
    var flag = userType.toLowerCase().contains('manager') ||
        userType.toLowerCase().contains('admin');
    if (!selectedProcess!.toLowerCase().contains('dry commissioning')) {
      return approvedStatus == 2 && flag;
    } else {
      return approvedStatus == 1 && flag;
    }
  }

  bool isSubmit() {
    var flag = userType.toLowerCase().contains('manager') ||
        userType.toLowerCase().contains('admin');
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

  getFilename() {
    var title;
    try {
      if (widget.Source == 'oms') {
        title = modelData!.chakNo.toString();
      } else if (widget.Source == 'ams') {
        title = modelData!.amsNo.toString();
      } else if (widget.Source == 'rms') {
        title = modelData!.rmsNo.toString();
      } else if (widget.Source == 'lora') {
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
    subProcessName = Set();
    setState(() {
      processId = listProcess!
          .firstWhere(
            (item) => item.processName == processName,
          )
          .processId;
    });
    setState(() {
      psId = processId;
    });

    await fatchFirstloadoms();
    await fatchFirstloadRms();
    await fatchFirstloadams();
    await fatchFirstloadlora();
    try {
      getECMCheckListByProcessId(
              getDeviceid(widget.Source!), processId!, widget.Source!)
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
          // print(_ChecklistModel?.length);
          imageList =
              value.where((element) => element.inputType == 'image').toList();
          // print("Image List Lenght ${imageList?.length}");
        });
      });
    } catch (_) {}
  }

  bool isEdit() {
    var flag = userType.toLowerCase().contains('manager') ||
        userType.toLowerCase().contains('admin');
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

  Widget getECMFeed() {
    // Show loading indicator if subprocess or checklist is empty
    if (subProcessName!.isEmpty || _ChecklistModel!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter subprocesses by the selected process
    return Column(
      children: subProcessName!.map((subProcess) {
        // Filter checklist items by subprocess and exclude 'image' type
        var filteredItems = _ChecklistModel!
            .where((item) =>
                item.subProcessName == subProcess && item.inputType != 'image')
            .toList();

        // Return an empty container if no items match the filter
        if (filteredItems.isEmpty) return SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ExpandableTile(
            title: Text(
              subProcess.toUpperCase(),
              softWrap: true,
            ),
            body: Column(
              children: filteredItems
                  .map((item) => _buildChecklistItem(item))
                  .toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChecklistItem(dynamic item) {
    return Padding(
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
          const SizedBox(width: 20),
          if (item.inputType == 'text' || item.inputType == 'float')
            Expanded(
              flex: 1,
              child: TextFormField(
                enabled: isEdit(),
                initialValue: item.value,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blue),
                  ),
                  suffixText:
                      item.inputText?.isNotEmpty == true ? item.inputText : '',
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
                value: item.value == 'OK',
                onChanged: isEdit()
                    ? (value) {
                        setState(() {
                          item.value = value! ? 'OK' : '';
                        });
                      }
                    : null,
              ),
            ),
          // if (item.inputType == 'pdf')
          if (item.inputType == 'pdf')
            Expanded(
                flex: 0,
                child: IconButton(
                  icon: Image.asset(
                    "assets/images/pdf.png",
                    // height: 10,
                    cacheHeight: 25,
                  ),
                  onPressed: () async {
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
                                borderRadius: BorderRadius.circular(8)),
                            content: SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: IconButton(
                                      //if user click this button, user can upload image from gallery
                                      onPressed: () {
                                        Navigator.pop(context);
                                        getPdf(item);
                                      },
                                      icon: Column(
                                        children: [
                                          Icon(Icons.upload),
                                          Text('Upload PDF'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (item.image != null && item.value == null)
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: IconButton(
                                        //if user click this button. user can upload image from camera
                                        onPressed: () async {
                                          await OpenFilex.open(
                                              item.image?.path);
                                        },
                                        icon: Column(
                                          children: [
                                            Icon(
                                                Icons.document_scanner_rounded),
                                            Text('View PDF'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (item.value != null)
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: IconButton(
                                        //if user click this button. user can upload image from camera
                                        onPressed: () async {
                                          await GetPDFbyPath(item.value ?? '');
                                          base64ToPdf(
                                              pdfString ?? '', getFilename());
                                        },
                                        icon: Column(
                                          children: [
                                            Icon(
                                                Icons.document_scanner_rounded),
                                            Text('View PDF'),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                )),
          if (item.inputType == 'json')
            Expanded(
                flex: 0,
                child: IconButton(
                  icon: Image.asset(
                    "assets/images/pdf.png",
                    // height: 10,
                    cacheHeight: 25,
                  ),
                  onPressed: () async {
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
                                borderRadius: BorderRadius.circular(8)),
                            content: SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: IconButton(
                                      //if user click this button, user can upload image from gallery
                                      onPressed: () {
                                        Navigator.pop(context);
                                        getPdf(item);
                                      },
                                      icon: Column(
                                        children: [
                                          Icon(Icons.upload),
                                          Text('Upload JSON'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (item.image != null && item.value == null)
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: IconButton(
                                        //if user click this button. user can upload image from camera
                                        onPressed: () async {
                                          await OpenFilex.open(
                                              item.image?.path);
                                        },
                                        icon: Column(
                                          children: [
                                            Icon(
                                                Icons.document_scanner_rounded),
                                            Text('View PDF'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (item.value != null)
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: IconButton(
                                        //if user click this button. user can upload image from camera
                                        onPressed: () async {
                                          await GetPDFbyPath(item.value ?? '');
                                          base64ToPdf(
                                              pdfString ?? '', getFilename());
                                        },
                                        icon: Column(
                                          children: [
                                            Icon(
                                                Icons.document_scanner_rounded),
                                            Text('View PDF'),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ))
        ],
      ),
    );
  }

  Future<String> GetPDFbyPath(String path) async {
    String pdf64base = "";
    try {
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://wmsservices.seprojects.in/api/Image/GetImage?imgPath=${path}'));
      print(
          'http://wmsservices.seprojects.in/api/Image/GetImage?imgPath=${path}');

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        pdf64base = await response.stream.bytesToString();
        setState(() {
          pdfString = pdf64base.replaceAll('"', '');
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (_, ex) {
      throw Exception(ex);
    }
    return pdf64base.replaceAll('"', '');
  }

  base64ToPdf(String base64String, String fileName) async {
    var bytes = base64Decode(base64String);
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFilex.open("${output.path}/$fileName.pdf");
  }

  List<int> isCheckedList = List.generate(6, (_) => 0);

  getWorkedByNAme(String userid) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=&userid=$userid&conString=$conString'));

      // print(
      //     'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=&userid=$userid&conString=$conString');

      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json['Status'] == WebApiStatusOk) {
          EngineerNameModel loginResult =
              EngineerNameModel.fromJson(json['data']['Response']);
          setState(() {
            workdoneby = loginResult.firstname.toString();
          });
          // print(loginResult.firstname.toString());
          return loginResult.firstname.toString();
        }
        // else
        //   return '';
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
          'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=&userid=$userid&conString=$conString'));

      // print(
      //     'http://wmsservices.seprojects.in/api/login/GetUserDetailsByMobile?mobile=&userid=$userid&conString=$conString');

      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json['Status'] == WebApiStatusOk) {
          EngineerNameModel loginResult =
              EngineerNameModel.fromJson(json['data']['Response']);
          setState(() {
            approvedby = loginResult.firstname.toString();
            approvedId = userid;
          });

          // print(loginResult.firstname.toString());
          return loginResult.firstname.toString();
        }
        // else
        //   return '';
        // throw Exception("Login Failed");
      } else {
        return '';
      }
    } catch (err) {
      userName = '';
      return '';
    }
  }

  var approvedId;
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
      userType = pref.getString('usertype')!;
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

  Future<bool> insertCheckListDataWithSiteTeamEngineer(
      List<ECM_Checklist_Model> _checkList) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        /*        int checkCount = _checkList
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
            .toList(); */
        int approveStatus = 0;
        int checkCount = _checkList
            .where((e) =>
                (e.value == null || e.value!.isEmpty) &&
                e.inputType != "image" &&
                e.inputType != "pdf")
            .length;
        int imageCount = _checkList
            .where((e) =>
                ((e.value == null || e.value!.isEmpty) ||
                        e.imageByteArray != null) &&
                    e.inputType == "image" ||
                e.inputType == 'pdf')
            .length;
        int imagewithvalue = imageList!
            .where((e) =>
                ((e.value == null || e.value!.isEmpty) || e.image != null) &&
                e.inputType == "image")
            .length;
        bool isPartialProcess =
            selectedProcess!.toLowerCase().contains("dry") ||
                selectedProcess!.toLowerCase().contains('auto');

        var _imglistdataWithoutNullValue = imageList!
            .where((item) =>
                (item.inputType!.contains("image") ||
                    item.inputType!.contains("pdf")) &&
                item.imageByteArray != null)
            .toList();

        if (checkCount !=
                _checkList
                    .where(
                        (e) => e.inputText != "image" && e.inputType != "pdf")
                    .length ||
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

  Future<bool> insertCheckListDataWithSiteTeamEngineer_func(
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
              (element.inputType == 'image' || element.inputType == 'pdf') &&
              element.image != null)
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
      Insertobj["IsSiteTeamEngineerAvailable"] = issiteEngAvailable;
      Insertobj["SiteTeamEngineer"] = _siteEngineerTeamController;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/PMS/InsertECMReport_WithSiteTeamEngineer'));
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
        } else {
          // addData();
        }
        throw new Exception();
      } else {
        return false;
      }
    } catch (_, ex) {
      return false;
    }
  }

// offline data send to server
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
          respflag = await insertCheckListDataWithSiteTeamEngineer_send(
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
              datasoff.first.deviceId!, datasoff.first.processId!);
          await getECMData(selectedProcess!);
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
      /* if (_checkList != null) {
        int approveStatus = 0;
        int checkCount = _checkList
            .where((e) =>
                (e.image == null || e.imageByteArray!.isEmpty) &&
                e.inputType != "image")
            .length;
        int imageCount = _checkList
            .where((e) =>
                ((e.image == null || e.imageByteArray!.isEmpty) ||
                    e.image != null) &&
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
        if (checkCount !=
                _checkList.where((e) => e.inputText != "image").length ||
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
                  element.subProcessName!.toLowerCase() == subpro.toLowerCase())
              .toList();

          respflag = await insertCheckListDataWithSiteTeamEngineer_send(
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
          await getECMData(selectedProcess!);
          setState(() {
            isSubmited = true;
          });
          setState(() {
            Source = widget.Source;
          });
          flag = true;
        } else
          throw new Exception();
      }*/
    } catch (_, ex) {
      flag = false;
    }
    return flag;
  }

// off line save process start
  Future<XFile> getPrefImage(checkListId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var imagePath1 = pref.getString("${checkListId.toString()}");
    return XFile(imagePath1!);
  }

  Future<bool> insertCheckListDataWithSiteTeamEngineer_send(
      List<ECM_Checklist_Model> imageList, int subprocessId,
      {int apporvedStatus = 0}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      String? project = preferences.getString('ProjectName');
      String? projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      int? proUserId = imageList.first.workedBy;

      var omsId = getDeviceid(widget.Source!);
      String submitDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      var source = widget.Source;
      var imagePath = "$projectName/$source/$omsId/";

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
      Insertobj["IsSiteTeamEngineerAvailable"] = issiteEngAvailable;
      Insertobj["SiteTeamEngineer"] = imageList.first.siteTeamEngineer;

      // if (countflag == uploadflag) {
      var headers = {'Content-Type': 'application/json'};
      final request = http.Request(
          "POST",
          Uri.parse(
              'http://wmsservices.seprojects.in/api/PMS/InsertECMReport_WithSiteTeamEngineer'));
      request.headers.addAll(headers);
      request.body = json.encode(Insertobj);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        dynamic json = jsonDecode(await response.stream.bytesToString());
        if (json["Status"] == "Ok") {
          return true;
        } else
          throw new Exception();
      } else {
        return false;
      }
    } catch (_, ex) {
      return false;
    }
  }

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

  // bool connectivity = false;
  List<ECM_Checklist_Model>? newdata;
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
      String mech = prefs.getString("Mechanical") ?? '';
      String erec = prefs.getString("Erection") ?? '';
      String dry = prefs.getString("DryComm") ?? '';
      String autodry = prefs.getString("AutoDryComm") ?? '';
      String tower = prefs.getString("TowerInst") ?? '';
      String control = prefs.getString("ControlUnit") ?? '';
      String comms = prefs.getString("Comission") ?? '';
      String _proj = (prefs.getString("ProjectName") ?? '').toLowerCase();

      if (processId! == 4) {
        if (selectedProcess!.toLowerCase().contains("mechanical"))
          allow = true;
        else if (selectedProcess!.toLowerCase().contains("erection"))
          allow = true;
        else if (selectedProcess!.toLowerCase().contains("dry") &&
            (mech == 2.toString() || mech == 3.toString()) &&
            (erec == 2.toString() || erec == 3.toString()) &&
            !_proj.toLowerCase().contains('alirajpur'))
          allow = true;
        else if (selectedProcess!.toLowerCase().contains("wet") &&
            (mech == 2.toString() || mech == 3.toString()) &&
            (erec == 2.toString() || erec == 3.toString()) &&
            ((dry == 1.toString() || dry == 2.toString()) ||
                (autodry == 1.toString() || autodry == 2.toString())))
          allow = true;
        else if (selectedProcess!.toLowerCase().contains('tower'))
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
        else if (_proj.toLowerCase().contains('alirajpur demo') ||
            selectedProcess!.toLowerCase().contains("dry comm") &&
                (erec == 2.toString() || erec == 3.toString()))
          allow = true;
        else if (selectedProcess!.toLowerCase().contains("wet commissioning") &&
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

//off data save func
  void _showAlert_off(BuildContext context) async {
    // String? remark; // to store the value of Remark field
    // String? siteTeamMembers; // to store the value of Site Team Members field
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
                // validator: (value) {
                //   if (value == '') {
                //     return 'Please enter Remark'; // Validation for Remark field
                //   }
                //   return null;
                // },
              ),

              SizedBox(height: 16.0),
              // if (conString!.contains('ID=dba'))
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
                  content: const Text('Save Sucessfully'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (_remarkController != null) {
                  Navigator.of(context).pop();
                }
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
                  Addchecklist = _ChecklistModel;
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
    await addNew();
  }

  Future fatchdata11() async {
    if (widget.listdatas == modelData!.omsId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11oms(widget.listdatas!);
      // datas = await DBSQL.instance.fatchdataSQL(deviceids, processId!);
      //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      setState(() => isLoading = false);
    }
    if (widget.listdatas == modelData!.amsId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11Ams(widget.listdatas!);
      // datas = await DBSQL.instance.fatchdataSQL(deviceids, processId!);
      //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      setState(() => isLoading = false);
    }
    if (widget.listdatas == modelData!.rmsId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata =
          await ListViewModel.instance.fatchdataPMSView11rms(widget.listdatas!);
      // datas = await DBSQL.instance.fatchdataSQL(deviceids, processId!);
      //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      setState(() => isLoading = false);
    }
    if (widget.listdatas == modelData!.gateWayId) {
      setState(() => isLoading = true);
      alllistItem = await ListViewModel.instance.fatchdataPMSViewData();
      Listdata = await ListViewModel.instance
          .fatchdataPMSView11getway(widget.listdatas!);
      // datas = await DBSQL.instance.fatchdataSQL(deviceids, processId!);
      //  listdistinctProcesss = await ListModel.instance.fatchdataPMSListData();
      setState(() => isLoading = false);
    }
  }

  Future addNew() async {
    if (datas.isEmpty) {
      for (int i = 0; i <= Addchecklist!.length; i++) {
        final data = Addchecklist![i];
        DBSQL.instance.insert(data.toJson());
      }
    }
    for (int i = 0; i <= Addchecklist!.length; i++) {
      final data = Addchecklist![i];
      DBSQL.instance.SQLUpdatedata(data);
    }
  }

  Future addList() async {
    if (Listdata!.isEmpty) {
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

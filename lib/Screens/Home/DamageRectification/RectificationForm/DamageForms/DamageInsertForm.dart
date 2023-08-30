// ignore_for_file: non_constant_identifier_names, must_be_immutable, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, file_names, unnecessary_null_comparison, unused_local_variable, unused_catch_stack, prefer_collection_literals

import 'dart:convert';
import 'package:ecm_application/Model/Project/Damage/DamageCommanModel.dart';
import 'package:ecm_application/Model/Project/Damage/Information.dart';
import 'package:ecm_application/Model/Project/Damage/IssuesMasterModel.dart';
import 'package:ecm_application/Model/Project/Damage/MaterialConsumption.dart';
import 'package:ecm_application/Model/Project/Damage/OmsDamageModel.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:ecm_application/Model/Common/EngineerModel.dart';
import 'package:ecm_application/Model/project/Constants.dart';
import 'package:flutter/foundation.dart';
import 'package:ecm_application/Widget/ExpandableTiles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

DamageModel? modelData;
List<DamageInsertModel>? _DisplayList = <DamageInsertModel>[];

EngineerNameModel? usernameData;
List<EngineerNameModel>? _UserList = <EngineerNameModel>[];

class DamageInsert extends StatefulWidget {
  String? ProjectName;
  String? Source;

  // ignore: use_key_in_widget_constructors
  DamageInsert(DamageModel? _modelData, String project, String source) {
    modelData = _modelData;
    ProjectName = project;
    Source = source;
  }
  @override
  _DamageInsertState createState() => _DamageInsertState();
}

class _DamageInsertState extends State<DamageInsert> {
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    super.initState();
    setState(() {
      processList = Set();
      selectedProcess = 'Damage Form';
      _widget = const Center(child: CircularProgressIndicator());
    });
    getECMData(selectedProcess!);
  }

  var subProcessname = '';
  var workedondate = '';
  var workdoneby = '';
  var remarkval = '';
  var userName = '';
  XFile? image;
  bool? isFetchingData = true;
  bool? isSubmited = false;
  final ImagePicker picker = ImagePicker();
  Uint8List? imagebytearray;
  String? _remarkController;
  String? _siteEngineerTeamController;
  Widget? _widget;
  var selectedProcess;
  List<DamageInsertModel> imageList = [];
  List<DamageInsertModel>? _ChecklistModel;
  List<MaterialConsumptionModel>? _MaterialCheckListModel;
  List<InfoModel>? _InfoCheckListModel;
  List<InfoModel>? InfoImageList;
  List<DamageIssuesMasterModel>? _IssueCheckListModel;
  List<DamageIssuesMasterModel>? IssuesImageList = [];
  var listdistinctProcess = [
    "Damage Form",
    "Material Consumption",
    "Info",
    "Issues"
  ];

  Future getImage(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var byte = await img!.readAsBytes();
    setState(() {
      image = img;
      imageList[index].image = img;
      imageList[index].imageByteArray = byte;
    });
  }

  Future getImage1(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var byte = await img!.readAsBytes();
    setState(() {
      image = img;
      InfoImageList![index].image = img;
      InfoImageList![index].imageByteArray = byte;
    });
  }

  Future getImage2(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var byte = await img!.readAsBytes();
    setState(() {
      image = img;
      IssuesImageList![index].image = img;
      IssuesImageList![index].imageByteArray = byte;
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

  Widget _buildInfoImageList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: InfoImageList!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildImageListItem1(index);
      },
    );
  }

  Widget _buildIssueImageList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: IssuesImageList!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildImageListItem2(index);
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

  Widget _buildImageListItem1(int index) {
    final imageItem = InfoImageList![index];
    return ListTile(
      trailing: imageItem.imageByteArray != null
          ? InkWell(
              onTap: () => previewAlert1(
                  imageItem.imageByteArray!, index, imageItem.infoDescription),
              child: Image.memory(
                imageItem.imageByteArray!,
                fit: BoxFit.fitWidth,
                width: 50,
                height: 50,
              ),
            )
          : GestureDetector(
              onTap: () {
                uploadAlert1(index);
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
          imageItem.infoDescription!,
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildImageListItem2(int index) {
    final imageItem = IssuesImageList![index];
    return ListTile(
      trailing: imageItem.imageByteArray != null
          ? InkWell(
              onTap: () => previewAlert1(
                  imageItem.imageByteArray!, index, imageItem.infoDescription),
              child: Image.memory(
                imageItem.imageByteArray!,
                fit: BoxFit.fitWidth,
                width: 50,
                height: 50,
              ),
            )
          : GestureDetector(
              onTap: () {
                uploadAlert2(index);
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
          imageItem.infoDescription!,
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

  Future<void> imageListpopup1() async {
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
          content: Container(width: 500, child: _buildInfoImageList(context)),
        );
      },
    );
  }

  Future<void> imageListpopup2() async {
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
          content: Container(width: 500, child: _buildIssueImageList(context)),
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
                              builder: (context) =>
                                  PreviewImageWidget(photos))),
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
                        children: [
                          Icon(Icons.delete),
                          Text('Delete'),
                        ],
                      ),
                    ),
                    ElevatedButton(
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

  void previewAlert1(var photos, int index, var desc) {
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
                              builder: (context) =>
                                  PreviewImageWidget(photos))),
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
                          InfoImageList![index].imageByteArray = imagebytearray;
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
                        getImage1(ImageSource.gallery, index);
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
                        getImage1(ImageSource.camera, index);
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

  void previewAlert2(var photos, int index, var desc) {
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
                              builder: (context) =>
                                  PreviewImageWidget(photos))),
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
                          IssuesImageList![index].imageByteArray =
                              imagebytearray;
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
                        getImage1(ImageSource.gallery, index);
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
                        getImage1(ImageSource.camera, index);
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

  void uploadAlert1(int index) {
    if (isEdit!) {
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
                        getImage1(ImageSource.gallery, index);
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
                        getImage1(ImageSource.camera, index);
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
  }

  void uploadAlert2(int index) {
    if (isEdit!) {
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
                        getImage2(ImageSource.gallery, index);
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
                        getImage2(ImageSource.camera, index);
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
  }

  void uploadAlert(int index) {
    if (isEdit!) {
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
                if (_remarkController != null) {
                  Navigator.of(context).pop();
                  if (_ChecklistModel!.isNotEmpty) {
                    damageCheckListData(_ChecklistModel!).then((value) =>
                        _showToast(
                            isSubmited!
                                ? "Data Updated Successfully"
                                : "Something Went Wrong!!!",
                            MessageType: isSubmited! ? 0 : 1));
                  } else if (_MaterialCheckListModel!.isNotEmpty) {
                    damageCheckListDataForMaterial(
                            _MaterialCheckListModel!, _remarkController ?? "")
                        .then((value) => _showToast(
                            isSubmited!
                                ? "Data Updated Successfully"
                                : "Something Went Wrong!!!",
                            MessageType: isSubmited! ? 0 : 1));
                  } else if (_InfoCheckListModel!.isNotEmpty) {
                    damageCheckListDataForInfotmtion(
                            _InfoCheckListModel!, _remarkController ?? "")
                        .then((value) => _showToast(
                            isSubmited!
                                ? "Data Updated Successfully"
                                : "Something Went Wrong!!!",
                            MessageType: isSubmited! ? 0 : 1));
                  } else if (_IssueCheckListModel!.isNotEmpty) {
                    damageCheckListDataForIssues(
                            _IssueCheckListModel!, _remarkController ?? "")
                        .then((value) => _showToast(
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
                Container(
                  height: 45,
                  width: double.infinity,
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
                // if (selectedProcess == "Damage Form" ||
                //     selectedProcess == "Material Consumption" ||
                //     selectedProcess == "Info" ||
                //     selectedProcess == "Issues")
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Expandable Tile
                          getDamageFeed(),
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
                                              // element.id == Id &&
                                              element.type == 'Image' &&
                                              element.value != null)
                                          .isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                              child: Center(
                                                  child:
                                                      Text('Image Uploaded'))))
                                      : Center(
                                          child: Text(
                                            "No Image Uploaded",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          if (InfoImageList!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InfoImageList!
                                              .where((element) =>
                                                  element.type == 'image' &&
                                                  element.value != null)
                                              .isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                imageListpopup1();
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
                                                imageListpopup1();
                                              },
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/uploadimage.png'),
                                                fit: BoxFit.cover,
                                                height: 80,
                                                width: 80,
                                              ))),
                                  InfoImageList!
                                          .where((element) =>
                                              // element.id == Id &&
                                              element.type == 'image' &&
                                              element.value != null)
                                          .isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                              child: Center(
                                                  child:
                                                      Text('Image Uploaded'))))
                                      : Center(
                                          child: Text(
                                            "No Image Uploaded",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          if (IssuesImageList!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IssuesImageList!
                                              .where((element) =>
                                                  element.type == 'image' &&
                                                  element.value != null)
                                              .isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                imageListpopup2();
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
                                                imageListpopup2();
                                              },
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/uploadimage.png'),
                                                fit: BoxFit.cover,
                                                height: 80,
                                                width: 80,
                                              ))),
                                  IssuesImageList!
                                          .where((element) =>
                                              // element.id == Id &&
                                              element.type == 'image' &&
                                              element.value != null)
                                          .isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                              child: Center(
                                                  child:
                                                      Text('Image Uploaded'))))
                                      : Center(
                                          child: Text(
                                            "No Image Uploaded",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                ],
                              ),
                            ),

                          // if (isEdit == false)
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
                                              getshortdate(workedondate) ?? "",
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

  getECMData(String processname) {
    if (processname == "Issues") {
      _IssueCheckListModel = [];
      _ChecklistModel = [];
      _InfoCheckListModel = [];
      _MaterialCheckListModel = [];
      remarkval = '';
      IssuesImageList = [];
      InfoImageList = [];
      imageList = [];
      processList = Set();
      selectedProcess = Set();
      try {
        if (widget.Source == 'oms') {
          Issues(modelData!.omsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _IssueCheckListModel = value;
              for (var element in _IssueCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              IssuesImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              selectedProcess = "Issue";
            });
          });
        } else if (widget.Source == 'ams') {
          Issues(modelData!.amsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _IssueCheckListModel = value;
              for (var element in _IssueCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              IssuesImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              selectedProcess = "Issues";
            });
          });
        } else if (widget.Source == 'rms') {
          Issues(modelData!.rmsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _IssueCheckListModel = value;
              for (var element in _IssueCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              IssuesImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              selectedProcess = "Issues";
            });
          });
        }
        getECMData(selectedProcess);
      } catch (_, ex) {
        print(ex);
      }
    } else if (processname == "Info") {
      _InfoCheckListModel = [];
      _MaterialCheckListModel = [];
      _IssueCheckListModel = [];
      InfoImageList = [];
      IssuesImageList = [];
      imageList = [];
      processList = Set();
      selectedProcess = Set();
      try {
        if (widget.Source == 'oms') {
          Infomation(modelData!.omsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _InfoCheckListModel = value;
              InfoImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              for (var element in _InfoCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              selectedProcess = "Info";
            });
          });
        } else if (widget.Source == 'ams') {
          Infomation(modelData!.amsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _InfoCheckListModel = value;
              for (var element in _InfoCheckListModel!) {
                processList!.add(element.infoTypeName!);
                InfoImageList!
                    .addAll(value.where((element) => element.type == 'image'));
              }
              selectedProcess = "Info";
            });
          });
        } else if (widget.Source == 'rms') {
          Infomation(modelData!.rmsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _InfoCheckListModel = value;
              for (var element in _InfoCheckListModel!) {
                processList!.add(element.infoTypeName!);
                InfoImageList!
                    .addAll(value.where((element) => element.type == 'image'));
              }
              selectedProcess = "Info";
            });
          });
        }
        getECMData(selectedProcess!);
      } catch (_) {} /*_InfoCheckListModel = [];
      remarkval = '';
      InfoImageList = [];
      processList = Set();
      selectedProcess = Set();
      try {
        if (widget.Source == 'oms') {
          Infomation(modelData!.omsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _InfoCheckListModel = value;
              for (var element in _InfoCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              InfoImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              selectedProcess = "Info";
            });
          });
        } else if (widget.Source == 'ams') {
          Infomation(modelData!.amsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _InfoCheckListModel = value;
              for (var element in _InfoCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              InfoImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              selectedProcess = "Info";
            });
          });
        } else if (widget.Source == 'rms') {
          Infomation(modelData!.rmsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _InfoCheckListModel = value;
              for (var element in _InfoCheckListModel!) {
                processList!.add(element.infoTypeName!);
              }
              InfoImageList!
                  .addAll(value.where((element) => element.type == 'image'));
              selectedProcess = "Info";
            });
          });
        }
        getECMData(selectedProcess!);
      } catch (_) {}*/
    } else if (processname == "Material Consumption") {
      _MaterialCheckListModel = [];
      _ChecklistModel = [];
      _InfoCheckListModel = [];
      _IssueCheckListModel = [];
      IssuesImageList = [];
      imageList = [];
      InfoImageList = [];
      remarkval = '';
      processList = Set();
      selectedProcess = Set();
      try {
        if (widget.Source == 'oms') {
          getDamageformCommon(modelData!.omsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _MaterialCheckListModel = value;
              for (var element in _MaterialCheckListModel!) {
                processList!.add(element.type!);
              }
            });
            selectedProcess = "Material Consumption";
          });
        } else if (widget.Source == 'ams') {
          getDamageformCommon(modelData!.amsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _MaterialCheckListModel = value;
              for (var element in _MaterialCheckListModel!) {
                processList!.add(element.type!);
              }
            });
            selectedProcess = "Material Consumption";
          });
        } else if (widget.Source == 'rms') {
          getDamageformCommon(modelData!.rmsId!, widget.Source!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.reportedOn ?? '').toString();
              getWorkedByNAme((value.first.reportedBy ?? '').toString());
              _MaterialCheckListModel = value;
              for (var element in _MaterialCheckListModel!) {
                processList!.add(element.type!);
              }
            });
            selectedProcess = "Material Consumption";
          });
        }
        getECMData(selectedProcess!);
      } catch (_) {}
    } else {
      _ChecklistModel = [];
      _InfoCheckListModel = [];
      _MaterialCheckListModel = [];
      _IssueCheckListModel = [];
      imageList = [];
      InfoImageList = [];
      IssuesImageList = [];
      remarkval = '';
      selectedProcess = Set();
      try {
        if (widget.Source == 'oms') {
          getDamageformOms(modelData!.omsId!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? '';
              workedondate = (value.first.datetime ?? '').toString();
              getWorkedByNAme((value.first.userId ?? '').toString());
              _ChecklistModel = value;
              imageList.addAll(value.where((element) =>
                  element.type == 'Image' &&
                  element.omsId == modelData!.omsId));
              for (var element in _ChecklistModel!) {
                processList!.add(element.type!);
              }
            });
            selectedProcess = "Damage Form";
          });
        } else if (widget.Source == 'ams') {
          getDamageformAms(modelData!.amsId!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? "";
              workedondate = (value.first.datetime ?? '').toString();
              getWorkedByNAme((value.first.userId ?? '').toString());
              _ChecklistModel = value;
              imageList.addAll(value.where((element) =>
                  element.type == 'Image' &&
                  element.amsId == modelData!.amsId));
              for (var element in _ChecklistModel!) {
                processList!.add(element.type!);
              }
              selectedProcess = "Damage Form";
            });
          });
        } else if (widget.Source == 'rms') {
          getDamageformRms(modelData!.rmsId!).then((value) {
            setState(() {
              remarkval = value.first.remark ?? "";
              workedondate = (value.first.datetime ?? '').toString();
              getWorkedByNAme((value.first.userId ?? '').toString());
              _ChecklistModel = value;
              imageList.addAll(value.where((element) =>
                  element.type == 'Image' &&
                  element.rmsId == modelData!.rmsId));
              for (var element in _ChecklistModel!) {
                processList!.add(element.type!);
              }
            });
            selectedProcess = "Damage Form";
          });
        } else if (widget.Source == 'lora') {
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
        }
        getECMData(selectedProcess!);
      } catch (_) {}
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
    } catch (_) {
      title = '';
    }
    return title;
  }

  Set<String>? processList;

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
        } else {
          return '';
        }
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

  var getworkby;
  var getapproveby;
  bool isLoading = false;
  bool? isEdit = false;
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
                                    onChanged: isEdit!
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
    } else if (processList!.isNotEmpty && _MaterialCheckListModel!.isNotEmpty) {
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
                      for (var item in _MaterialCheckListModel!
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
                                    enabled: isEdit!,
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
                                    onChanged: (value) {
                                      setState(() {
                                        item.value = value;
                                        value = item.value = value;
                                      });
                                    }),
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
    } else if (processList!.isNotEmpty && _InfoCheckListModel!.isNotEmpty) {
      widget = Column(
        children: [
          for (var subProcess in processList!)
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
                      Text("Is Available",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          )),
                    ],
                  ),
                  body: Column(children: [
                    for (var item in _InfoCheckListModel!.where((e) =>
                        e.infoTypeName.toString() == subProcess &&
                        e.type != 'image'))
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 15,
                              child: Text(item.infoDescription!,
                                  textAlign: TextAlign.left, softWrap: true),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (item.infoDescription == 'text')
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                    initialValue: item.value,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue), //<-- SEE HERE
                                      ),
                                      suffixText:
                                          (item.infoDescription != null &&
                                                  item.value!.isNotEmpty)
                                              ? item.value!
                                              : '',
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        item.value = value;
                                        value = item.value = value;
                                      });
                                    }),
                              ),
                            Expanded(
                              flex: 2,
                              child: Text(""),
                            ),
                            Expanded(
                                flex: 0,
                                child: Checkbox(
                                  activeColor: Colors.white54,
                                  checkColor: Color.fromARGB(255, 251, 3, 3),
                                  value: item.value == '1' ? true : false,
                                  onChanged: isEdit!
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
    } else if (processList!.isNotEmpty && _IssueCheckListModel!.isNotEmpty) {
      widget = Column(
        children: [
          for (var subProcess in processList!)
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
                      Text("Y/N",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          )),
                    ],
                  ),
                  body: Column(children: [
                    for (var item in _IssueCheckListModel!.where((e) =>
                        e.infoTypeName.toString() == subProcess &&
                        e.type != 'image'))
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 15,
                              child: Text(item.infoDescription!,
                                  textAlign: TextAlign.left, softWrap: true),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 0,
                                child: Checkbox(
                                  activeColor: Colors.white54,
                                  checkColor: Color.fromARGB(255, 251, 3, 3),
                                  value: item.value == '1' ? true : false,
                                  onChanged: isEdit!
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
    } else {
      widget = const Center(child: CircularProgressIndicator());
    }
    return widget;
  }
  // insertInformation

  Future<bool> damageCheckListDataForIssues(
      List<DamageIssuesMasterModel> _checkList, String _Controller) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int flagCounter = 0;
        if (widget.Source == 'oms') {
          respflag = await insertIssues(
              _checkList, _Controller, modelData!.omsId!, widget.Source!);
        } else if (widget.Source == 'ams') {
          respflag = await insertIssues(
              _checkList, _Controller, modelData!.amsId!, widget.Source!);
        } else if (widget.Source == 'rms') {
          respflag = await insertIssues(
              _checkList, _Controller, modelData!.rmsId!, widget.Source!);
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

  Future<bool> damageCheckListDataForInfotmtion(
      List<InfoModel> _checkList, String _Controller) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int flagCounter = 0;
        if (widget.Source == 'oms') {
          respflag = await insertInformation(
              _checkList, _Controller, modelData!.omsId!, widget.Source!);
        } else if (widget.Source == 'ams') {
          respflag = await insertInformation(
              _checkList, _Controller, modelData!.amsId!, widget.Source!);
        } else if (widget.Source == 'rms') {
          respflag = await insertInformation(
              _checkList, _Controller, modelData!.rmsId!, widget.Source!);
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

  Future<bool> damageCheckListDataForMaterial(
      List<MaterialConsumptionModel> _checkList, String _Controller) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int flagCounter = 0;
        if (widget.Source == 'oms') {
          respflag = await insertRectifyCommon(
              _checkList, _Controller, modelData!.omsId!, widget.Source!);
        } else if (widget.Source == 'ams') {
          respflag = await insertRectifyCommon(
              _checkList, _Controller, modelData!.amsId!, widget.Source!);
        } else if (widget.Source == 'rms') {
          respflag = await insertRectifyCommon(
              _checkList, _Controller, modelData!.rmsId!, widget.Source!);
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

  Future<bool> damageCheckListData(List<DamageInsertModel> _checkList) async {
    bool flag = false;
    var respflag;
    try {
      if (_checkList != null) {
        int flagCounter = 0;
        if (widget.Source == 'oms') {
          respflag = await insertDamageReportCommon(
              _checkList, modelData!.omsId!, widget.Source!);
        } else if (widget.Source == 'ams') {
          respflag = await insertDamageReportCommon(
              _checkList, modelData!.amsId!, widget.Source!);
        } else if (widget.Source == 'rms') {
          respflag = await insertDamageReportCommon(
              _checkList, modelData!.rmsId!, widget.Source!);
        }
        // else if (widget.Source == 'lora') {
        //   respflag = await insertLoraDamageReport(_checkList, modelData!.omsId!, widget.Source!);
        // }

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

//image uploaded by damage
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

//Damage form insert
  Future<bool> insertDamageReportCommon(
      List<DamageInsertModel> imageList, int Id, String source) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      var projectName =
          preferences.getString('ProjectName')!.replaceAll(' ', '_');
      var proUserId = preferences.getInt('ProUserId');
      int omsId = modelData!.omsId!;
      var imagePath = "$projectName/$source/$Id/";
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
      var Insertobj = Map<String, dynamic>();
      Insertobj["omsid"] = Id;
      Insertobj["userid"] = proUserId.toString();
      Insertobj["Damagedata"] = checkListId;
      Insertobj["Valuedata"] = valueData;
      Insertobj["conString"] = conString;
      Insertobj["status"] = "ok";
      Insertobj["remark"] = _remarkController!;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/OMS/InsertOmsDamageReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            return true;
          } else {
            throw Exception();
          }
        } else {}
      } else {}
      throw Exception();
    } catch (_) {
      throw Exception();
    }
  }

//Rectification insertion
  Future<bool> insertRectifyCommon(List<MaterialConsumptionModel> checklist,
      String Remark, int Id, String source) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      int proUserId = preferences.getInt('ProUserId')!;
      int countflag = 0;
      int uploadflag = 0;

      var checkListId = checklist.map((e) => e.id).toList().join(",");
      var valueData = checklist.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      Insertobj["id"] = Id;
      Insertobj["rectifydata"] = checkListId;
      Insertobj["valuedata"] = valueData;
      Insertobj["reportedby"] = proUserId.toString();
      Insertobj["remark"] = Remark;
      Insertobj["source"] = source;
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
          } else {
            throw new Exception();
          }
        } else {}
      } else {}
      throw new Exception();
    } catch (_) {
      throw new Exception();
    }
  }

//information Insert
  Future<bool> insertInformation(
      List<InfoModel> checklist, String Remark, int Id, String source) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      int proUserId = preferences.getInt('ProUserId')!;
      String? projectName = preferences.getString('ProjectName')!;
      var imagePath = "$projectName/$source/$Id/";
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(checklist
          .where((element) => element.type == 'image' && element.image != null)
          .map((element) async {
        String? imagePathValue = await uploadimages(imagePath, element.image);
        if (imagePathValue.isNotEmpty) {
          element.value = imagePathValue;
          uploadflag++;
        }
        countflag++;
      }));

      var checkListId = checklist.map((e) => e.id).toList().join(",");
      var valueData = checklist.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      // api/Information?imgDirPath={imgDirPath}&Api={Api}

      Insertobj["DeviceId"] = Id;
      Insertobj["infodata"] = checkListId;
      Insertobj["Valuedata"] = valueData;
      Insertobj["ReportedBy"] = proUserId;
      Insertobj["Source"] = source;
      Insertobj["Remark"] = Remark;
      Insertobj["InfoTypeId"] = 1;
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/infoReport/InsertInfoReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            return true;
          } else {
            throw new Exception();
          }
        } else {}
      } else {}
      throw new Exception();
    } catch (_) {
      throw new Exception();
    }
  }

  Future<bool> insertIssues(List<DamageIssuesMasterModel> checklist,
      String Remark, int Id, String source) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? conString = preferences.getString('ConString');
      int proUserId = preferences.getInt('ProUserId')!;
      String? projectName = preferences.getString('ProjectName')!;
      var imagePath = "$projectName/$source/$Id/";
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(checklist
          .where((element) => element.type == 'image' && element.image != null)
          .map((element) async {
        String? imagePathValue = await uploadimages(imagePath, element.image);
        if (imagePathValue.isNotEmpty) {
          element.value = imagePathValue;
          uploadflag++;
        }
        countflag++;
      }));

      var checkListId = checklist.map((e) => e.id).toList().join(",");
      var valueData = checklist.map((e) => e.value ?? '').toList().join(",");

      var Insertobj = new Map<String, dynamic>();

      // api/Information?imgDirPath={imgDirPath}&Api={Api}

      Insertobj["DeviceId"] = Id;
      Insertobj["infodata"] = checkListId;
      Insertobj["Valuedata"] = valueData;
      Insertobj["ReportedBy"] = proUserId;
      Insertobj["Source"] = source;
      Insertobj["Remark"] = Remark;
      Insertobj["InfoTypeId"] = 2;
      Insertobj["conString"] = conString;

      if (countflag == uploadflag) {
        var headers = {'Content-Type': 'application/json'};
        final request = http.Request(
            "POST",
            Uri.parse(
                'http://wmsservices.seprojects.in/api/infoReport/InsertInfoReport'));
        request.headers.addAll(headers);
        request.body = json.encode(Insertobj);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          dynamic json = jsonDecode(await response.stream.bytesToString());
          if (json["Status"] == "Ok") {
            return true;
          } else {
            throw new Exception();
          }
        } else {}
      } else {}
      throw new Exception();
    } catch (_) {
      throw new Exception();
    }
  }

//image uploaded by information
  Future<String> uploadimages(String imagePath, XFile? image) async {
    try {
      var uri = Uri.parse(
          'http://wmsservices.seprojects.in/api/Information?imgDirPath=$imagePath&Api=2');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', image!.path))
        ..fields['fieldKey'] =
            'fieldValue'; // Add any additional fields if needed

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['data'] as String;
      } else {
        return "";
      }
    } catch (error) {
      return "";
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
      body: PhotoView(imageProvider: MemoryImage(bytearray!)),
    );
  }
}

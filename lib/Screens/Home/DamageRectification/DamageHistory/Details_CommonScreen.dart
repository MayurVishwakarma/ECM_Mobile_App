// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, camel_case_types, avoid_print, unused_catch_stack, use_build_context_synchronously

import 'dart:convert';

import 'package:ecm_application/Model/Project/Damage/DamageCommanModel.dart';
import 'package:ecm_application/Model/Project/Damage/DamageHistory.dart';
import 'package:ecm_application/Model/Project/Damage/DamageReportDetails._Model.dart';
import 'package:ecm_application/Services/RestDamage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ECM_Tool-Screen/NodeDetails_new.dart';

DamageHistory? modelData;
List<DamageInsertModel>? _DisplayList = <DamageInsertModel>[];
List<DamageInsertModel>? imageList = <DamageInsertModel>[];
List<DamageInsertModel>? Electrical = <DamageInsertModel>[];
List<DamageInsertModel>? Mechanical = <DamageInsertModel>[];
List<DamageDetailsCommon>? ChakNo = <DamageDetailsCommon>[];

class History_DetailsScreen extends StatelessWidget {
  String? ProjectName;
  String? Source;
  // @override
  History_DetailsScreen(
      DamageHistory? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }
  // void initState() {
  //   super.initState();
  //   getImagePathlist();
  // }

  List<String> imagePathList = [];
  List<String> imagebytearrayList = [];
  String? electrical;
  String? machanical;

  getImagePathlist() async {
    try {
      imagePathList = modelData!.imagePath;
      electrical = modelData!.electDamageList;
      machanical = modelData!.mechDamageList;
      for (int i = 0; i < imagePathList.length; i++) {
        final temp = await GetImagebyPath(imagePathList[i]);
        if ((temp ?? "").isNotEmpty) {
          imagebytearrayList.add(temp!);
        }
      }
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
                            child: Text("Electrical Damage",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              electrical!.replaceAll(",", "\n"),
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
                            child: Text("Mechanical Damage",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              machanical!.replaceAll(",", "\n"),
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (imagePathList.isNotEmpty)
                Center(
                  child: InkWell(
                    onTap: () {
                      imageListpopup(context);
                    },
                    child: Image(
                      image: AssetImage('assets/images/imagepreview.png'),
                      fit: BoxFit.cover,
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
              /*Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: imagebytearrayList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewImageWidget(
                                  base64Decode(imagebytearrayList[index]),
                                ),
                              ),
                            );
                          },
                          child: Image.memory(
                            base64Decode(imagebytearrayList[index]),
                            width: 80,
                            height: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ),*/

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
                            DateFormat("dd MMM, yyyy")
                                .format(modelData!.dateTime!),
                            // getshortdate(workedondate) ?? "",
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
                              modelData!.remark.toString(),
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

  Widget _buildImageList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: imagePathList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildImageListItem(index, context);
      },
    );
  }

  Widget _buildImageListItem(int index, BuildContext context) {
    final imageItem = imagebytearrayList[index];
    return ListTile(
        leading: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewImageWidget(
              base64Decode(imageItem),
            ),
          ),
        );
      },
      child: Image.memory(
        base64Decode(imageItem),
        width: 80,
        height: 100,
      ),
    ));
  }

  Future<void> imageListpopup(BuildContext context) async {
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
}

// class PreviewImageWidget extends StatelessWidget {
//   Uint8List? bytearray;
//   PreviewImageWidget(this.bytearray) {
//     super.key;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Preview Image')),
//       body: PhotoView(imageProvider: MemoryImage(bytearray!)),
//     );
//   }
// }

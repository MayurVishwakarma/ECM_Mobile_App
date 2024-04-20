// ignore_for_file: unnecessary_import, must_be_immutable, non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unnecessary_null_in_if_null_operators, no_leading_underscores_for_local_identifiers, unused_field, sort_child_properties_last, prefer_const_literals_to_create_immutables, camel_case_types, avoid_print, unused_catch_stack, use_build_context_synchronously
import 'package:ecm_application/Model/Project/Damage/DamageCommanModel.dart';
import 'package:ecm_application/Model/Project/Damage/DamageInformation.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DamageInformationmodel? modelData;
// List<DamageInsertModel>? _DisplayList = <DamageInsertModel>[];
List<DamageInsertModel>? imageList = <DamageInsertModel>[];
// List<DamageInsertModel>? infromationList = <DamageInsertModel>[];
// List<DamageInsertModel>? Mechanical = <DamageInsertModel>[];
// List<DamageDetailsCommon>? ChakNo = <DamageDetailsCommon>[];

class Information_DetailsScreen extends StatefulWidget {
  String? ProjectName;
  String? Source;

  Information_DetailsScreen(
      DamageInformationmodel? _modelData, String project, String source) {
    modelData = _modelData ?? null;
    ProjectName = project;
    Source = source;
  }

  @override
  State<Information_DetailsScreen> createState() =>
      _Information_DetailsScreenState();
}

class _Information_DetailsScreenState extends State<Information_DetailsScreen> {
  @override
  void initState() {
    super.initState();
    // getImagePathlist();
  }

/*
  List<String> imagePathList = [];

  List<String> imagebytearrayList = [];


  getImagePathlist() async {
    try {
      for (int i = 0; i < imagePathList.length; i++) {
        final temp = await GetImagebyPath(imagePathList[i]);
        if ((temp ?? "").isNotEmpty) {
          imagebytearrayList.add(temp!);
        }
      }
    } catch (_, ex) {}
  }

  Future<String?> GetImagebyPath(String imgPath) async {
    String? img64base;
    try {
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://wmsservices.seprojects.in/api/Image/GetImage?imgPath=$imgPath'));
      print(
          'http://wmsservices.seprojects.in/api/Image/GetImage?imgPath=$imgPath');

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        img64base = await response.stream.bytesToString();
      } else {
        print(response.reasonPhrase);
      }
    } catch (_, ex) {}

    return img64base!.replaceAll('"', '');
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(modelData!.chakNo ?? "")),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (modelData!.informationList != null)
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
                            child: Text("Information",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              modelData!.informationList!
                                  .replaceAll(",", "\n\n"),
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
                            DateFormat("dd MMM, yyyy")
                                .format(DateTime.parse(modelData!.reportedOn!)),
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
/*
  Widget _buildImageList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: imagePath2.length,
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
*/
}

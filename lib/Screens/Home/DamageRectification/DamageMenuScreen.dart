// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unnecessary_new, file_names, use_key_in_widget_constructors, prefer_collection_literals, unnecessary_null_comparison, unused_field, must_be_immutable

import 'package:ecm_application/Screens/Home/DamageRectification/DamageHistory/DamageNodeHistoryList.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageInformation/DamageInformationCommon.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageIssues/DamageIssuesCommon.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageMaterialCunsumption/MaterialConsumptionCommon.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageReportStatus/DamageReport_Screen.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageReportList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DamageMenuScreen extends StatefulWidget {
  @override
  State<DamageMenuScreen> createState() => _DamageMenuScreenState();
}

class _DamageMenuScreenState extends State<DamageMenuScreen> {
  @override
  void initState() {
    super.initState();
    getProjectName();
  }

  String? projectName;

  getProjectName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectName = preferences.getString('ProjectName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            ('damage/rectification').toUpperCase(),
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DamageReportScreen()),
                              (Route<dynamic> route) => true,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(3.0, 3.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/DamageForm.png'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Damage/Rectification Form',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!(projectName!.toLowerCase() == 'cluster-x') &&
                          !(projectName!.toLowerCase() == 'cluster-xiii'))
                        InkWell(
                          onTap: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DamageReport_Screen()),
                              (Route<dynamic> route) => true,
                            );
                            /*showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Page Under Construction"),
                                content: Text(
                                    "Sorry, this page is still under construction."),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              );
                            },
                          );*/
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3.0, 3.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/ShieldForm.png'),
                                      height: 60,
                                      width: 45,
                                    ),
                                  ),
                                  Text(
                                    'Damage Status Report',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DamageHistory_Screen()),
                              (Route<dynamic> route) => true,
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: Text("Page Under Construction"),
                            //       content: Text(
                            //           "Sorry, this page is still under construction."),
                            //       actions: [
                            //         TextButton(
                            //           child: Text("OK"),
                            //           onPressed: () =>
                            //               Navigator.of(context).pop(),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(3.0, 3.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/ShieldForm.png'),
                                    height: 60,
                                    width: 45,
                                  ),
                                ),
                                Text(
                                  'Damage History',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!(projectName!.toLowerCase() == 'cluster-x') &&
                          !(projectName!.toLowerCase() == 'cluster-xiii'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MaterialConsumption_Screen()),
                                (Route<dynamic> route) => true,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3.0, 3.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/ShieldForm.png'),
                                      height: 60,
                                      width: 45,
                                    ),
                                  ),
                                  Text(
                                    'Material Consumption',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!(projectName!.toLowerCase() == 'cluster-x') &&
                          !(projectName!.toLowerCase() == 'cluster-xiii'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DamageInformation_Screen()),
                                (Route<dynamic> route) => true,
                              );
                              /*showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Page Under Construction"),
                                  content: Text(
                                      "Sorry, this page is still under construction."),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          */
                            },
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3.0, 3.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/ShieldForm.png'),
                                      height: 60,
                                      width: 45,
                                    ),
                                  ),
                                  Text(
                                    'information Report',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!(projectName!.toLowerCase() == 'cluster-x') &&
                          !(projectName!.toLowerCase() == 'cluster-xiii'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DamageIssues_Screen()),
                                (Route<dynamic> route) => true,
                              );
                              /*showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Page Under Construction"),
                                  content: Text(
                                      "Sorry, this page is still under construction."),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          */
                            },
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(3.0, 3.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/ShieldForm.png'),
                                      height: 60,
                                      width: 45,
                                    ),
                                  ),
                                  Text(
                                    'Issue Counter Report',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

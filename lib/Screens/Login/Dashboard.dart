// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unnecessary_new, file_names, use_key_in_widget_constructors, prefer_collection_literals, avoid_unnecessary_containers

import 'package:ecm_application/Model/Project/Login/ProjectOverviewModel.dart';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/Screens/Login/ProjectMenuScreen.dart';
import 'package:ecm_application/Screens/Login/MyDrawerScreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsCategoryScreen extends StatefulWidget {
  @override
  State<ProjectsCategoryScreen> createState() => _ProjectsCategoryScreenState();
}

class _ProjectsCategoryScreenState extends State<ProjectsCategoryScreen> {
  @override
  void initState() {
    super.initState();
    getProjectList();
  }

  Set<String>? stateList;
  String? selectState;
  List<ProjectModel>? projectList;
  ProjectModel? selectProject;
  Future<List<ProjectModel>>? futureProjectList;

  getProjectList() {
    setState(() {
      stateList = Set();
      stateList!.add('ALL STATE');
      projectList = [];
      projectList!.add(new ProjectModel(id: 0, projectName: 'ALL PROJECT'));
      selectState = stateList!.first;
      selectProject = projectList!.first;
      futureProjectList = getStateAuthority();
      futureProjectList!.then((value) {
        projectList!.addAll(value);
        for (var element in value) {
          stateList!.add(element.state!);
        }
      });
    });
  }

  String? search = 'All';

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: MyDrawerScreen(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'ECM Application'.toUpperCase(),
            textScaleFactor: 1,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await getProjectList();
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: DropdownButton(
                              isExpanded: true,
                              value: selectState,
                              items: stateList!.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child:
                                      Center(child: Text(items.toUpperCase())),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectState = newValue!;
                                  selectProject = projectList!
                                      .where((element) =>
                                          element.state ==
                                          (selectState != 'ALL STATE'
                                              ? selectState
                                              : element.state))
                                      .first;
                                });
                              },
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            // width: size.width * 0.45,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectProject,
                                items: projectList!.where((element) {
                                  if (element.state ==
                                      (selectState != 'ALL STATE'
                                          ? selectState
                                          : element.state)) {
                                    return true;
                                  } else if (element.projectName ==
                                      "ALL PROJECT") {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                }).map((ProjectModel items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Center(
                                        child: Text(
                                            items.projectName!.toUpperCase())),
                                  );
                                }).toList(),
                                onChanged: (ProjectModel? newValue) {
                                  setState(() {
                                    selectProject = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  getBody()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getpop(context) {
    return showDialog(
      barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (ctx) => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getBody() {
    return Expanded(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: FutureBuilder(
          future: futureProjectList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(211, 255, 255, 255),
                        borderRadius: BorderRadius.circular(25)),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            height: 100,
                            width: 100,
                            image: AssetImage('assets/images/storm.png')),
                        Text(
                          'OPPS!',
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 24,
                              fontFamily: "RaleWay",
                              fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Text(
                            'it seems Something went wrong with the Connection please try after sometime',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "RaleWay",
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              List<ProjectModel> data = [];
              data = (snapshot.data as List<ProjectModel>).where((element) {
                if (selectProject?.projectName == "ALL PROJECT" &&
                    element.state == selectState) {
                  return true;
                } else if (selectProject?.projectName != "ALL PROJECT" &&
                    selectProject == element) {
                  return true;
                } else if (selectProject?.projectName == "ALL PROJECT" &&
                    selectState == "ALL STATE") {
                  return true;
                }
                return false;
              }).toList();
              var items = data.toList();
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      var hostip = data[index].hostIp;
                      var projectName = data[index].project;
                      var userName = data[index].userName;
                      var pswd = data[index].password;
                      String conString =
                          'Data Source=$hostip;Initial Catalog=$projectName;User ID=$userName;Password=$pswd;';
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      setState(() {
                        preferences.setString(
                            'EcString', data[index].eCString!);
                        preferences.setString(
                            'DcString', data[index].dRString!);
                        preferences.setString(
                            'RcString', data[index].rCString!);

                        preferences.setString('AllowDeviceTypeString',
                            data[index].allowDeviceTypeString!);
                        preferences.setString('ConString', conString);
                        preferences.setString(
                            'ProjectName', data[index].projectName!);
                        preferences.setString('StateName', data[index].state!);
                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectMenuScreen(
                                  data[index].projectName!.toString(),
                                )),
                        (Route<dynamic> route) => true,
                      );
                    },
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(3.0, 3.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FutureBuilder(
                              future: GetProjectOverviewStatus(
                                  data[index].project!,
                                  data[index].hostIp,
                                  data[index].userName,
                                  data[index].password),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  var listData =
                                      snap.data as ProjectOverviewModel;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Heading
                                      Container(
                                        height: 40,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 0, 174, 255),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[index]
                                                  .projectName!
                                                  .toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Center(
                                                          child: Material(
                                                            color:
                                                                Colors.black45,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                color: Colors
                                                                    .transparent,
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Colors.white),
                                                                          child:
                                                                              Column(children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: 50,
                                                                                decoration: BoxDecoration(color: Colors.teal),
                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Icon(
                                                                                      Icons.info,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.all(5),
                                                                                    child: Text(
                                                                                      data[index].projectName!.toString(),
                                                                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: InkWell(
                                                                                        onTap: (() {
                                                                                          Navigator.pop(context);
                                                                                        }),
                                                                                        child: Icon(
                                                                                          Icons.clear,
                                                                                          color: Colors.white,
                                                                                        )),
                                                                                  )
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 20),
                                                                              child: Container(
                                                                                color: Colors.white,
                                                                                width: double.infinity,
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  //OMS
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "OMS",
                                                                                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            //Total
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                top: 8.00,
                                                                                                right: 10.00,
                                                                                              ),
                                                                                              child: Container(
                                                                                                alignment: Alignment.center,
                                                                                                height: 30.00,
                                                                                                width: 56.00,
                                                                                                decoration: BoxDecoration(color: Colors.cyan.shade300, borderRadius: BorderRadius.circular(5)),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(4.0),
                                                                                                  child: Text(
                                                                                                    listData.totalOms.toString(),
                                                                                                    textScaleFactor: 1,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Inter',
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            //Online
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                top: 8.00,
                                                                                                right: 10.00,
                                                                                              ),
                                                                                              child: Container(
                                                                                                alignment: Alignment.center,
                                                                                                height: 30.00,
                                                                                                width: 56.00,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                  color: Colors.lightGreen,
                                                                                                ),
                                                                                                child: Text(
                                                                                                  listData.onlineOms.toString(),
                                                                                                  textScaleFactor: 1,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Inter',
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            //Offline
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                top: 8.00,
                                                                                                right: 10.00,
                                                                                              ),
                                                                                              child: Container(
                                                                                                alignment: Alignment.center,
                                                                                                height: 30.00,
                                                                                                width: 56.00,
                                                                                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                                                                                                child: Text(
                                                                                                  listData.offlineOms.toString(),
                                                                                                  textScaleFactor: 1,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Inter',
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            //Damage
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                top: 8.00,
                                                                                                right: 10.00,
                                                                                              ),
                                                                                              child: Container(
                                                                                                alignment: Alignment.center,
                                                                                                height: 30.00,
                                                                                                width: 56.00,
                                                                                                decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
                                                                                                child: Text(
                                                                                                  listData.damageOms.toString(),
                                                                                                  textScaleFactor: 1,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Inter',
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  //AMS
                                                                                  if (listData.totalAms != null && listData.totalAms != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            "AMS",
                                                                                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              //Total
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                    color: Colors.cyan.shade300,
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                                    child: Text(
                                                                                                      listData.totalAms.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Online
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.lightGreen,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    listData.onlineAms.toString(),
                                                                                                    textScaleFactor: 1,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Inter',
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Offline
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.red,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    listData.offlineAms.toString(),
                                                                                                    textScaleFactor: 1,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Inter',
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Damage
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.yellow,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                                                    child: Text(
                                                                                                      listData.damageAms.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  //RMS
                                                                                  if (listData.totalRms != null && listData.totalRms != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            "RMS",
                                                                                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              //Total
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                    color: Colors.cyan.shade300,
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                                    child: Text(
                                                                                                      listData.totalRms.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Online
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.lightGreen,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    listData.onlineRms.toString(),
                                                                                                    textScaleFactor: 1,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Inter',
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Offline
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.red,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    listData.offlineRms.toString(),
                                                                                                    textScaleFactor: 1,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Inter',
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Damage
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.yellow,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                                                    child: Text(
                                                                                                      listData.damageRms.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  //LoRa
                                                                                  if (listData.noOfLoRaGateway != null && listData.noOfLoRaGateway != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            "LoRa GateWay",
                                                                                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              //Total
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                    color: Colors.cyan.shade300,
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                                    child: Text(
                                                                                                      listData.noOfLoRaGateway.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //Damage
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 30.00,
                                                                                                  width: 56.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.yellow,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                                                    child: Text(
                                                                                                      listData.damageLoRaGateway.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  //Pump satation
                                                                                  if (listData.noOfPS != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Pump Station",
                                                                                                softWrap: true,
                                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 27.00,
                                                                                                  width: 46.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.cyan.shade300,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    listData.noOfPS.toString(),
                                                                                                    textScaleFactor: 1,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Inter',
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      if (listData.pS1Status != null)
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.only(
                                                                                                            top: 8.00,
                                                                                                            right: 10.00,
                                                                                                          ),
                                                                                                          child: Container(
                                                                                                            alignment: Alignment.center,
                                                                                                            height: 27.00,
                                                                                                            width: 46.00,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: (listData.pS1Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                                            ),
                                                                                                            child: Text(
                                                                                                              "PS 1",
                                                                                                              textScaleFactor: 1,
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.black,
                                                                                                                fontSize: 16,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      if (listData.pS2Status != null)
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.only(
                                                                                                            top: 8.00,
                                                                                                            right: 10.00,
                                                                                                          ),
                                                                                                          child: Container(
                                                                                                            alignment: Alignment.center,
                                                                                                            height: 27.00,
                                                                                                            width: 46.00,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: (listData.pS2Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                                            ),
                                                                                                            child: Text(
                                                                                                              "PS 2",
                                                                                                              textScaleFactor: 1,
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.black,
                                                                                                                fontSize: 16,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      if (listData.pS3Status != null)
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.only(
                                                                                                            top: 8.00,
                                                                                                            right: 10.00,
                                                                                                          ),
                                                                                                          child: Container(
                                                                                                            alignment: Alignment.center,
                                                                                                            height: 27.00,
                                                                                                            width: 46.00,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: (listData.pS3Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                                            ),
                                                                                                            child: Text(
                                                                                                              "PS 3",
                                                                                                              textScaleFactor: 1,
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.black,
                                                                                                                fontSize: 16,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      if (listData.pS4Status != null)
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.only(
                                                                                                            top: 8.00,
                                                                                                            right: 10.00,
                                                                                                          ),
                                                                                                          child: Container(
                                                                                                            alignment: Alignment.center,
                                                                                                            height: 27.00,
                                                                                                            width: 46.00,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: (listData.pS4Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                                            ),
                                                                                                            child: Text(
                                                                                                              "PS 4",
                                                                                                              textScaleFactor: 1,
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.black,
                                                                                                                fontSize: 16,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                    if (listData.pS5Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS5Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 5",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS6Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS6Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 6",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS7Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS7Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 7",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS8Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS8Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 8",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                  ]),
                                                                                                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                    if (listData.pS9Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS9Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 9",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS10Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS10Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 10",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS11Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS11Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 11",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS12Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS12Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 12",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                  ]),
                                                                                                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                    if (listData.pS13Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS13Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 13",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS14Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS14Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 14",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS15Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS15Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 15",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    if (listData.pS16Status != null)
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(
                                                                                                          top: 8.00,
                                                                                                          right: 10.00,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: 27.00,
                                                                                                          width: 46.00,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: (listData.pS16Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            "PS 16",
                                                                                                            textScaleFactor: 1,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Inter',
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                  ]),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  //BPT
                                                                                  if (listData.noOfDC != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Text(
                                                                                                "BPT",
                                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              //Total
                                                                                              Padding(
                                                                                                padding: EdgeInsets.only(
                                                                                                  top: 8.00,
                                                                                                  right: 10.00,
                                                                                                ),
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 27.00,
                                                                                                  width: 46.00,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.cyan.shade300,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                                                                    child: Text(
                                                                                                      listData.noOfDC.toString(),
                                                                                                      textScaleFactor: 1,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SingleChildScrollView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            child: Row(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                if (listData.noOfDC! >= 1)
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      top: 8.00,
                                                                                                      right: 10.00,
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.center,
                                                                                                      height: 27.00,
                                                                                                      width: 46.00,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: (listData.dC1Status != 0 || listData.dC1AStatus != 0 ? Colors.lightGreen : Colors.red),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        // getWidget(ProjectName) + "1"
                                                                                                        data[index].projectName!.toLowerCase() == 'BISTAN'.toLowerCase() ? "SG 1" : "DC 1",
                                                                                                        textScaleFactor: 1,
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                if (listData.noOfDC! >= 2)
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      top: 8.00,
                                                                                                      right: 10.00,
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.center,
                                                                                                      height: 27.00,
                                                                                                      width: 46.00,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: (listData.dC2Status != 0 || listData.dC1Btatus != 0 ? Colors.lightGreen : Colors.red),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        // getWidget(ProjectName) + "2"
                                                                                                        data[index].projectName!.toLowerCase() == 'BISTAN'.toLowerCase() ? "SG 2" : "DC 2",
                                                                                                        textScaleFactor: 1,
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                if (listData.noOfDC! >= 3)
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      top: 8.00,
                                                                                                      right: 10.00,
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.center,
                                                                                                      height: 27.00,
                                                                                                      width: 46.00,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: (listData.dc3Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        // getWidget(ProjectName) + "3"
                                                                                                        data[index].projectName!.toLowerCase() == 'BISTAN'.toLowerCase() ? "SG 3" : "DC 3",
                                                                                                        textScaleFactor: 1,
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                if (listData.noOfDC! >= 4)
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      top: 8.00,
                                                                                                      right: 10.00,
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.center,
                                                                                                      height: 27.00,
                                                                                                      width: 46.00,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: (listData.pS4Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        // getWidget(ProjectName) + "4"
                                                                                                        data[index].projectName!.toLowerCase() == 'BISTAN'.toLowerCase() ? "SG 4" : "DC 4",
                                                                                                        textScaleFactor: 1,
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                if (listData.noOfDC! >= 5)
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      top: 8.00,
                                                                                                      right: 10.00,
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.center,
                                                                                                      height: 27.00,
                                                                                                      width: 46.00,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: (listData.pS5Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        // getWidget(ProjectName) + "5"
                                                                                                        data[index].projectName!.toLowerCase() == 'BISTAN'.toLowerCase() ? "SG 5" : "DC 5",
                                                                                                        textScaleFactor: 1,
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                if (listData.noOfDC! >= 6)
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      top: 8.00,
                                                                                                      right: 10.00,
                                                                                                    ),
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.center,
                                                                                                      height: 27.00,
                                                                                                      width: 46.00,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: (listData.pS6Status != 0 ? Colors.lightGreen : Colors.red),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Text(
                                                                                                        // getWidget(ProjectName) + "6"
                                                                                                        data[index].projectName!.toLowerCase() == 'BISTAN'.toLowerCase() ? "SG 6" : "DC 6",
                                                                                                        textScaleFactor: 1,
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  //Active Alarm
                                                                                  if (listData.activeAlarms != 0)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            "Active Alarm",
                                                                                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          //Total
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(
                                                                                              top: 8.00,
                                                                                              right: 10.00,
                                                                                            ),
                                                                                            child: Container(
                                                                                              alignment: Alignment.center,
                                                                                              height: 27.00,
                                                                                              width: 46.00,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.red,
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                              child: Text(
                                                                                                listData.activeAlarms.toString(),
                                                                                                textScaleFactor: 1,
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 16,
                                                                                                  fontFamily: 'Inter',
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                ]),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                        ),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.info,
                                                  color: Colors.black,
                                                ))
                                          ],
                                        ),
                                      ),
                                      //State Name
                                      Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "State Name : ",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  data[index].state!.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              ],
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Text(
                                            //       "Client Name : ",
                                            //       style: TextStyle(
                                            //           color: ColorConstant.gray600,
                                            //           fontSize: 18,
                                            //           fontWeight: FontWeight.bold),
                                            //     ),
                                            //     Text(
                                            //       "",
                                            //       style: TextStyle(
                                            //           color: Colors.black,
                                            //           fontSize: 18,
                                            //           fontWeight: FontWeight.normal),
                                            //     )
                                            //   ],
                                            // )
                                          ]),
                                        ),
                                      ),
                                      //Carousel
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          enlargeCenterPage: true,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                        items: listData.pieData?.map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color.fromARGB(
                                                      255, 194, 255, 249),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        i.title!,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        194,
                                                                        255,
                                                                        249),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .lightBlue
                                                                            .shade700),
                                                                    width: 150,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Total ${i.title!}: ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14,
                                                                                color: Colors.white),
                                                                          ),
                                                                          Text(
                                                                            (i.totalDevice ?? 0).toString(),
                                                                            softWrap:
                                                                                true,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14,
                                                                                color: Colors.black),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (i.title !=
                                                                      'LORA')
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                  if (i.title !=
                                                                      'LORA')
                                                                    Container(
                                                                      width:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .lightGreen
                                                                              .shade900),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              "Online ${i.title!}: ",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                                                            ),
                                                                            Text(
                                                                              (i.onlineDevice ?? 0).toString(),
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (i.title !=
                                                                      'LORA')
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                  if (i.title !=
                                                                      'LORA')
                                                                    Container(
                                                                      width:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red
                                                                              .shade700),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              "Offline ${i.title!}: ",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                                                            ),
                                                                            Text(
                                                                              (i.offlineDevice ?? 0).toString(),
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Container(
                                                                    width: 150,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            247,
                                                                            183,
                                                                            51)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Damage ${i.title!}: ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14,
                                                                                color: Colors.white),
                                                                          ),
                                                                          Text(
                                                                            (i.damageDevice ?? 0).toString(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14,
                                                                                color: Colors.black),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: PieChart(
                                                              animationDuration:
                                                                  Duration(
                                                                      seconds:
                                                                          5),
                                                              dataMap:
                                                                  i.pieData!,
                                                              chartType:
                                                                  ChartType
                                                                      .ring,
                                                              colorList: [
                                                                Colors.green,
                                                                Colors.red,
                                                                Colors.orange
                                                              ],
                                                              chartValuesOptions:
                                                                  ChartValuesOptions(
                                                                showChartValueBackground:
                                                                    false,
                                                                showChartValues:
                                                                    false,
                                                                showChartValuesInPercentage:
                                                                    false,
                                                                showChartValuesOutside:
                                                                    false,
                                                                decimalPlaces:
                                                                    1,
                                                              ),
                                                              legendOptions:
                                                                  LegendOptions(
                                                                      showLegends:
                                                                          false),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //Page Indicator

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: listData.pieData!.map((item) {
                                          int index =
                                              listData.pieData!.indexOf(item);
                                          return Container(
                                            width: 8,
                                            height: 8,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _current == index
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                          );
                                        }).toList(),
                                      ),

                                      /* Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [1, 2, 3, 4]
                                            .map((url) => Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 2.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _current == url - 1
                                                        ? Colors.black
                                                        : Colors.grey[300],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    */
                                    ],
                                  );
                                } else if (snap.hasError) {
                                  return Container();
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ))),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

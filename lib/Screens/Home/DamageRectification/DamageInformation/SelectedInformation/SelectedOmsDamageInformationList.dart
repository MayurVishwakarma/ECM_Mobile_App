// ignore_for_file: use_key_in_widget_constructors, file_names, library_private_types_in_public_api, non_constant_identifier_names, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_catch_stack, unrelated_type_equality_checks, unused_field, camel_case_types, unnecessary_null_comparison, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, prefer_collection_literals

import 'dart:convert';
import 'package:ecm_application/Model/Project/Damage/SelectedInformationDamageModel.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/DamageInformation/SelectedInformation/InformationListScreen.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? omsStatus_check = 'All',
    DamageStatus_check = 'All',
    ListStatus = 'All',
    Source = '';
AreaModel? modelArea;
DistibutroryModel? modelDistributary;

class SelectedOmsDamageInformationScreen extends StatefulWidget {
  SelectedOmsDamageInformationScreen(
      {Key? key,
      AreaModel? area_,
      DistibutroryModel? dist_,
      String? omsStatus_check_,
      String? DamageStatus_check_,
      String? ListStatus_,
      String? Source_})
      : super(key: key) {
    modelArea = area_;
    modelDistributary = dist_;
    omsStatus_check = omsStatus_check_;
    DamageStatus_check = DamageStatus_check_;
    ListStatus = ListStatus_;
    Source = Source_;
  }
  @override
  State<SelectedOmsDamageInformationScreen> createState() =>
      _SelectedOmsDamageInformationScreenState();
}

class _SelectedOmsDamageInformationScreenState
    extends State<SelectedOmsDamageInformationScreen> {
  List<SelectedInformationModel>? _DisplayList = <SelectedInformationModel>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _DisplayList = [];
    });
    _firstLoad();
    getDropDownAsync();
    // _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _firstLoad();
  }
/*
  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }*/

  var area = 'All';
  var distibutory = 'All';

  String? _search = '';

  AreaModel? selectedArea = modelArea;
  DistibutroryModel? selectedDistributory = modelDistributary;

  Future<List<DistibutroryModel>>? futureDistributory;
  Future<List<AreaModel>>? futureArea;
  List<PMSChaklistModel>? ProcessList;
  List<DistibutroryModel>? DistriList;

  getDropDownAsync() async {
    setState(() {
      futureArea = getAreaid();
      futureDistributory = getDistibutoryid();
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? project = preferences.getString('project');
  }

  getDist(BuildContext context, List<DistibutroryModel> values) {
    try {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 168, 211, 237),
            borderRadius: BorderRadius.circular(5)),
        child: DropdownButton(
          value: selectedDistributory == null ||
                  (values
                      .where((e) => e.id == selectedDistributory!.id)
                      .isEmpty)
              ? values.first
              : selectedDistributory,
          underline: Container(color: Colors.transparent),
          isExpanded: true,
          items: values.map((DistibutroryModel distibutroryModel) {
            return DropdownMenuItem<DistibutroryModel>(
              value: distibutroryModel,
              child: Center(
                child: FittedBox(
                  child: Text(
                    distibutroryModel.description!,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (textvalue) async {
            setState(() {
              _page = 0;
              _hasNextPage = true;
              _isFirstLoadRunning = false;
              _isLoadMoreRunning = false;
              _DisplayList = <SelectedInformationModel>[];

              selectedDistributory = textvalue as DistibutroryModel;
              distibutory = selectedDistributory!.id == 0
                  ? "All"
                  : selectedDistributory!.id.toString();
            });
            _firstLoad();
          },
        ),
      );
    } catch (_) {
      return Container();
    }
  }

  getArea(BuildContext context, List<AreaModel> values) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 168, 211, 237),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButton(
        underline: Container(color: Colors.transparent),
        value: selectedArea == null ||
                (values.where((element) => element == selectedArea)) == 0
            ? values.first
            : selectedArea,
        isExpanded: true,
        items: values.map((AreaModel areaModel) {
          return DropdownMenuItem<AreaModel>(
            value: areaModel,
            child: Center(
              child: FittedBox(
                child: Text(
                  areaModel.areaName ?? "",
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (textvalue) async {
          //onAreaChange(textvalue);
          var data = textvalue as AreaModel;
          var distriFuture = getDistibutoryid(
              areaId: data.areaid == 0 ? 'All' : data.areaid.toString());
          await distriFuture.then((value) => setState(() {
                selectedDistributory = value.first;
                distibutory = "All";
              }));
          setState(() {
            _page = 0;
            _hasNextPage = true;
            _isFirstLoadRunning = false;
            _isLoadMoreRunning = false;
            _DisplayList = <SelectedInformationModel>[];

            selectedArea = data;
            futureDistributory = distriFuture;

            area = selectedArea!.areaid == 0
                ? "All"
                : selectedArea!.areaid.toString();
          });
          _firstLoad();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('List By Selected Information'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _page = 0;
          });
          _DisplayList = [];
          _firstLoad();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: _DisplayList! != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          Stack(
                            children: [
                              Positioned(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onChanged: (value) async {
                                              setState(() {
                                                _search = value;
                                              });
                                            },
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.go,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                hintText: "Search"),
                                          ),
                                        ),
                                        IconButton(
                                          splashColor: Colors.blue,
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            getpop(context);

                                            setState(() {
                                              _page = 0;
                                              _hasNextPage = true;
                                              _isFirstLoadRunning = false;
                                              _isLoadMoreRunning = false;
                                              _DisplayList =
                                                  <SelectedInformationModel>[];
                                            });
                                            _firstLoad();

                                            Future.delayed(Duration(seconds: 1),
                                                () {
                                              Navigator.pop(
                                                  context); //pop dialog
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //dropdown
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// This Future Builder is Used for Area DropDown list
                                FutureBuilder(
                                  future: futureArea,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Expanded(
                                          child:
                                              getArea(context, snapshot.data!));
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Something Went Wrong: ${snapshot.error}",
                                        textScaleFactor: 1,
                                      );
                                    } else {
                                      return Center(child: Container());
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),

                                ///This Future Builder is Used for Distibutory DropDown List
                                FutureBuilder(
                                  future: futureDistributory,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Expanded(
                                          child:
                                              getDist(context, snapshot.data!));
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    } else {
                                      return Center(child: Container());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              getDeviceName(Source!),
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Text(
                                              '(Distri-Area)',
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    // width: 90,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Total Count',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          getOmsList(context)
                        ])
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/soon.gif',
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Page under construction',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  getDeviceName(String source) {
    try {
      if (source.toLowerCase() == 'oms') {
        return 'Chak No.';
      } else if (source.toLowerCase() == 'ams') {
        return 'Ams No.';
      } else if (source.toLowerCase() == 'rms') {
        return 'Rms No.';
      } else {
        return 'Gateway No.';
      }
    } catch (_, ex) {}
  }

  getDeviceNameValue(String source, int index) {
    try {
      if (source.toLowerCase() == 'oms') {
        return _DisplayList![index].chakNo;
      } else if (source.toLowerCase() == 'ams') {
        return _DisplayList![index].amsNo;
      } else if (source.toLowerCase() == 'rms') {
        return _DisplayList![index].rmsNo;
      } else if (source.toLowerCase() == 'lora') {
        return _DisplayList![index].gatewayNo;
      }else {
        return _DisplayList![index].chakNo;
      }
    } catch (_, ex) {}
  }

  getOmsList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 13.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), // Increase the circular radius
              bottomRight: Radius.circular(30), // Increase the circular radius
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          child: _isFirstLoadRunning
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    getBody(),
                    // when the _loadMore function is running
                    _isLoadMoreRunning
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 40),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox(),

                    // When nothing else to load
                    !_hasNextPage ? SizedBox(height: 10) : SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget getBody() {
    if (_DisplayList!.isNotEmpty) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _DisplayList!.length,
        itemBuilder: (context, index) {
          return Container(
            // height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: InkWell(
                onTap: () async {
                  var projectName;
                  var conString;
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  conString = preferences.getString('ConString');
                  projectName = preferences.getString('ProjectName')!;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectedInformationList(
                              _DisplayList![index],
                              projectName,
                              Source!,
                            )),
                    (Route<dynamic> route) => true,
                  ).whenComplete(() {
                    _firstLoad();
                  });
                  print(_DisplayList![index].gatewayName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //chak No.
                    SizedBox(
                        height: 50,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(getDeviceNameValue(Source!, index),
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            if ((_DisplayList![index].area ?? '').isNotEmpty &&
                                (_DisplayList![index].description ?? '')
                                    .isNotEmpty)
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                        '( ' +
                                            (_DisplayList![index].area ?? '')
                                                .toString() +
                                            "-" +
                                            (_DisplayList![index].description ??
                                                    '')
                                                .toString() +
                                            ' )',
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.blue,
                                            fontFamily: "Lato")),
                                  ),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(
                        height: 50,
                        // width: 90,
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: _DisplayList![index].totalCount != 0
                                    ? Colors.red
                                    : Colors.green, //colorchngerEle(index),
                                borderRadius: BorderRadius.circular(80)),
                            child: Center(
                              child: Text(
                                _DisplayList![index].totalCount.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                )),
          );
        },
      );
    } else {
      return _widget = const Center(child: CircularProgressIndicator());
    }
  }

  Widget? _widget;
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

  int _page = 0;
  final int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _page = 0;
      _isFirstLoadRunning = true;
      _hasNextPage = true;
      _isFirstLoadRunning = false;
      _isLoadMoreRunning = false;
    });
    if (ListStatus == '') {
      ListStatus = "0";
    }
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? conString = preferences.getString('ConString');
      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/infoReport/GetInformationReportStatus_DateFilter?AreaId=$area&DistributoryId=$distibutory&Source=$Source&isFilter=$ListStatus&InfoTypeName=information&conString=$conString'));
      print(
          'http://wmsservices.seprojects.in/api/infoReport/GetInformationReportStatus_DateFilter?AreaId=$area&DistributoryId=$distibutory&Source=$Source&isFilter=$ListStatus&InfoTypeName=information&conString=$conString');

      var json = jsonDecode(res.body);
      List<SelectedInformationModel> fetchedData = <SelectedInformationModel>[];
      json['data']['Response'].forEach(
          (e) => fetchedData.add(SelectedInformationModel.fromJson(e)));
      _DisplayList = [];
      if (fetchedData.isNotEmpty) {
        setState(() {
          _DisplayList!.addAll(fetchedData);
          _DisplayList != Set();
        });
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  /*void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
        _page += 1; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? conString = preferences.getString('ConString');

        final res = await http.get(Uri.parse(
            'http://wmsservices.seprojects.in/api/DamageReport/GetDamageCountWithDateFilter_New?DamageId=$ListStatus&areaId=$area&DistributoryId=$distibutory&Source=$Source&conString=$conString'));
        var json = jsonDecode(res.body);
        List<SelectedInformationModel> fetchedData =
            <SelectedInformationModel>[];
        json['data']['Response'].forEach(
            (e) => fetchedData.add(SelectedInformationModel.fromJson(e)));
        if (fetchedData.isNotEmpty) {
          setState(() {
            _DisplayList!.addAll(fetchedData);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }
*/
}

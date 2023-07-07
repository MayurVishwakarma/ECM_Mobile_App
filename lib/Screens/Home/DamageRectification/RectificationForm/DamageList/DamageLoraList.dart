// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, unused_field, camel_case_types, use_key_in_widget_constructors

import 'dart:convert';
import 'package:ecm_application/Model/Project/Damage/LoramasterModel.dart';
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Screens/Home/DamageRectification/RectificationForm/DamageForms/DamageLoraForm.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lora_DamagePage extends StatefulWidget {
  @override
  State<Lora_DamagePage> createState() => _Lora_DamagePageState();
}

class _Lora_DamagePageState extends State<Lora_DamagePage> {
  List<LoraMasterModel>? _DisplayList = <LoraMasterModel>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _DisplayList = [];
    });

    _firstLoad();
    getDropDownAsync();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  var area = 'All';
  var distibutory = 'ALL';

  String? _search = '';

  AreaModel? selectedArea;
  DistibutroryModel? selectedDistributory;

  Future<List<DistibutroryModel>>? futureDistributory;
  Future<List<AreaModel>>? futureArea;

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
              _DisplayList = <LoraMasterModel>[];

              selectedDistributory = textvalue as DistibutroryModel;
              distibutory = selectedDistributory!.id == 0
                  ? "All"
                  : selectedDistributory!.id.toString();
            });
            _firstLoad();
            //  await GetOmsOverviewModel();
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
            _DisplayList = <LoraMasterModel>[];

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
    return RefreshIndicator(
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
            height: size.height,
            width: size.width,
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
                                            _DisplayList = <LoraMasterModel>[];
                                          });
                                          _firstLoad();

                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            Navigator.pop(context); //pop dialog
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
                              horizontal: 8.0, vertical: 5.0),
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
                                    return Container() /*Text(
                                  "Something Went Wrong: " /*+
                                      snapshot.error.toString()*/
                                  ,
                                  textScaleFactor: 1,
                                )*/
                                        ;
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
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5))
                                // gradient: LinearGradient(
                                //   begin: Alignment(
                                //     -0.11693549743786386,
                                //     5.232387891851431e-7,
                                //   ),
                                //   end: Alignment(
                                //     1.016128983862346,
                                //     0.8571436124054905,
                                //   ),
                                //   colors: [
                                //     ColorConstant.lightBlue701,
                                //     ColorConstant.cyan302,
                                //   ],
                                // ),
                                ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Gateway Name',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      'Electrical',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      'Mechanical',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
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
    );
  }

  getOmsList(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        controller: _controller,
        interactive: true,
        thickness: 12,
        radius: Radius.circular(30),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _controller,
          child: Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 13.0),
            decoration: BoxDecoration(
              color: ColorConstant.whiteA700,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), // Increase the circular radius
                bottomRight:
                    Radius.circular(30), // Increase the circular radius
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConstant.black90026,
                  spreadRadius: 2.0,
                  blurRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            width: size.width,
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
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 40),
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
      ),
    );
  }

  Widget getBody() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _DisplayList!.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 40,
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
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String conString = preferences.getString('ConString')!;
                    String projectName = preferences.getString('ProjectName')!;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoraDamage_Screen(
                              _DisplayList![index], projectName, 'lora')),
                      (Route<dynamic> route) => true,
                    ).whenComplete(() {
                      _firstLoad();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //chak No.
                      SizedBox(
                          height: 50,
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                        _DisplayList![index].gatewayName!,
                                        textScaleFactor: 1,
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                        '( ${_DisplayList![index].gatewayNo} )',
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.blue,
                                            fontFamily: "Lato")),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                          height: 50,
                          width: 90,
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: _DisplayList![index].electrical != 0
                                      ? Colors.red
                                      : Colors.green, //colorchngerEle(index),
                                  borderRadius: BorderRadius.circular(80)),
                              child: Center(
                                child: Text(
                                  _DisplayList![index].electrical.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                          height: 50,
                          width: 90,
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: _DisplayList![index].mechanical != 0
                                      ? Colors.red
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  _DisplayList![index].mechanical.toString(),
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
            ),
          ],
        );
      },
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
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/LoRa/LoRaDamageReportStatus?Search=$_search&conString=$conString'));

      print(
          'http://wmsservices.seprojects.in/api/LoRa/LoRaDamageReportStatus?Search=$_search&conString=$conString');

      var json = jsonDecode(res.body);
      List<LoraMasterModel> fetchedData = <LoraMasterModel>[];
      json['data']['Response']
          .forEach((e) => fetchedData.add(LoraMasterModel.fromJson(e)));
      _DisplayList = [];
      if (fetchedData.length > 0) {
        setState(() {
          _DisplayList!.addAll(fetchedData);
          // viewdata = _DisplayList;
        });
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
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
        //int? userid = preferences.getInt('userid');
        String? conString = preferences.getString('ConString');
        //String? project = preferences.getString('project');

        final res = await http.get(Uri.parse(
            'http://wmsservices.seprojects.in/api/LoRa/LoRaDamageReportStatus?Search=$_search&conString=$conString'));
        var json = jsonDecode(res.body);
        List<LoraMasterModel> fetchedData = <LoraMasterModel>[];
        json['data']['Response']
            .forEach((e) => fetchedData.add(LoraMasterModel.fromJson(e)));
        if (fetchedData.length > 0) {
          setState(() {
            _DisplayList!.addAll(fetchedData);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
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
}

// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, sort_child_properties_last, import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, library_private_types_in_public_api, unused_import, unused_element, prefer_interpolation_to_compose_strings, avoid_print, prefer_is_empty, use_build_context_synchronously, prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, must_be_immutable, non_constant_identifier_names, unused_local_variable, unused_catch_stack, unrelated_type_equality_checks, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, prefer_collection_literals
// import 'package:custom_switch/custom_switch.dart';
import 'dart:convert';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/ECMToolScreen.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/NodeDetails_SQL.dart';
import 'package:ecm_application/Screens/Home/ECM_Tool-Screen/NodeDetails_new.dart';
import 'package:floor/floor.dart';
import 'package:http/http.dart' as http;
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import '../../../core/SQLite/DbHepherSQL.dart';

class OmsPage extends StatefulWidget {
  String? ProjectName;
  String? Source;
  OmsPage({this.ProjectName, this.Source});

  @override
  State<OmsPage> createState() => _OmsPageState();
}

class _OmsPageState extends State<OmsPage> {
  List<PMSListViewModel>? _DisplayList = <PMSListViewModel>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _DisplayList = [];
      ProcessStatusList = [];
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

  List<PMSListViewModel> Listdata = [];
  var conString;
  PMSListViewModel? viewdata;
  var listdatas;
  // Initial Selected Value
  var area = 'All';
  var distibutory = 'ALL';
  var process = 'ALL';
  var processStatus = 'ALL';

  String? _search = '';

  AreaModel? selectedArea;
  DistibutroryModel? selectedDistributory;
  PMSChaklistModel? selectedProcess;
  ProcessModel? selectedProcessStatus;

  List<ProcessModel>? ProcessStatusList;
  Future<List<DistibutroryModel>>? futureDistributory;
  Future<List<AreaModel>>? futureArea;
  List<PMSChaklistModel>? ProcessList;
  List<DistibutroryModel>? DistriList;

  List<PMSListViewModel> listview = [];
  // List<ECM_Checklist_Model> datas = [];
  Future ListcolorChanger() async {
    listview = await ListViewModel.instance
        .fatchcommonlist(widget.Source!.toLowerCase(), widget.ProjectName!);
    // datas = await DBSQL.instance.fatchdataSQL(deviceids);
  }

  Color colorchnger(int index) {
    try {
      for (var item in listview) {
        if (item.omsId == _DisplayList![index].omsId) {
          return Color.fromRGBO(108, 211, 180, 1);
        }
      }
      return Colors.blue;
    } catch (_) {
      return Colors.blue;
    }
  }

  getDropDownAsync() async {
    setState(() {
      futureArea = getAreaid();
      futureDistributory = getDistibutoryid();
    });
    await getProcessid().then((values) {
      ProcessList = [];
      ProcessStatusList = [];
      var processList = Set();
      for (var e in values) {
        processList.add(e.processName);
      }
      List<PMSChaklistModel> newList = [];
      List<ProcessModel>? newStatusList = [];
      for (String item in processList) {
        int? processid = values
            .firstWhere((element) => element.processName == item)
            .processId;
        newList.add(PMSChaklistModel(processId: processid, processName: item));

        if (item.toLowerCase().contains('dry comm')) {
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "All",
              processStatusName: "Pending"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "3",
              processStatusName: "Commented"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "1",
              processStatusName: "Fully Completed"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "2",
              processStatusName: "Fully Completed & Approved"));
        } else {
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "All",
              processStatusName: "Pending"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "4",
              processStatusName: "Commented"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "1",
              processStatusName: "Partially Completed"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "2",
              processStatusName: "Fully Completed"));
          newStatusList.add(ProcessModel(
              processId: processid,
              processName: item,
              processStatusId: "3",
              processStatusName: "Fully Completed & Approved"));
        }
      }
      setState(() {
        ProcessList = newList;
        ProcessStatusList = newStatusList;
      });
      addlist();
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
              _DisplayList = <PMSListViewModel>[];

              selectedDistributory = textvalue as DistibutroryModel;
              distibutory = selectedDistributory!.id == 0
                  ? "All"
                  : selectedDistributory!.id.toString();
            });
            _firstLoad();
            // await GetOmsOverviewModel();
          },
        ),
      );
    } catch (_, ex) {
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
            _DisplayList = <PMSListViewModel>[];

            selectedArea = data;
            futureDistributory = distriFuture;

            area = selectedArea!.areaid == 0
                ? "All"
                : selectedArea!.areaid.toString();
          });
          _firstLoad();
          // await GetOmsOverviewModel();
          // setState(() {
          //   try {
          //     selectedState = textvalue as AreaModel;
          //   } catch (_, ex) {
          //     print(ex);
          //   }
          // });
        },
      ),
    );
  }

  getProcess(BuildContext context, List<PMSChaklistModel> values) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 168, 211, 237),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButton(
        underline: Container(color: Colors.transparent),
        value: selectedProcess == null ||
                (values.where((element) => element == selectedProcess)).isEmpty
            ? values.first
            : selectedProcess,
        isExpanded: true,
        items: values.map((PMSChaklistModel processModel) {
          return DropdownMenuItem<PMSChaklistModel>(
            value: processModel,
            child: Center(
              child: FittedBox(
                child: Text(
                  processModel.processName!,
                  textScaleFactor: 1,
                  softWrap: true,
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (textvalue) async {
          var data = textvalue as PMSChaklistModel;
          setState(() {
            selectedProcess = data;

            process = selectedProcess!.processId == 0
                ? "All"
                : selectedProcess!.processId.toString();
            processStatus = "All";
          });
          _firstLoad();
        },
      ),
    );
  }

  getProcessStatus(BuildContext context, List<ProcessModel> values) {
    try {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 168, 211, 237),
            borderRadius: BorderRadius.circular(5)),
        child: DropdownButton(
          underline: Container(color: Colors.transparent),
          value: selectedProcessStatus == null ||
                  (values.where((element) => element == selectedProcessStatus))
                      .isEmpty
              ? values.first
              : selectedProcessStatus,
          isExpanded: true,
          items: values.map((ProcessModel processModel) {
            return DropdownMenuItem<ProcessModel>(
              value: processModel,
              child: Center(
                child: FittedBox(
                  child: Text(
                    processModel.processStatusName!,
                    textScaleFactor: 1,
                    softWrap: true,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (textvalue) async {
            //onAreaChange(textvalue);
            var data = textvalue as ProcessModel;
            // var distriFuture = getProcessid();
            // await distriFuture.then((value) => setState(() {
            //       selectedProcess = value.first;
            //       process = "All";
            //     }));
            setState(() {
              selectedProcessStatus = data;
              // futureProcess = distriFuture;

              processStatus = selectedProcessStatus!.processStatusId.toString();
            });
            _firstLoad();
          },
        ),
      );
    } catch (_, ex) {
      print(ex);
      return Container();
    }
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
          physics: AlwaysScrollableScrollPhysics(),
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
                        //search
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
                                            _DisplayList = <PMSListViewModel>[];
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      "Something Went Wrong: " +
                                          snapshot.error.toString(),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (ProcessList != null)
                                Expanded(
                                    child: getProcess(context, ProcessList!)),
                              SizedBox(
                                width: 10,
                              ),
                              if (ProcessStatusList != null && process != 'All')
                                Expanded(
                                    child: getProcessStatus(
                                        context,
                                        ProcessStatusList!
                                            .where((element) =>
                                                element.processId ==
                                                int.tryParse(process))
                                            .toList())),
                            ],
                          ),
                        ),

                        //listview
                        Expanded(
                          child: Scrollbar(
                            controller: _controller,
                            interactive: true,
                            thickness: 10,
                            radius: Radius.circular(15),
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              controller: _controller,
                              child: SizedBox(
                                width: size.width,
                                child: _isFirstLoadRunning
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Column(children: [
                                        getBody(),
                                        SizedBox(height: 150),
                                        // when the _loadMore function is running
                                        if (_isLoadMoreRunning == true)
                                          Container(),
                                        // Center(
                                        //   child: CircularProgressIndicator(),
                                        // ),

                                        // When nothing else to load
                                        if (_hasNextPage == false) Container(),
                                      ]),
                              ),
                            ),
                          ),
                        ),
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

  getBody() {
    try {
      var _processlist =
          ProcessList!.where((element) => element.processId != 0).toList();
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _DisplayList!.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                var source = 'oms';
                var projectName;
                var conString;
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();

                preferences.setString(
                    'Mechanical', _DisplayList![index].mechanical.toString());
                preferences.setString(
                    'Erection', _DisplayList![index].erection.toString());
                preferences.setString('DryComm',
                    _DisplayList![index].dryCommissioning.toString());
                preferences.setString('AutoDryComm',
                    _DisplayList![index].autoDryCommissioning.toString());
                conString = preferences.getString('ConString');
                projectName = preferences.getString('ProjectName')!;

                conString!.toString().contains('ID=sa')
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NodeDetails_SQL(
                                _DisplayList![index],
                                projectName,
                                source,
                                listdatas)),
                        (Route<dynamic> route) => true,
                      ).whenComplete(() => {
                          _firstLoad(),
                          getDropDownAsync(),
                          _controller = ScrollController()
                            ..addListener(_loadMore),
                        })
                    : Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NodeDetails(
                                _DisplayList![index],
                                projectName,
                                source,
                                viewdata!,
                                listdatas)),
                        (Route<dynamic> route) => true,
                      ).whenComplete(() => {
                          _firstLoad(),
                          getDropDownAsync(),
                          _controller = ScrollController()
                            ..addListener(_loadMore),
                        });

                setState(() {
                  viewdata = _DisplayList![index];
                  listdatas = _DisplayList![index].omsId;
                });
                // await fatchdataSQL();
                // await addDataPMS();
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        // height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: colorchnger(index),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _DisplayList![index].chakNo.toString(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            Text(
                              '( ' +
                                  ((_DisplayList![index].areaName ?? '').trim())
                                      .toString() +
                                  ' - ' +
                                  (_DisplayList![index].description ?? '')
                                      .trim()
                                      .toString() +
                                  ' )',
                              softWrap: true,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white70),
                            child: SafeArea(
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _processlist.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 4,
                                ),
                                itemBuilder: (BuildContext context, int i) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              ConvertLongtoShortString(
                                                  _processlist[i].processName!),
                                              softWrap: true,
                                              textScaleFactor: 1,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Image(
                                                image: AssetImage(
                                                  getprocessstatus(
                                                    _processlist[i]
                                                        .processName!,
                                                    getProStatus(
                                                      _processlist[i]
                                                          .processName!,
                                                      _DisplayList![index],
                                                    ),
                                                  ),
                                                ),
                                                height: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } catch (ex, _) {
      return Container();
    }
  }

  getprocessstatus(String pro, int proStatus) {
    String imagepath = 'assets/images/pending.png';
    try {
      if (pro.toLowerCase().contains('auto')) {
        if (proStatus == 1) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      } else if (pro.toLowerCase().contains('dry comm')) {
        if (proStatus == 1) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      } else {
        if (proStatus == 1) {
          imagepath = 'assets/images/Partially.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 4) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      }
    } catch (ex, _) {
      imagepath = 'assets/images/notcompletted.png';
    }
    return imagepath;
  }

  String ConvertLongtoShortString(String str) {
    var list = str.split(' ');
    var tempStr = '';
    for (var i in list)
      if (i.length > 3)
        tempStr += i.substring(0, 4).toUpperCase() + " ";
      else
        tempStr += i.toUpperCase() + " ";

    return tempStr;
  }

  getProStatus(String proStatus, PMSListViewModel model) {
    int? status = 0;
    try {
      proStatus = proStatus.toLowerCase();
      if (proStatus.contains('mechan'))
        status = int.tryParse(model.mechanical!);
      else if (proStatus.contains('erect'))
        status = int.tryParse(model.erection!);
      else if (proStatus.contains('auto dry'))
        status = int.tryParse(model.autoDryCommissioning);
      else if (proStatus.contains('auto wet'))
        status = int.tryParse(model.autoWetCommissioning);
      else if (proStatus.contains('dry comm'))
        status = int.tryParse(model.dryCommissioning!);
      else if (proStatus.contains('wet comm'))
        status = int.tryParse(model.wetCommissioning!);
    } catch (_) {}
    return status;
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
          'http://wmsservices.seprojects.in/api/PMS/ECMReportStatus?Search=$_search&areaId=$area&DistributoryId=$distibutory&Process=$process&ProcessStatus=$processStatus&pageIndex=$_page&pageSize=$_limit&Source=OMS&conString=$conString'));

      print(
          'http://wmsservices.seprojects.in/api/PMS/ECMReportStatus?Search=$_search&areaId=$area&DistributoryId=$distibutory&Process=$process&ProcessStatus=$processStatus&pageIndex=$_page&pageSize=$_limit&Source=OMS&conString=$conString');

      var json = jsonDecode(res.body);
      List<PMSListViewModel> fetchedData = <PMSListViewModel>[];
      json['data']['Response']
          .forEach((e) => fetchedData.add(PMSListViewModel.fromJson(e)));
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
    await ListcolorChanger();
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
            'http://wmsservices.seprojects.in/api/PMS/ECMReportStatus?Search=$_search&areaId=$area&DistributoryId=$distibutory&Process=$process&ProcessStatus=$processStatus&pageIndex=$_page&pageSize=$_limit&Source=OMS&conString=$conString'));
        var json = jsonDecode(res.body);
        List<PMSListViewModel> fetchedData = <PMSListViewModel>[];
        json['data']['Response']
            .forEach((e) => fetchedData.add(PMSListViewModel.fromJson(e)));
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

  Future addlist() async {
    for (int i = 0; i <= ProcessList!.length; i++) {
      // ProcessList[i].source
      final data = ProcessList![i];
      ListModel.instance.insert(data.toJson());
    }
  }

  // Future addDataPMS() async {
  //   //  if (listdatas == null) {
  //   //   final data = listdatas!;
  //   //   ListViewModel.instance.insert(data.toJson());
  //   // } else {
  //   //   final data = listdatas!;
  //   //   ListViewModel.instance.NewUpdatedata(data);
  //   // }
  //   for (int i = 0; i <= viewdata!.length; i++) {
  //     final data = viewdata![i];
  //     ListViewModel.instance.insert(data.toJson());
  //   }
  // }
}

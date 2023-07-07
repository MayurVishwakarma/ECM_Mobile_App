//this page fully work on for all sql project offline list Screen
// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, must_be_immutable, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/Project/ECMTool/ECM_Checklist_Model.dart';
import '../../../Model/Project/ECMTool/PMSChackListModel.dart';
import '../../../Model/Project/ECMTool/PMSListViewModel.dart';
import '../DbHepherSQL.dart';
import 'SQL_Screen.dart';

class Offline_ListSQL extends StatefulWidget {
  int? omsId;
  int? amsId;
  int? getwayId;
  int? rmsId;

  String? ProjectName;
  String? Source;
  Offline_ListSQL(
      {required,
      this.omsId,
      this.amsId,
      this.getwayId,
      this.rmsId,
      this.ProjectName,
      this.Source,
      super.key});

  @override
  State<Offline_ListSQL> createState() => _Offline_ListSQLState();
}

class _Offline_ListSQLState extends State<Offline_ListSQL> {
  @override
  void initState() {
    fatchdataSQL();
    super.initState();
  }

  String selectedProcess = "CONTROL UNOT ERECTION";
  String Source = 'set';
  List<ECM_Checklist_Model> datas = [];
  List<ECM_Checklist_Model> datas11 = [];
  List<PMSListViewModel> Listdata = [];
  List<PMSChaklistModel> ProcessList = [];
  List<ECM_Checklist_Model> datasnew = [];
  var _controller;
  var _isFirstLoadRunning;
  var _isLoadMoreRunning;
  var _hasNextPage;

//first load list Sql from offline database anduse it
  void fatchdataSQL() async {
    bool isLoading = false;
    setState(() => isLoading = true);
    Listdata = await ListViewModel.instance.fatchdataPMSViewList(
        widget.ProjectName!, widget.Source!.toLowerCase());
    datas = await DBSQL.instance.fatchdataSQLNew();
    ProcessList = await ListModel.instance.fatchdataPMSListData();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ECM TOOL")),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Listdata.isNotEmpty
            ? Column(children: [
                Expanded(
                  child: Scrollbar(
                    thickness: 6,
                    radius: Radius.circular(15),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        getBody(),
                      ]),
                    ),
                  ),
                ),
              ])
            : Center(
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No Offline Data Stored',
                      style: TextStyle(fontSize: 20.0),
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
          ProcessList.where((element) => element.processId != 1).toList();
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: Listdata.length,
          itemBuilder: (BuildContext context, int index) {
            // if (checkItemIsPresentOrNot(Listdata[index].omsId!)) {
            return InkWell(
              onTap: () async {
                var source = 'oms';
                var projectName;
                var conString;
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();

                preferences.setString(
                    'Mechanical', Listdata[index].mechanical.toString());
                preferences.setString(
                    'Erection', Listdata[index].erection.toString());
                preferences.setString(
                    'DryComm', Listdata[index].dryCommissioning.toString());
                preferences.setString('AutoDryComm',
                    Listdata[index].autoDryCommissioning.toString());
                conString = preferences.getString('ConString');
                projectName = preferences.getString('ProjectName')!;

                final temp = await Navigator.of(context).push(
                  MaterialPageRoute(
                      //this page navigate to node details page
                      builder: (context) => SQL_Screen(
                            omsId: Listdata[index].omsId,
                            amsId: Listdata[index].amsId,
                            getwayId: Listdata[index].gateWayId,
                            rmsId: Listdata[index].rmsId,
                            deviceId: datas[index].deviceId,
                            ProjectName: Listdata.first.projectName,
                            Source: Listdata.first.deviceType,
                            modelDatas: Listdata[index],
                            processId: datas[index].processId,
                            
                          )),
                );
                if (temp == true) {
                  fatchdataSQL();
                }
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      // height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 56, 131, 230),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getEmsToolName(index).toString(),
                            // Listdata[index].chakNo.toString() ??
                            //Listdata[index].amsNo.toString(),
                            // Listdata[index].rmsNo.toString() ??
                            // Listdata[index].gatewayNo.toString(),

                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            '( ' +
                                Listdata[index].areaName.toString() +
                                '-' +
                                Listdata[index].description.toString() +
                                ' )',
                            softWrap: true,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            );
          });
    } catch (ex, _) {
      return Container();
    }
  }

  String? getEmsToolName(int index) {
    if (Listdata[index].amsNo != null) {
      return Listdata[index].amsNo.toString();
    } else if (Listdata[index].chakNo != null) {
      return Listdata[index].chakNo.toString();
    } else if (Listdata[index].rmsNo != null) {
      return Listdata[index].rmsNo.toString();
    } else if (Listdata[index].gatewayNo != null) {
      return Listdata[index].gateWayId.toString();
    }
    return null;
  }

  String ConvertLongtoShortString(String str) {
    var list = str.split(' ');
    var tempStr = '';
    for (var i in list) {
      if (i.length > 3) {
        tempStr += i.substring(0, 4).toUpperCase() + " ";
      } else {
        tempStr += i.toUpperCase() + " ";
      }
    }

    return tempStr;
  }

  getProStatus(String proStatus, PMSListViewModel model) {
    int? status = 0;
    try {
      proStatus = proStatus.toLowerCase();
      if (proStatus.contains('mechan')) {
        status = int.tryParse(model.mechanical ?? "");
      } else if (proStatus.contains('erect')) {
        status = int.tryParse(model.erection ?? "");
      } else if (proStatus.contains('auto dry')) {
        status = int.tryParse(model.autoDryCommissioning);
      } else if (proStatus.contains('auto wet')) {
        status = int.tryParse(model.autoWetCommissioning);
      } else if (proStatus.contains('dry comm')) {
        status = int.tryParse(model.dryCommissioning ?? "");
      } else if (proStatus.contains('wet comm')) {
        status = int.tryParse(model.wetCommissioning ?? "");
      }
    } catch (_) {}
    return status;
  }
}

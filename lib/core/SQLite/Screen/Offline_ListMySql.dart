// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/Project/ECMTool/ECM_Checklist_Model.dart';
import '../../../Model/Project/ECMTool/PMSChackListModel.dart';
import '../../../Model/Project/ECMTool/PMSListViewModel.dart';
import '../DbHepherSQL.dart';
import 'MySql_Screen.dart';

class Offline_ListMySql extends StatefulWidget {
  int? omsId;
  int? amsId;
  int? getwayId;
  int? rmsId;

  String? ProjectName;
  String? Source;
  Offline_ListMySql(
      {required,
      this.omsId,
      this.amsId,
      this.getwayId,
      this.rmsId,
      this.ProjectName,
      this.Source,
      super.key});

  @override
  State<Offline_ListMySql> createState() => _Offline_ListMySqlState();
}

class _Offline_ListMySqlState extends State<Offline_ListMySql> {
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

//first load list Mysql from offline database anduse it
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
      appBar: AppBar(title: const Text("ECM TOOL")),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Listdata.isNotEmpty
            ? Column(children: [
                Expanded(
                  child: Scrollbar(
                    thickness: 6,
                    radius: const Radius.circular(15),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: getBody(),
                    ),
                  ),
                ),
              ])
            : const Center(
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
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: Listdata.length,
          itemBuilder: (BuildContext context, int index) {
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
                        builder: (context) => MySql_Screen(
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          // height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade400,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getEmsToolName(index).toString(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                '( ${Listdata[index].areaName}-${Listdata[index].description} )',
                                softWrap: true,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ));
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
}

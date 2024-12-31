// ignore_for_file: non_constant_identifier_names, unnecessary_new, curly_braces_in_flow_control_structures, file_names, avoid_print, deprecated_member_use, unused_catch_stack, unused_local_variable

import 'dart:convert';
import 'package:ecm_application/Model/Common/PieChartModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Model/Project/Login/AreaModel.dart';
import 'package:ecm_application/Model/Project/Constants.dart';
import 'package:ecm_application/Model/Project/Login/DistibutoryModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Model/Project/Login/ProjectUserModel.dart';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/Project/Login/ProjectOverviewModel.dart';

Future<List<ProjectModel>> getStateAuthority() async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userid = preferences.getInt('userid');
    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/Project/GetProjectForSEECM?userid=$userid&ProjState=All'));

    print('State List Api');
    print(
        'http://wmsservices.seprojects.in/api/Project/GetProjectForSEECM?userid=$userid&ProjState=All');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<ProjectModel> fetchedData = <ProjectModel>[];
      json['data']['Response']
          .forEach((e) => fetchedData.add(new ProjectModel.fromJson(e)));

      return fetchedData;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

///Project Overview API
Future<ProjectOverviewModel> GetProjectOverviewStatus(
    String? dbName, String? hostIp, String? userName, String? password) async {
  try {
    String conString =
        'Data Source=$hostIp;Initial Catalog=$dbName;User ID=$userName;Password=$password;';
    List<PieChartModel> listData = [];

    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/Project/GetProjectOverviewStatus?aid=All&did=All&conString=$conString'));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      List<ProjectOverviewModel> project = <ProjectOverviewModel>[];
      json.forEach((e) => project.add(new ProjectOverviewModel.fromJson(e)));

      return project.first;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

///Area Dropdown Api
Future<List<AreaModel>> getAreaid() async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/OMS/GetAreaList?conString=$conString'));
    print('Area Id API');
    print(
        'http://wmsservices.seprojects.in/api/OMS/GetAreaList?conString=$conString');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['Status'] == WebApiStatusOk) {
        List<AreaModel> Result = <AreaModel>[];
        Result.insert(
            0, new AreaModel(areaid: 0, areaName: 'ALL DISTRIBUTORY'));
        json['data']['Response']
            .forEach((v) => Result.add(AreaModel.fromJson(v)));
        return Result;
      } else {
        throw Exception();
      }
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

///Distibutory Dropdown Api
Future<List<DistibutroryModel>> getDistibutoryid(
    {String? areaId = 'All', String? devType = 'OMS'}) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');

    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/OMS/GetDistributoryList?areaid=$areaId&deviceType=$devType&conString=$conString'));
    print(
        'http://wmsservices.seprojects.in/api/OMS/GetDistributoryList?areaid=$areaId&deviceType=$devType&conString=$conString');
    print('Distributory Api');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['Status'] == WebApiStatusOk) {
        List<DistibutroryModel> Result = <DistibutroryModel>[];
        Result.insert(0, new DistibutroryModel(id: 0, description: 'ALL AREA'));
        json['data']['Response']
            .forEach((v) => Result.add(DistibutroryModel.fromJson(v)));
        return Result;
      } else {
        throw Exception();
      }
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<PMSChaklistModel>> getProcessid({String source = 'OMS'}) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');

    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/PMS/ECMProcessId?Source=$source&conString=$conString'));

    print(
        'http://wmsservices.seprojects.in/api/PMS/ECMProcessId?Source=$source&conString=$conString');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['Status'] == WebApiStatusOk) {
        List<PMSChaklistModel> Result = <PMSChaklistModel>[];
        Result.insert(
            0, new PMSChaklistModel(processId: 0, processName: 'ALL PROCESS'));
        json['data']['Response']
            .forEach((v) => Result.add(PMSChaklistModel.fromJson(v)));
        return Result;
      } else {
        throw Exception();
      }
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<PMSListViewModel>>? getProjectNodeList(
    String source, String conString) async {
  try {
    final res = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/PMS/ECMReportStatus?Search=&areaId=all&DistributoryId=all&Process=all&ProcessStatus=all&pageIndex=0&pageSize=250000&Source=$source&conString=$conString'));

    var json = jsonDecode(res.body);
    List<PMSListViewModel> fetchedData = <PMSListViewModel>[];
    json['data']['Response']
        .forEach((e) => fetchedData.add(PMSListViewModel.fromJson(e)));

    if (fetchedData.length > 0) {
      return fetchedData;
    } else {
      return [];
    }
  } catch (err) {
    print('Something went wrong');
    return [];
  }
}

Future<List<ProjectsUserModel>> getProjetsUsers(String conString) async {
  try {
    final res = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in//api/Project/getProjectUsers?conString=$conString'));

    var json = jsonDecode(res.body);
    List<ProjectsUserModel> fetchedData = <ProjectsUserModel>[];
    json.forEach((e) => fetchedData.add(ProjectsUserModel.fromJson(e)));

    if (fetchedData.length > 0) {
      return fetchedData;
    } else {
      return [];
    }
  } catch (err) {
    print('Something went wrong');
    return [];
  }
}

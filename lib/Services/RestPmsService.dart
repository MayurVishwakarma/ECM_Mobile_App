// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unused_catch_stack, unused_import, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:ecm_application/Model/Project/Constants.dart';
import 'package:ecm_application/Model/Project/ECMTool/ECMCountMasterModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/ECM_Checklist_Model.dart';
import 'package:ecm_application/Model/Project/RoutineCheck/RoutineCheckListModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RestService.dart';

Future<List<ECM_Checklist_Model>> getECMProcess(String source) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    final response = await http.get(Uri.parse(GetHttpRequest(
        WebApiPmsPrefix, 'ECMProcessId?Source=$source&conString=$conString')));
    print(WebApiPmsPrefix + 'ECMProcessId?Source=$source&conString=$conString');
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<ECM_Checklist_Model> result = <ECM_Checklist_Model>[];
      json['data']['Response']
          .forEach((v) => result.add(ECM_Checklist_Model.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (_, ex) {
    throw Exception("API Consumed Failed");
  }
}

Future<List<RoutineCheckListModel>> getRoutineCheckList(
    String omsid, String source) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? conString = preferences.getString('ConString');
    final response = await http.get(Uri.parse(GetHttpRequest(
        WebApiRoutinePrefix,
        'RoutineReport_New?omsId=$omsid&source=$source&conString=$conString')));
    print(WebApiRoutinePrefix +
        'RoutineReport_New?omsId=$omsid&source=$source&conString=$conString');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<RoutineCheckListModel> result = <RoutineCheckListModel>[];
      json['data']['Response']
          .forEach((v) => result.add(RoutineCheckListModel.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (_, ex) {
    throw Exception("API Consumed Failed");
  }
}

Future<List<ECM_Checklist_Model>> getECMCheckListByProcessId(
    int _deviceId, int _processId, String _source) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? conString = preferences.getString('ConString');
  try {
    final response = await http.get(Uri.parse(GetHttpRequest(WebApiPmsPrefix,
        'ECMReport?deviceId=$_deviceId&ProcessId=$_processId&Source=$_source&conString=$conString')));
    print(WebApiPmsPrefix +
        'ECMReport?deviceId=$_deviceId&ProcessId=$_processId&Source=$_source&conString=$conString');
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<ECM_Checklist_Model> result = <ECM_Checklist_Model>[];
      json['data']['Response']
          .forEach((v) => result.add(ECM_Checklist_Model.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (_, ex) {
    throw Exception("API Consumed Failed");
  }
}

Future<List<ECM_Checklist_Model>> getOMSECMCheckListByProcessId(
    int _deviceId, int _processId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? conString = preferences.getString('ConString');
  try {
    final response = await http.get(Uri.parse(GetHttpRequest(WebApiPmsPrefix,
        'OmsECMReport_New?omsId=$_deviceId&ProcessId=$_processId&conString=$conString')));
    print(WebApiPmsPrefix +
        'OmsECMReport_New?omsId=$_deviceId&ProcessId=$_processId&conString=$conString');
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<ECM_Checklist_Model> result = <ECM_Checklist_Model>[];
      json['data']['Response']
          .forEach((v) => result.add(ECM_Checklist_Model.fromJson(v)));
      return result
          .where((element) => element.processId == _processId)
          .toList();
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (_, ex) {
    throw Exception("API Consumed Failed");
  }
}

// Future<List<Damage_CheckList>> getOMSDamageByDeviceId(int _deviceId) async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   String? conString = preferences.getString('ConString');
//   try {
//     final response = await http.get(Uri.parse(
//         'http://wmsservices.seprojects.in/api/Rectify/RectifyReport?deviceId=$_deviceId&source=OMS&conString=$conString'));
//     print(
//         'http://wmsservices.seprojects.in/api/Rectify/RectifyReport?deviceId=$_deviceId&source=OMS&conString=$conString');
//     var json = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       List<Damage_CheckList> result = <Damage_CheckList>[];
//       json['data']['Response']
//           .forEach((v) => result.add(Damage_CheckList.fromJson(v)));
//       return result;
//     } else {
//       throw Exception("API Consumed Failed");
//     }
//   } on Exception catch (_, ex) {
//     throw Exception("API Consumed Failed");
//   }
// }

import 'dart:convert';

// import 'package:ecm_application/Model/Project/Damage/DamageOmsModel.dart';
// import 'package:ecm_application/Model/Project/Damage/DamageReportInsert.dart';
import 'package:ecm_application/Model/Project/Damage/DamageCommanModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<DamageInsertModel>> getDamageformOms(int deviceId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? conString = preferences.getString('ConString');
  try {
    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/OMS/OmsDamageReport_New?omsId=$deviceId&conString=$conString'));
    print(
        'http://wmsservices.seprojects.in/api/OMS/OmsDamageReport_New?omsId=$deviceId&conString=$conString');

    if (response.statusCode == 200) {
      List<DamageInsertModel> result = <DamageInsertModel>[];
      var json = jsonDecode(response.body);
      json['data']['Response']
          .forEach((v) => result.add(DamageInsertModel.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

Future<List<DamageInsertModel>> getDamageformAms(int deviceId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? conString = preferences.getString('ConString');
  try {
    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/AMS/AmsDamageReport_New?amsId=$deviceId&conString=$conString'));
    print(
        'http://wmsservices.seprojects.in/api/AMS/AmsDamageReport_New?amsId=$deviceId&conString=$conString');
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<DamageInsertModel> result = <DamageInsertModel>[];
      json['data']['Response']
          .forEach((v) => result.add(DamageInsertModel.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

Future<List<DamageInsertModel>> getDamageformLora(int deviceId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? conString = preferences.getString('ConString');
  try {
    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/LoRa/LoRaDamageReport_New?GatewayId=$deviceId&conString=$conString'));
    print(
        'http://wmsservices.seprojects.in/api/LoRa/LoRaDamageReport_New?GatewayId=$deviceId&conString=$conString');
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<DamageInsertModel> result = <DamageInsertModel>[];
      json['data']['Response']
          .forEach((v) => result.add(DamageInsertModel.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

Future<List<DamageInsertModel>> getDamageformRms(int deviceId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? conString = preferences.getString('ConString');
  try {
    final response = await http.get(Uri.parse(
        'http://wmsservices.seprojects.in/api/RMS/RmsDamageReport_New?rmsId=$deviceId&conString=$conString'));
    print(
        'http://wmsservices.seprojects.in/api/RMS/RmsDamageReport_New?rmsId=$deviceId&conString=$conString');
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<DamageInsertModel> result = <DamageInsertModel>[];
      json['data']['Response']
          .forEach((v) => result.add(DamageInsertModel.fromJson(v)));
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

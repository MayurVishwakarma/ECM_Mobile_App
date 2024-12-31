// ignore_for_file: file_names, unused_catch_stack

import 'package:ecm_application/Model/Project/Constants.dart';
import 'package:ecm_application/Services/RestServices.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:ecm_application/Model/Project/Login/LoginModel.dart';

Future<LoginMasterModel?> fetchLoginDetails(String mobno, String passwd) async {
  try {
    final response = await http.get(Uri.parse(GetHttpRequest(
        WebApiLoginPrefix, 'Login?MobNo=$mobno&Password=$passwd')));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['Status'] == WebApiStatusOk) {
        LoginMasterModel loginResult =
            LoginMasterModel.fromJson(json['data']['Response']);
        return loginResult;
      } else {
        throw Exception("Login Failed");
      }
    } else {
      throw Exception("Login Failed");
    }
  } on Exception catch (_, ex) {
    return null;
  }
}

// ignore_for_file: file_names, non_constant_identifier_names

import 'package:ecm_application/Model/project/Constants.dart';

String GetHttpRequest(String ApiPrefix, String CallName) {
  var url = WebApiUrl + ApiPrefix + CallName;
  return url;
}

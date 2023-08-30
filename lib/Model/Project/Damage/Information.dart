// ignore: file_names
import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/*
class InfoModel {
  InfoModel({
    required this.id,
    required this.infoTypeName,
    required this.active,
    required this.infoDescription,
    required this.deviceId,
    required this.reportedBy,
    required this.reportedOn,
    required this.type,
    required this.value,
    required this.remark,
    required this.imageByteArray,
    required this.mTransId,
    required this.image,
  });
  int? id;
  String? infoTypeName;
  String? active;
  String? infoDescription;
  int? deviceId;
  int? reportedBy;
  DateTime? reportedOn;
  String? type;
  String? value;
  String? remark;
  Uint8List? imageByteArray;
  XFile? image;
  int? mTransId;
  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: json["Id"],
      infoTypeName: json["InfoTypeName"],
      active: json["Active"],
      infoDescription: json["InfoDescription"],
      deviceId: json["DeviceId"],
      reportedBy: json["ReportedBy"],
      reportedOn: DateTime.tryParse(json["ReportedOn"] ?? ""),
      type: json["Type"],
      value: json["Value"],
      remark: json["Remark"],
      image: json["Image"],
      imageByteArray:json["imageByteArray"],
      //  if (json['imageByteArray'] != null) {
      // imageByteArray = base64.decode(json['imageByteArray']);
      // },
      mTransId: json["MTransId"],
    );
  }
}
*/
class InfoModel {
  int? id;
  String? infoTypeName;
  String? active;
  String? infoDescription;
  int? deviceId;
  int? reportedBy;
  String? reportedOn;
  String? type;
  String? value;
  String? remark;
  Uint8List? imageByteArray;
  int? mTransId;
  XFile? image;

  InfoModel(
      {this.id,
      this.infoTypeName,
      this.active,
      this.infoDescription,
      this.deviceId,
      this.reportedBy,
      this.reportedOn,
      this.type,
      this.value,
      this.remark,
      this.imageByteArray,
      this.image,
      this.mTransId});

  InfoModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    infoTypeName = json['InfoTypeName'];
    active = json['Active'];
    infoDescription = json['InfoDescription'];
    deviceId = json['DeviceId'];
    reportedBy = json['ReportedBy'];
    reportedOn = json['ReportedOn'];
    type = json['Type'];
    value = json['Value'];
    remark = json['Remark'];
    // imageByteArray = json['imageByteArray'];
    if (json['imageByteArray'] != null) {
      imageByteArray = base64.decode(json['imageByteArray']);
    }
    ;
    image = json['Image'];
    mTransId = json['MTransId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['InfoTypeName'] = this.infoTypeName;
    data['Active'] = this.active;
    data['InfoDescription'] = this.infoDescription;
    data['DeviceId'] = this.deviceId;
    data['ReportedBy'] = this.reportedBy;
    data['ReportedOn'] = this.reportedOn;
    data['Type'] = this.type;
    data['Value'] = this.value;
    data['Remark'] = this.remark;
    data['imageByteArray'] = this.imageByteArray;
    data['Image'] = this.image;
    data['MTransId'] = this.mTransId;
    return data;
  }
}

import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class DamageIssuesMasterModel {
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
  dynamic imageByteArray;
  int? mTransId;
  XFile? image;

  DamageIssuesMasterModel(
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

  DamageIssuesMasterModel.fromJson(Map<String, dynamic> json) {
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

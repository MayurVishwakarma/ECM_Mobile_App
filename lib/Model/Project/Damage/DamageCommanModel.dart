// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DamageInsertModel {
  int? id;
  String? damage;
  String? type;
  DateTime? datetime;
  int? userId;
  int? amsId;
  int? omsId;
  int? rmsId;
  int? gatewayId;
  String? value;
  Uint8List? imageByteArray;
  String? remark;
  int? mTransId;
  XFile? image;

  DamageInsertModel(
      {this.id,
      this.damage,
      this.type,
      this.datetime,
      this.userId,
      this.amsId,
      this.rmsId,
      this.omsId,
      this.gatewayId,
      this.value,
      this.imageByteArray,
      this.remark,
      this.mTransId,
      this.image});

  DamageInsertModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    damage = json['Damage'];
    type = json['Type'];
    datetime = DateTime.tryParse(json['Datetime'].toString());
    userId = json['UserId'];
    amsId = json['AmsId'];
    rmsId = json['RmsId'];
    omsId = json['OmsId'];
    gatewayId = json['GatewayId'];
    value = json['Value'];
    if (json['imageByteArray'] != null) {
      imageByteArray = base64.decode(json['imageByteArray']);
    }
    remark = json['remark'] ?? json['Remark'];
    mTransId = json['MTransId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Damage'] = this.damage;
    data['Type'] = this.type;
    data['Datetime'] = this.datetime;
    data['UserId'] = this.userId;
    data['AmsId'] = this.amsId;
    data['RmsId'] = this.rmsId;
    data['OmsId'] = this.omsId;
    data['GatewayId'] = this.gatewayId;
    data['Value'] = this.value;
    data['imageByteArray'] = this.imageByteArray;
    data['remark'] = this.remark;
    data['MTransId'] = this.mTransId;
    data['image'] = this.image;
    return data;
  }
}

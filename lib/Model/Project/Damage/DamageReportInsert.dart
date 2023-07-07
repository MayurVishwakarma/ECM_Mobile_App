import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DamageInsertModel {
  int? id;
  String? damage;
  String? type;
  String? datetime;
  int? userId;
  int? gatewayId;
  int? omsId;
  int? amsId;
  int? rmsId;
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
      this.gatewayId,
      this.omsId,
      this.amsId,
      this.rmsId,
      this.value,
      this.imageByteArray,
      this.remark,
      this.mTransId,
      this.image});

  DamageInsertModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    damage = json['Damage'];
    type = json['Type'];
    datetime = json['Datetime'];
    userId = json['UserId'];
    gatewayId = json['GatewayId'];
    omsId = json['OmsId'];
    amsId = json['AmsId'];
    rmsId = json['RmsId'];
    value = json['Value'];
    if (json['imageByteArray'] != null) {
      imageByteArray = base64.decode(json['imageByteArray']);
    }
    remark = json['Remark'];
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
    data['GatewayId'] = this.gatewayId;
    data['OmsId'] = this.omsId;
    data['AmsId'] = this.amsId;
    data['RmsId'] = this.rmsId;
    data['Value'] = this.value;
    data['imageByteArray'] = this.imageByteArray;
    data['Remark'] = this.remark;
    data['MTransId'] = this.mTransId;
    data['image'] = this.image;
    return data;
  }
}

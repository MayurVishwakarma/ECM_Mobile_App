// ignore_for_file: unnecessary_this

import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class RoutineCheckListModel {
  int? id;
  String? description;
  String? inputType;
  String? processType;
  String? routineTestType;
  dynamic value;
  int? workedBy;
  String? workedOn;
  int? routineStatus;
  String? nextScheduleDate;
  dynamic remark;
  XFile? mediaFile;
  Uint8List? imageByteArray;
  dynamic mACAddress;
  dynamic subscribeTopicName;
  int? onOffValvesQty;
  dynamic routineStatusType;
  String? downlink;
  String? deviceType;
  int? mTransId;
  // XFile? image;

  RoutineCheckListModel(
      {this.id,
      this.description,
      this.inputType,
      this.processType,
      this.routineTestType,
      this.value,
      this.workedBy,
      this.workedOn,
      this.routineStatus,
      this.nextScheduleDate,
      this.remark,
      this.mediaFile,
      this.imageByteArray,
      this.mACAddress,
      this.subscribeTopicName,
      this.onOffValvesQty,
      this.routineStatusType,
      this.downlink,
      this.deviceType,
      this.mTransId});

  RoutineCheckListModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    description = json['Description'];
    inputType = json['InputType'];
    processType = json['ProcessType'];
    routineTestType = json['RoutineTestType'];
    value = json['Value'];
    workedBy = json['WorkedBy'];
    workedOn = json['WorkedOn'];
    routineStatus = json['RoutineStatus'];
    nextScheduleDate = json['NextScheduleDate'];
    remark = json['Remark'];
    // if (inputType == 'image') {
    //   if (value!.length != 0)
    //     mediaFile = XFile.fromData(base64.decode(value!));
    //   else
    //     mediaFile = XFile(
    //         "imageupload.png"); //yeh code check kar lena i dont know ki static image kese feed karte XFile me
    // }
    mediaFile = json['mediaFile'];
    if (json['imageByteArray'] != null)
      imageByteArray = base64.decode(json['imageByteArray']);
    mACAddress = json['MACAddress'];
    subscribeTopicName = json['SubscribeTopicName'];
    onOffValvesQty = json['OnOffValvesQty'];
    routineStatusType = json['RoutineStatusType'];
    downlink = json['Downlink'];
    deviceType = json['deviceType'];
    mTransId = json['MTransId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Description'] = this.description;
    data['InputType'] = this.inputType;
    data['ProcessType'] = this.processType;
    data['RoutineTestType'] = this.routineTestType;
    data['Value'] = this.value;
    data['WorkedBy'] = this.workedBy;
    data['WorkedOn'] = this.workedOn;
    data['RoutineStatus'] = this.routineStatus;
    data['NextScheduleDate'] = this.nextScheduleDate;
    data['Remark'] = this.remark;
    data['mediaFile'] = this.mediaFile;
    data['imageByteArray'] = this.imageByteArray;
    data['MACAddress'] = this.mACAddress;
    data['SubscribeTopicName'] = this.subscribeTopicName;
    data['OnOffValvesQty'] = this.onOffValvesQty;
    data['RoutineStatusType'] = this.routineStatusType;
    data['Downlink'] = this.downlink;
    data['deviceType'] = this.deviceType;
    data['MTransId'] = this.mTransId;
    return data;
  }
}

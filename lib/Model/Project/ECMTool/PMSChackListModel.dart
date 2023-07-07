class PMSChaklistModel {
  int? checkListId;
  int? subProcessId;
  int? processId;
  dynamic description;
  int? seqNo;
  dynamic inputType;
  dynamic inputText;
  dynamic value;
  String? subProcessName;
  String? processName;
  int? approvedStatus;
  int? workedBy;
  String? workedOn;
  int? approvedBy;
  String? approvedOn;
  String? tempDT;
  dynamic remark;
  dynamic approvalRemark;
  dynamic imageByteArray;
  int? isMultiValue;
  int? subChakQty;
  dynamic deviceType;
  dynamic downlink;
  dynamic macAddress;
  dynamic subscribeTopicName;
  dynamic parameterName;
  dynamic comment;
  dynamic dataType;
  dynamic source;
  int? deviceId;
  dynamic conString;
  int? userId;
  dynamic siteTeamEngineer;

  PMSChaklistModel(
      {this.checkListId,
      this.subProcessId,
      this.processId,
      this.description,
      this.seqNo,
      this.inputType,
      this.inputText,
      this.value,
      this.subProcessName,
      this.processName,
      this.approvedStatus,
      this.workedBy,
      this.workedOn,
      this.approvedBy,
      this.approvedOn,
      this.tempDT,
      this.remark,
      this.approvalRemark,
      this.imageByteArray,
      this.isMultiValue,
      this.subChakQty,
      this.deviceType,
      this.downlink,
      this.macAddress,
      this.subscribeTopicName,
      this.parameterName,
      this.comment,
      this.dataType,
      this.source,
      this.deviceId,
      this.conString,
      this.userId,
      this.siteTeamEngineer});

  PMSChaklistModel.fromJson(Map<String, dynamic> json) {
    checkListId = json['CheckListId'];
    subProcessId = json['SubProcessId'];
    processId = json['ProcessId'];
    description = json['Description'];
    seqNo = json['SeqNo'];
    inputType = json['InputType'];
    inputText = json['InputText'];
    value = json['Value'];
    subProcessName = json['SubProcessName'];
    processName = json['ProcessName'];
    approvedStatus = json['ApprovedStatus'];
    workedBy = json['WorkedBy'];
    workedOn = json['WorkedOn'];
    approvedBy = json['ApprovedBy'];
    approvedOn = json['ApprovedOn'];
    tempDT = json['TempDT'];
    remark = json['Remark'];
    approvalRemark = json['ApprovalRemark'];
    imageByteArray = json['imageByteArray'];
    isMultiValue = json['IsMultiValue'];
    subChakQty = json['SubChakQty'];
    deviceType = json['DeviceType'];
    downlink = json['Downlink'];
    macAddress = json['MacAddress'];
    subscribeTopicName = json['SubscribeTopicName'];
    parameterName = json['ParameterName'];
    comment = json['Comment'];
    dataType = json['DataType'];
    source = json['Source'];
    deviceId = json['DeviceId'];
    conString = json['conString'];
    userId = json['UserId'];

    siteTeamEngineer = json['SiteTeamEngineer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CheckListId'] = this.checkListId;
    data['SubProcessId'] = this.subProcessId;
    data['ProcessId'] = this.processId;
    data['Description'] = this.description;
    data['SeqNo'] = this.seqNo;
    data['InputType'] = this.inputType;
    data['InputText'] = this.inputText;
    data['Value'] = this.value;
    data['SubProcessName'] = this.subProcessName;
    data['ProcessName'] = this.processName;
    data['ApprovedStatus'] = this.approvedStatus;
    data['WorkedBy'] = this.workedBy;
    data['WorkedOn'] = this.workedOn;
    data['ApprovedBy'] = this.approvedBy;
    data['ApprovedOn'] = this.approvedOn;
    data['TempDT'] = this.tempDT;
    data['Remark'] = this.remark;
    data['ApprovalRemark'] = this.approvalRemark;
    data['imageByteArray'] = this.imageByteArray;
    data['IsMultiValue'] = this.isMultiValue;
    data['SubChakQty'] = this.subChakQty;
    data['DeviceType'] = this.deviceType;
    data['Downlink'] = this.downlink;
    data['MacAddress'] = this.macAddress;
    data['SubscribeTopicName'] = this.subscribeTopicName;
    data['ParameterName'] = this.parameterName;
    data['Comment'] = this.comment;
    data['DataType'] = this.dataType;
    data['Source'] = this.source;
    data['DeviceId'] = this.deviceId;
    data['conString'] = this.conString;
    data['UserId'] = this.userId;

    data['SiteTeamEngineer'] = this.siteTeamEngineer;
    return data;
  }
}

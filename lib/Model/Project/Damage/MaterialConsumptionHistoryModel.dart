class MaterialConsumptionHistoryDamageModel {
  int? id;
  String? chakNo;
  dynamic amsNo;
  dynamic gatewayNo;
  dynamic gatewayName;
  dynamic rmsNo;
  String? areaName;
  String? description;
  String? reportedOn;
  int? reportedBy;
  String? username;
  String? remark;
  String? electRectifyList;
  String? mechRectifyList;
  dynamic tubRectifyList;

  MaterialConsumptionHistoryDamageModel(
      {this.id,
      this.chakNo,
      this.amsNo,
      this.gatewayNo,
      this.gatewayName,
      this.rmsNo,
      this.areaName,
      this.description,
      this.reportedOn,
      this.reportedBy,
      this.username,
      this.remark,
      this.electRectifyList,
      this.mechRectifyList,
      this.tubRectifyList});

  MaterialConsumptionHistoryDamageModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    chakNo = json['ChakNo'];
    amsNo = json['AmsNo'];
    gatewayNo = json['GatewayNo'];
    gatewayName = json['GatewayName'];
    rmsNo = json['RmsNo'];
    areaName = json['AreaName'];
    description = json['Description'];
    reportedOn = json['ReportedOn'];
    reportedBy = json['ReportedBy'];
    username = json['Username'];
    remark = json['Remark'];
    electRectifyList = json['ElectRectifyList'];
    mechRectifyList = json['MechRectifyList'];
    tubRectifyList = json['TubRectifyList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ChakNo'] = this.chakNo;
    data['AmsNo'] = this.amsNo;
    data['GatewayNo'] = this.gatewayNo;
    data['GatewayName'] = this.gatewayName;
    data['RmsNo'] = this.rmsNo;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['ReportedOn'] = this.reportedOn;
    data['ReportedBy'] = this.reportedBy;
    data['Username'] = this.username;
    data['Remark'] = this.remark;
    data['ElectRectifyList'] = this.electRectifyList;
    data['MechRectifyList'] = this.mechRectifyList;
    data['TubRectifyList'] = this.tubRectifyList;
    return data;
  }
}

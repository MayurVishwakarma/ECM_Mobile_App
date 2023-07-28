// ignore_for_file: file_names

class DamageReportCountCommon {
  int? omsId;
  int? amsId;
  int? rmsId;
  int? gateWayId;
  String? chakNo;
  String? amsNo;
  String? gatewayNo;
  String? gatewayName;
  String? rmsNo;
  String? areaName;
  String? description;
  String? villageName;
  String? khasaranumber;
  String? firstname;
  int? electrical;
  int? mechanical;
  String? reportedOn;

  DamageReportCountCommon(
      {this.omsId,
      this.amsId,
      this.rmsId,
      this.gateWayId,
      this.chakNo,
      this.amsNo,
      this.gatewayNo,
      this.gatewayName,
      this.rmsNo,
      this.areaName,
      this.description,
      this.villageName,
      this.khasaranumber,
      this.firstname,
      this.electrical,
      this.mechanical,
      this.reportedOn});

  DamageReportCountCommon.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    amsId = json['AmsId'];
    rmsId = json['RmsId'];
    gateWayId = json['GateWayId'];
    chakNo = json['ChakNo'];
    amsNo = json['AmsNo'];
    gatewayNo = json['GatewayNo'];
    gatewayName = json['GatewayName'];
    rmsNo = json['RmsNo'];
    areaName = json['AreaName'];
    description = json['Description'];
    villageName = json['VillageName'];
    khasaranumber = json['Khasaranumber'];
    firstname = json['firstname'];
    electrical = json['Electrical'];
    mechanical = json['Mechanical'];
    reportedOn = json['reportedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['AmsId'] = this.amsId;
    data['RmsId'] = this.rmsId;
    data['GateWayId'] = this.gateWayId;
    data['ChakNo'] = this.chakNo;
    data['AmsNo'] = this.amsNo;
    data['GatewayNo'] = this.gatewayNo;
    data['GatewayName'] = this.gatewayName;
    data['RmsNo'] = this.rmsNo;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['VillageName'] = this.villageName;
    data['Khasaranumber'] = this.khasaranumber;
    data['firstname'] = this.firstname;
    data['Electrical'] = this.electrical;
    data['Mechanical'] = this.mechanical;
    data['reportedOn'] = this.reportedOn;
    return data;
  }
}

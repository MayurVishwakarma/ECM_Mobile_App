class SelectedMaterialDamageModel {
  int? omsId;
  String? chakNo;
  int? amsId;
  dynamic amsNo;
  int? gatewayId;
  dynamic gateWayNo;
  dynamic gatewayName;
  int? rmsId;
  dynamic rmsNo;
  String? areaName;
  String? description;
  int? electrical;
  int? tubing;
  int? mechanical;
  String? reportedOn;

  SelectedMaterialDamageModel(
      {this.omsId,
      this.chakNo,
      this.amsId,
      this.amsNo,
      this.gatewayId,
      this.gateWayNo,
      this.gatewayName,
      this.rmsId,
      this.rmsNo,
      this.areaName,
      this.description,
      this.electrical,
      this.tubing,
      this.mechanical,
      this.reportedOn});

  SelectedMaterialDamageModel.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    chakNo = json['ChakNo'];
    amsId = json['AmsId'];
    amsNo = json['AmsNo'];
    gatewayId = json['GatewayId'];
    gateWayNo = json['GateWayNo'];
    gatewayName = json['GatewayName'];
    rmsId = json['RmsId'];
    rmsNo = json['RmsNo'];
    areaName = json['AreaName'];
    description = json['Description'];
    electrical = json['Electrical'];
    tubing = json['Tubing'];
    mechanical = json['Mechanical'];
    reportedOn = json['reportedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['ChakNo'] = this.chakNo;
    data['AmsId'] = this.amsId;
    data['AmsNo'] = this.amsNo;
    data['GatewayId'] = this.gatewayId;
    data['GateWayNo'] = this.gateWayNo;
    data['GatewayName'] = this.gatewayName;
    data['RmsId'] = this.rmsId;
    data['RmsNo'] = this.rmsNo;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['Electrical'] = this.electrical;
    data['Tubing'] = this.tubing;
    data['Mechanical'] = this.mechanical;
    data['reportedOn'] = this.reportedOn;
    return data;
  }
}

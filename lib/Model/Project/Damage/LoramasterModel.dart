class LoraMasterModel {
  int? gateWayId;
  String? gatewayNo;
  String? gatewayName;
  int? electrical;
  int? mechanical;

  LoraMasterModel(
      {this.gateWayId,
      this.gatewayNo,
      this.gatewayName,
      this.electrical,
      this.mechanical});

  LoraMasterModel.fromJson(Map<String, dynamic> json) {
    gateWayId = json['GateWayId'];
    gatewayNo = json['GatewayNo'];
    gatewayName = json['GatewayName'];
    electrical = json['Electrical'];
    mechanical = json['Mechanical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GateWayId'] = this.gateWayId;
    data['GatewayNo'] = this.gatewayNo;
    data['GatewayName'] = this.gatewayName;
    data['Electrical'] = this.electrical;
    data['Mechanical'] = this.mechanical;
    return data;
  }
}

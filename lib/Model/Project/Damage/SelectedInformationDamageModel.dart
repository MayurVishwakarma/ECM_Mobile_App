class SelectedInformationModel {
  int? omsId;
  String? chakNo;
  int? amsId;
  String? amsNo;
  int? gatewayId;
  String? gatewayNo;
  String? gatewayName;
  int? rmsId;
  String? rmsNo;
  String? area;
  String? description;
  int? totalCount;
  String? reportedOn;

  SelectedInformationModel(
      {this.omsId,
      this.chakNo,
      this.amsId,
      this.amsNo,
      this.gatewayId,
      this.gatewayNo,
      this.gatewayName,
      this.rmsId,
      this.rmsNo,
      this.area,
      this.description,
      this.totalCount,
      this.reportedOn});

  SelectedInformationModel.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    chakNo = json['ChakNo'];
    amsId = json['AmsId'];
    amsNo = json['AmsNo'];
    gatewayId = json['GatewayId'];
    gatewayNo = json['GatewayNo'];
    gatewayName = json['GatewayName'];
    rmsId = json['RmsId'];
    rmsNo = json['RmsNo'];
    area = json['Area'];
    description = json['Description'];
    totalCount = json['TotalCount'];
    reportedOn = json['reportedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['ChakNo'] = this.chakNo;
    data['AmsId'] = this.amsId;
    data['AmsNo'] = this.amsNo;
    data['GatewayId'] = this.gatewayId;
    data['GatewayNo'] = this.gatewayNo;
    data['GatewayName'] = this.gatewayName;
    data['RmsId'] = this.rmsId;
    data['RmsNo'] = this.rmsNo;
    data['Area'] = this.area;
    data['Description'] = this.description;
    data['TotalCount'] = this.totalCount;
    data['reportedOn'] = this.reportedOn;
    return data;
  }
}

class PMSListViewModel {
  int? omsId;
  String? chakNo;
  int? amsId;
  dynamic amsNo;
  int? rmsId;
  dynamic rmsNo;
  int? isChecking;
  int? gateWayId;
  dynamic gatewayNo;
  dynamic gatewayName;
  dynamic process1;
  dynamic process2;
  dynamic process3;
  dynamic process4;
  dynamic process5;
  dynamic process6;
  String? areaName;
  String? description;
  String? mechanical;
  String? erection;
  dynamic dryCommissioning;
  dynamic wetCommissioning;
  dynamic autoDryCommissioning;
  dynamic autoWetCommissioning;
  dynamic trenching;
  dynamic pipeInatallation;
  int? chainage;
  dynamic coordinates;
  dynamic networkType;
  dynamic deviceType;
  int? deviceId;
  dynamic deviceNo;
  dynamic deviceName;
  dynamic projectName;

  PMSListViewModel(
      {this.omsId,
      this.chakNo,
      this.amsId,
      this.amsNo,
      this.rmsId,
      this.rmsNo,
      this.isChecking,
      this.gateWayId,
      this.gatewayNo,
      this.gatewayName,
      this.process1,
      this.process2,
      this.process3,
      this.process4,
      this.process5,
      this.process6,
      this.areaName,
      this.description,
      this.mechanical,
      this.erection,
      this.dryCommissioning,
      this.wetCommissioning,
      this.trenching,
      this.pipeInatallation,
      this.autoDryCommissioning,
      this.autoWetCommissioning,
      this.chainage,
      this.coordinates,
      this.networkType,
      this.deviceType,
      this.deviceId,
      this.deviceNo,
      this.projectName,
      this.deviceName});

  PMSListViewModel.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    chakNo = json['ChakNo'];
    amsId = json['AmsId'];
    amsNo = json['AmsNo'];
    rmsId = json['RmsId'];
    rmsNo = json['RmsNo'];
    isChecking = json['IsChecking'];
    gateWayId = json['GateWayId'];
    gatewayNo = json['GatewayNo'];
    gatewayName = json['GatewayName'];
    process1 = json['Process1'];
    process2 = json['Process2'];
    process3 = json['Process3'];
    process4 = json['Process4'];
    process5 = json['Process5'];
    process6 = json['Process6'];
    areaName = json['AreaName'];
    description = json['Description'];
    mechanical = json['Mechanical'];
    erection = json['Erection'];
    dryCommissioning = json['DryCommissioning'];
    wetCommissioning = json['WetCommissioning'];
    trenching = json['Trenching'];
    pipeInatallation = json['PipeInatallation'];
    autoDryCommissioning = json['AutoDryCommissioning'];
    autoWetCommissioning = json['AutoWetCommissioning'];
    chainage = json['Chainage'];
    coordinates = json['Coordinates'];
    networkType = json['NetworkType'];
    deviceType = json['DeviceType'];
    deviceId = json['deviceId'];
    deviceNo = json['deviceNo'];
    deviceName = json['deviceName'];
    projectName = json['projectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['ChakNo'] = this.chakNo;
    data['AmsId'] = this.amsId;
    data['AmsNo'] = this.amsNo;
    data['RmsId'] = this.rmsId;
    data['RmsNo'] = this.rmsNo;
    data['IsChecking'] = this.isChecking;
    data['GateWayId'] = this.gateWayId;
    data['GatewayNo'] = this.gatewayNo;
    data['GatewayName'] = this.gatewayName;
    data['Process1'] = this.process1;
    data['Process2'] = this.process2;
    data['Process3'] = this.process3;
    data['Process4'] = this.process4;
    data['Process5'] = this.process5;
    data['Process6'] = this.process6;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['Mechanical'] = this.mechanical;
    data['Erection'] = this.erection;
    data['DryCommissioning'] = this.dryCommissioning;
    data['WetCommissioning'] = this.wetCommissioning;
    data['projectName'] = this.projectName;
    data['Trenching'] = this.trenching;
    data['PipeInatallation'] = this.pipeInatallation;
    data['AutoDryCommissioning'] = this.autoDryCommissioning;
    data['AutoWetCommissioning'] = this.autoWetCommissioning;
    data['Chainage'] = this.chainage;
    data['Coordinates'] = this.coordinates;
    data['NetworkType'] = this.networkType;
    data['DeviceType'] = this.deviceType;
    data['deviceId'] = this.deviceId;
    data['deviceNo'] = this.deviceNo;
    data['deviceName'] = this.deviceName;
    return data;
  }
}

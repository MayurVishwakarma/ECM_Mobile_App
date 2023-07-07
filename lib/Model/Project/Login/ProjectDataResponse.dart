class ProjectDataResponse {
  int? id;
  String? projectName;
  String? state;
  int? totalOMS;
  int? onlineOMS;
  int? totalAMS;
  int? onlineAMS;
  int? noOfPS;
  int? onlinePS;
  int? noOfDc;
  String? client;
  String? contractor;
  int? damageOMS;
  int? offlineOMS;
  int? damageAMS;
  int? offlineAMS;
  int? pS1Status;
  int? pS2Status;
  int? pS3Status;
  int? pS4Status;
  int? pS5Status;
  int? pS6Status;
  int? pS7Status;
  int? dC1Status;
  int? dC2Status;
  int? dC3Status;
  int? dC4Status;
  int? TotalRMS;
  int? OnlineRMS;
  int? OfflineRMS;
  int? DamageRMS;
  String? canalStatus;

  bool? IsPS1Available;
  bool? IsPS2Available;
  bool? IsPS3Available;
  bool? IsPS4Available;
  bool? IsPS5Available;
  bool? IsPS6Available;
  bool? IsPS7Available;
  bool? IsDC1Available;
  bool? IsDC2Available;
  bool? IsDC3Available;
  bool? IsDC4Available;

  bool? IsCanalAvailable;

  List<double>? canalList;
  int? noOfcanalGate;

  ProjectDataResponse(
      {this.id,
      this.projectName,
      this.state,
      this.totalOMS,
      this.onlineOMS,
      this.totalAMS,
      this.onlineAMS,
      this.noOfPS,
      this.onlinePS,
      this.noOfDc,
      this.client,
      this.contractor,
      this.damageOMS,
      this.offlineOMS,
      this.damageAMS,
      this.offlineAMS,
      this.pS1Status,
      this.pS2Status,
      this.pS3Status,
      this.pS4Status,
      this.pS5Status,
      this.pS6Status,
      this.pS7Status,
      this.dC1Status,
      this.dC2Status,
      this.dC3Status,
      this.dC4Status,
      this.canalStatus,
      this.DamageRMS,
      this.OnlineRMS,
      this.OfflineRMS,
      this.TotalRMS,
      this.IsCanalAvailable,
      this.IsDC1Available,
      this.IsDC2Available,
      this.IsDC3Available,
      this.IsDC4Available,
      this.IsPS1Available,
      this.IsPS2Available,
      this.IsPS3Available,
      this.IsPS4Available,
      this.IsPS5Available,
      this.IsPS6Available,
      this.IsPS7Available,
      this.canalList,
      this.noOfcanalGate});

  ProjectDataResponse.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      projectName = json['ProjectName'];
      state = json['State'];
      totalOMS = json['TotalOMS'];
      onlineOMS = json['OnlineOMS'];
      totalAMS = json['TotalAMS'];
      onlineAMS = json['OnlineAMS'];
      noOfPS = json['NoOfPS'];
      onlinePS = json['OnlinePS'];
      noOfDc = json['NoOfDc'];
      client = json['client'];
      contractor = json['Contractor'];
      damageOMS = json['DamageOMS'];
      offlineOMS = json['offlineOMS'];
      damageAMS = json['DamageAMS'];
      offlineAMS = json['offlineAMS'];
      pS1Status = json['PS1Status'];
      pS2Status = json['PS2Status'];
      pS3Status = json['PS3Status'];
      pS4Status = json['PS4Status'];
      pS5Status = json['PS5Status'];
      pS6Status = json['PS6Status'];
      pS7Status = json['PS7Status'];
      dC1Status = json['DC1Status'];
      dC2Status = json['DC2Status'];
      dC3Status = json['DC3Status'];
      dC4Status = json['DC4Status'];
      canalStatus = json['CanalStatus'];
      TotalRMS = json['TotalRMS'];
      OnlineRMS = json['OnlineRMS'];
      OfflineRMS = json['OfflineRMS'];
      DamageRMS = json['DamageRMS'];

      IsPS1Available = noOfPS! >= 1;
      IsPS2Available = noOfPS! >= 2;
      IsPS3Available = noOfPS! >= 3;
      IsPS4Available = noOfPS! >= 4;
      IsPS5Available = noOfPS! >= 5;
      IsPS6Available = noOfPS! >= 6;
      IsPS7Available = noOfPS! >= 7;

      IsDC1Available = noOfDc! >= 1;
      IsDC2Available = noOfDc! >= 2;
      IsDC3Available = noOfDc! >= 3;
      IsDC4Available = noOfDc! >= 4;

      IsCanalAvailable = canalStatus != '' && canalStatus != null;
      if (IsCanalAvailable!) {
        canalList = <double>[];
        var list = canalStatus!.split(',').toList();
        for (String a in list) {
          var value = double.tryParse(a);
          canalList!.add(value!.toDouble());
        }

        if (canalList!.length != 0) noOfcanalGate = canalList!.length;
      }
    } catch (_, ex) {
      print('Abe error hai');
      print('${ex}');
    }
  }

  get isConnected => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ProjectName'] = this.projectName;
    data['State'] = this.state;
    data['TotalOMS'] = this.totalOMS;
    data['OnlineOMS'] = this.onlineOMS;
    data['TotalAMS'] = this.totalAMS;
    data['OnlineAMS'] = this.onlineAMS;
    data['NoOfPS'] = this.noOfPS;
    data['OnlinePS'] = this.onlinePS;
    data['NoOfDc'] = this.noOfDc;
    data['client'] = this.client;
    data['Contractor'] = this.contractor;
    data['DamageOMS'] = this.damageOMS;
    data['offlineOMS'] = this.offlineOMS;
    data['DamageAMS'] = this.damageAMS;
    data['offlineAMS'] = this.offlineAMS;
    data['PS1Status'] = this.pS1Status;
    data['PS2Status'] = this.pS2Status;
    data['PS3Status'] = this.pS3Status;
    data['PS4Status'] = this.pS4Status;
    data['PS5Status'] = this.pS5Status;
    data['PS6Status'] = this.pS6Status;
    data['PS7Status'] = this.pS7Status;
    data['DC1Status'] = this.dC1Status;
    data['DC2Status'] = this.dC2Status;
    data['DC3Status'] = this.dC3Status;
    data['DC4Status'] = this.dC4Status;
    data['CanalStatus'] = this.canalStatus;
    data['TotalRMS'] = this.TotalRMS;
    data['OnlineRMS'] = this.OnlineRMS;
    data['Offline'] = this.OfflineRMS;
    data['Damage'] = this.DamageRMS;
    return data;
  }
}

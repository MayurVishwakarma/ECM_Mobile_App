import 'package:ecm_application/Model/Common/PieChartModel.dart';

class ProjectOverviewModel {
  int? totalOms;
  int? onlineOms;
  int? offlineOms;
  int? damageOms;
  int? totalAms;
  int? onlineAms;
  int? offlineAms;
  int? damageAms;
  int? noOfPS;
  int? pS1Status;
  int? pS2Status;
  int? pS3Status;
  int? pS4Status;
  int? pS5Status;
  int? pS6Status;
  int? pS7Status;
  int? pS8Status;
  int? pS9Status;
  int? pS10Status;
  int? pS11Status;
  int? pS12Status;
  int? pS13Status;
  int? pS14Status;
  int? pS15Status;
  int? pS16Status;
  int? pS17Status;
  int? pS18Status;
  int? ps19Status;
  int? ps20Status;
  int? totalRms;
  int? onlineRms;
  int? offlineRms;
  int? damageRms;
  int? noOfLoRaGateway;
  int? damageLoRaGateway;
  int? noOfDC;
  int? dC1AStatus;
  int? dC1Btatus;
  int? dC1Status;
  int? dC2Status;
  int? dc3Status;
  int? activeAlarms;
  String? canalStatus;
  List<PieChartModel>? pieData;
  bool? isExpanded;

  ProjectOverviewModel(
      {this.totalOms,
      this.onlineOms,
      this.offlineOms,
      this.damageOms,
      this.totalAms,
      this.onlineAms,
      this.offlineAms,
      this.damageAms,
      this.noOfPS,
      this.pS1Status,
      this.pS2Status,
      this.pS3Status,
      this.pS4Status,
      this.pS5Status,
      this.pS6Status,
      this.pS7Status,
      this.pS8Status,
      this.pS9Status,
      this.pS10Status,
      this.pS11Status,
      this.pS12Status,
      this.pS13Status,
      this.pS14Status,
      this.pS15Status,
      this.pS16Status,
      this.pS17Status,
      this.pS18Status,
      this.ps19Status,
      this.ps20Status,
      this.totalRms,
      this.onlineRms,
      this.offlineRms,
      this.damageRms,
      this.noOfLoRaGateway,
      this.damageLoRaGateway,
      this.noOfDC,
      this.dC1AStatus,
      this.dC1Btatus,
      this.dC1Status,
      this.dC2Status,
      this.dc3Status,
      this.activeAlarms,
      this.canalStatus,
      this.pieData,
      this.isExpanded});

  ProjectOverviewModel.fromJson(Map<String, dynamic> json) {
    totalOms = json['TotalOms'] ?? 0;
    onlineOms = json['OnlineOms'] ?? 0;
    offlineOms = json['OfflineOms'] ?? 0;
    damageOms = json['DamageOms'] ?? 0;

    if (json.keys.where((element) => element == 'TotalAms').isNotEmpty)
      totalAms = json['TotalAms'] ?? 0;
    if (json.keys.where((element) => element == 'OnlineAms').isNotEmpty)
      onlineAms = json['OnlineAms'] ?? 0;
    if (json.keys.where((element) => element == 'OfflineAms').isNotEmpty)
      offlineAms = json['OfflineAms'] ?? 0;
    if (json.keys.where((element) => element == 'DamageAms').isNotEmpty)
      damageAms = json['DamageAms'] ?? 0;

    /*totalAms = json['TotalAms'] ?? 0;
    onlineAms = json['OnlineAms'] ?? 0;
    offlineAms = json['OfflineAms'] ?? 0;
    damageAms = json['DamageAms'] ?? 0;*/
    noOfPS = json['NoOfPS'] ?? 0;
    try {
      pS1Status = json['PS1Status'];
      pS2Status = json['PS2Status'];
      pS3Status = json['PS3Status'];
      pS4Status = json['PS4Status'];
      pS5Status = json['PS5Status'];
      pS6Status = json['PS6Status'];
      pS7Status = json['PS7Status'];
      pS8Status = json['PS8Status'];
      pS9Status = json['PS9Status'];
      pS10Status = json['PS10Status'];
      pS11Status = json['PS11Status'];
      pS12Status = json['PS12Status'];
      pS13Status = json['PS13Status'];
      pS14Status = json['PS14Status'];
      pS15Status = json['PS15Status'];
      pS16Status = json['PS16Status'];
      pS17Status = json['PS17Status'];
      pS18Status = json['PS18Status'];
      ps19Status = json['PS19Status'];
      ps20Status = json['PS20Status'];
    } catch (_) {}
    if (json.keys.where((element) => element == 'TotalRms').isNotEmpty)
      totalRms = json['TotalRms'] ?? 0;
    if (json.keys.where((element) => element == 'OnlineRms').isNotEmpty)
      onlineRms = json['OnlineRms'] ?? 0;
    if (json.keys.where((element) => element == 'OfflineRms').isNotEmpty)
      offlineRms = json['OfflineRms'] ?? 0;
    if (json.keys.where((element) => element == 'DamageRms').isNotEmpty)
      damageRms = json['DamageRms'] ?? 0;
    if (json.keys.where((element) => element == 'NoOfLoRaGateway').isNotEmpty)
      noOfLoRaGateway = json['NoOfLoRaGateway'] ?? 0;
    if (json.keys.where((element) => element == 'DamageLoRaGateway').isNotEmpty)
      damageLoRaGateway = json['DamageLoRaGateway'] ?? 0;
    try {
      noOfDC = json['NoOfDC'] ?? 0;
      dC1AStatus = json['DC1AStatus'] ?? 0;
      dC1Btatus = json['DC1Btatus'] ?? 0;
      dC1Status = json['DC1Status'] ?? 0;
      dC2Status = json['DC2Status'] ?? 0;
      dc3Status = json['DC3Status'] ?? 0;
      activeAlarms = json['ActiveAlarms'] ?? 0;
      canalStatus = json['CanalStatus'];
    } catch (_) {}
    pieData = [];
    try {
      // ignore: unnecessary_new
      pieData!.add(new PieChartModel(
          title: 'OMS',
          index: 1,
          totalDevice: totalOms,
          onlineDevice: onlineOms,
          offlineDevice: offlineOms,
          damageDevice: damageOms,
          pieData: {
            'ONLINE': onlineOms!.toDouble(),
            'OFFLINE': offlineOms!.toDouble(),
            'DAMAGE': damageOms!.toDouble(),
          }));
    } catch (_) {}
    try {
      // ignore: unnecessary_new
      pieData!.add(new PieChartModel(
          title: 'AMS',
          index: 2,
          totalDevice: totalAms,
          onlineDevice: onlineAms,
          offlineDevice: offlineAms,
          damageDevice: damageAms,
          pieData: {
            'ONLINE': onlineAms!.toDouble(),
            'OFFLINE': offlineAms!.toDouble(),
            'DAMAGE': damageAms!.toDouble(),
          }));
    } catch (_) {}
    try {
      // ignore: unnecessary_new
      pieData!.add(new PieChartModel(
          title: 'RMS',
          index: 3,
          totalDevice: totalRms,
          onlineDevice: onlineRms,
          offlineDevice: offlineRms,
          damageDevice: damageRms,
          pieData: {
            'ONLINE': onlineRms!.toDouble(),
            'OFFLINE': offlineRms!.toDouble(),
            'DAMAGE': damageRms!.toDouble(),
          }));
    } catch (_) {}
    try {
      // ignore: unnecessary_new
      pieData!.add(new PieChartModel(
          title: 'LORA',
          index: 4,
          totalDevice: noOfLoRaGateway,
          damageDevice: damageLoRaGateway,
          pieData: {
            'TOTAL': noOfLoRaGateway!.toDouble(),
            'DAMAGE': damageLoRaGateway!.toDouble(),
          }));
    } catch (_) {}
    isExpanded = false;
  }
/*
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalOms'] = this.totalOms;
    data['OnlineOms'] = this.onlineOms;
    data['OfflineOms'] = this.offlineOms;
    data['DamageOms'] = this.damageOms;
    data['TotalAms'] = this.totalAms;
    data['OnlineAms'] = this.onlineAms;
    data['OfflineAms'] = this.offlineAms;
    data['DamageAms'] = this.damageAms;
    data['NoOfPS'] = this.noOfPS;
    data['PS1Status'] = this.pS1Status;
    data['PS2Status'] = this.pS2Status;
    data['PS3Status'] = this.pS3Status;
    data['NoOfDC'] = this.noOfDC;
    data['DC1Status'] = this.dC1Status;
    data['DC2Status'] = this.dC2Status;
    data['ActiveAlarms'] = this.activeAlarms;
    return data;
  }
  */
}

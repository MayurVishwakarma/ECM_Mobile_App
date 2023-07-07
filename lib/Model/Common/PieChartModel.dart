class PieChartModel {
  String? title;
  int? index;
  int? totalDevice;
  int? onlineDevice;
  int? offlineDevice;
  int? damageDevice;
  Map<String, double>? pieData;
  PieChartModel(
      {this.title,
      this.index,
      this.totalDevice,
      this.onlineDevice,
      this.offlineDevice,
      this.damageDevice,
      this.pieData});
}

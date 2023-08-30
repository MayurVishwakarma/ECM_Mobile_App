// ignore_for_file: file_names

class MatetrialConsumption {
  int? sCount;
  int? rectificationId;
  int? cNT;
  String? rectification;
  String? type;
  int? total;
  int? electrical;
  int? tubing;
  int? mechanical;
  int? totalDevice;
  int? totalElectDevice;
  int? totalTubDevice;
  int? totalMechDevice;

  MatetrialConsumption(
      {this.sCount,
      this.rectificationId,
      this.cNT,
      this.rectification,
      this.type,
      this.total,
      this.electrical,
      this.tubing,
      this.mechanical,
      this.totalDevice,
      this.totalElectDevice,
      this.totalTubDevice,
      this.totalMechDevice});

  MatetrialConsumption.fromJson(Map<String, dynamic> json) {
    sCount = json['SCount'];
    rectificationId = json['RectificationId'];
    cNT = json['CNT'];
    rectification = json['Rectification'];
    type = json['Type'];
    total = json['Total'];
    electrical = json['Electrical'];
    tubing = json['Tubing'];
    mechanical = json['Mechanical'];
    totalDevice = json['TotalDevice'];
    totalElectDevice = json['TotalElectDevice'];
    totalTubDevice = json['TotalTubDevice'];
    totalMechDevice = json['TotalMechDevice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SCount'] = this.sCount;
    data['RectificationId'] = this.rectificationId;
    data['CNT'] = this.cNT;
    data['Rectification'] = this.rectification;
    data['Type'] = this.type;
    data['Total'] = this.total;
    data['Electrical'] = this.electrical;
    data['Tubing'] = this.tubing;
    data['Mechanical'] = this.mechanical;
    data['TotalDevice'] = this.totalDevice;
    data['TotalElectDevice'] = this.totalElectDevice;
    data['TotalTubDevice'] = this.totalTubDevice;
    data['TotalMechDevice'] = this.totalMechDevice;
    return data;
  }
}

class InformationMasterModel {

  int? infoId;
  int? cNT;
  String? infoDescription;
  String? type;
  int? total;
  int? totalDevice;

  InformationMasterModel(
      {this.infoId,
      this.cNT,
      this.infoDescription,
      this.type,
      this.total,
      this.totalDevice});

  InformationMasterModel.fromJson(Map<String, dynamic> json) {
    infoId = json['InfoId'];
    cNT = json['CNT'];
    infoDescription = json['InfoDescription'];
    type = json['Type'];
    total = json['Total'];
    totalDevice = json['TotalDevice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InfoId'] = this.infoId;
    data['CNT'] = this.cNT;
    data['InfoDescription'] = this.infoDescription;
    data['Type'] = this.type;
    data['Total'] = this.total;
    data['TotalDevice'] = this.totalDevice;
    return data;
  }
}

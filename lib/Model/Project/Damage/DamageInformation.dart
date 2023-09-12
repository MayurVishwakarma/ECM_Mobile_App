class DamageInformationmodel {
  int? id;
  String? chakNo;
  String? areaName;
  String? description;
  String? reportedOn;
  int? reportedBy;
  String? username;
  String? remark;
  String? informationList;

  DamageInformationmodel(
      {this.id,
      this.chakNo,
      this.areaName,
      this.description,
      this.reportedOn,
      this.reportedBy,
      this.username,
      this.remark,
      this.informationList});

  DamageInformationmodel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    chakNo = json['ChakNo'];
    areaName = json['AreaName'];
    description = json['Description'];
    reportedOn = json['ReportedOn'];
    reportedBy = json['ReportedBy'];
    username = json['Username'];
    remark = json['Remark'];
    informationList = json['InformationList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ChakNo'] = this.chakNo;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['ReportedOn'] = this.reportedOn;
    data['ReportedBy'] = this.reportedBy;
    data['Username'] = this.username;
    data['Remark'] = this.remark;
    data['InformationList'] = this.informationList;
    return data;
  }
}

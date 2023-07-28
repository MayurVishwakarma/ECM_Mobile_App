class DamageDetailsCommon {
  int? omsId;
  String? chakNo;
  String? areaName;
  String? description;
  String? villageName;
  String? khasaranumber;
  String? firstname;
  int? electrical;
  int? mechanical;

  DamageDetailsCommon(
      {this.omsId,
      this.chakNo,
      this.areaName,
      this.description,
      this.villageName,
      this.khasaranumber,
      this.firstname,
      this.electrical,
      this.mechanical});

  DamageDetailsCommon.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    chakNo = json['ChakNo'];
    areaName = json['AreaName'];
    description = json['Description'];
    villageName = json['VillageName'];
    khasaranumber = json['Khasaranumber'];
    firstname = json['firstname'];
    electrical = json['Electrical'];
    mechanical = json['Mechanical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['ChakNo'] = this.chakNo;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['VillageName'] = this.villageName;
    data['Khasaranumber'] = this.khasaranumber;
    data['firstname'] = this.firstname;
    data['Electrical'] = this.electrical;
    data['Mechanical'] = this.mechanical;
    return data;
  }
}

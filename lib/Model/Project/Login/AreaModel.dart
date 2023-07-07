class AreaModel {
  int? areaid;
  int? projectId;
  String? areaCoordinates;
  String? areaName;

  AreaModel({this.areaid, this.projectId, this.areaCoordinates, this.areaName});

  AreaModel.fromJson(Map<String, dynamic> json) {
    areaid = json['Areaid'];
    projectId = json['ProjectId'];
    areaCoordinates = json['AreaCoordinates'];
    areaName = json['AreaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Areaid'] = this.areaid;
    data['ProjectId'] = this.projectId;
    data['AreaCoordinates'] = this.areaCoordinates;
    data['AreaName'] = this.areaName;
    return data;
  }
}

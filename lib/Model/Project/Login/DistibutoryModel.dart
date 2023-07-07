class DistibutroryModel {
  int? id;
  int? areaId;
  String? pipeLineName;
  String? description;
  int? parentId;
  String? coordinates;

  DistibutroryModel(
      {this.id,
      this.areaId,
      this.pipeLineName,
      this.description,
      this.parentId,
      this.coordinates});

  DistibutroryModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    areaId = json['areaId'];
    pipeLineName = json['PipeLineName'];
    description = json['Description'];
    parentId = json['ParentId'];
    coordinates = json['Coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['areaId'] = this.areaId;
    data['PipeLineName'] = this.pipeLineName;
    data['Description'] = this.description;
    data['ParentId'] = this.parentId;
    data['Coordinates'] = this.coordinates;
    return data;
  }
}

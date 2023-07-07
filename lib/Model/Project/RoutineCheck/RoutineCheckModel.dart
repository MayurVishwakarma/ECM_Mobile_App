class RoutineCheckMasterModel {
 
  int? omsId;
  String? chakNo;
  String? areaName;
  String? description;
  String? villageName;
  String? firstname;
  String? workedOn;
  int? routineStatus;
  String? nextScheduleDate;

  RoutineCheckMasterModel(
      {
      this.omsId,
      this.chakNo,
      this.areaName,
      this.description,
      this.villageName,
      this.firstname,
      this.workedOn,
      this.routineStatus,
      this.nextScheduleDate});

  RoutineCheckMasterModel.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    chakNo = json['ChakNo'];
    areaName = json['AreaName'];
    description = json['Description'];
    villageName = json['villageName'];
    firstname = json['firstname'];
    workedOn = json['WorkedOn'];
    routineStatus = json['RoutineStatus'];
    nextScheduleDate = json['NextScheduleDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['ChakNo'] = this.chakNo;
    data['AreaName'] = this.areaName;
    data['Description'] = this.description;
    data['villageName'] = this.villageName;
    data['firstname'] = this.firstname;
    data['WorkedOn'] = this.workedOn;
    data['RoutineStatus'] = this.routineStatus;
    data['NextScheduleDate'] = this.nextScheduleDate;
    return data;
  }
}

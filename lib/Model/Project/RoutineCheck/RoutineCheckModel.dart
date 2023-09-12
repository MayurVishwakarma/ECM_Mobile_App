class RoutineCheckMasterModel {
  int? omsId;
  int? gateWayId;
  dynamic chakNo;
  String? gateWayName;
  dynamic areaName;
  String? gateWayNo;
  dynamic description;
  dynamic villageName;
  dynamic firstname;
  String? workedOn;
  int? routineStatus;
  String? nextScheduleDate;
  String? amsCoordinate;

  RoutineCheckMasterModel(
      {this.omsId,
      this.gateWayId,
      this.chakNo,
      this.gateWayName,
      this.areaName,
      this.gateWayNo,
      this.description,
      this.villageName,
      this.firstname,
      this.workedOn,
      this.routineStatus,
      this.nextScheduleDate,
      this.amsCoordinate});

  RoutineCheckMasterModel.fromJson(Map<String, dynamic> json) {
    omsId = json['OmsId'];
    gateWayId = json['GateWayId'];
    chakNo = json['ChakNo'];
    gateWayName = json['GateWayName'];
    areaName = json['AreaName'];
    gateWayNo = json['GateWayNo'];
    description = json['Description'];
    villageName = json['villageName'];
    firstname = json['firstname'];
    workedOn = json['WorkedOn'];
    routineStatus = json['RoutineStatus'];
    nextScheduleDate = json['NextScheduleDate'];
    amsCoordinate = json['AmsCoordinate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OmsId'] = this.omsId;
    data['GateWayId'] = this.gateWayId;
    data['ChakNo'] = this.chakNo;
    data['GateWayName'] = this.gateWayName;
    data['AreaName'] = this.areaName;
    data['GateWayNo'] = this.gateWayNo;
    data['Description'] = this.description;
    data['villageName'] = this.villageName;
    data['firstname'] = this.firstname;
    data['WorkedOn'] = this.workedOn;
    data['RoutineStatus'] = this.routineStatus;
    data['NextScheduleDate'] = this.nextScheduleDate;
    data['AmsCoordinate'] = this.amsCoordinate;
    return data;
  }
}

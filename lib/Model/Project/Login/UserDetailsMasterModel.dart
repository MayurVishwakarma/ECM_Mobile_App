class UserDetailsMasterModel {

  int? attendanceId;
  String? attendanceStartTime;
  String? attendanceEndTime;
  String? startLocationCoordinate;
  String? endLocationCoordinate;
  String? workingHours;
  String? workingOnProjects;
  int? userId;
  String? attendanceDate;

  UserDetailsMasterModel(
      {this.attendanceId,
      this.attendanceStartTime,
      this.attendanceEndTime,
      this.startLocationCoordinate,
      this.endLocationCoordinate,
      this.workingHours,
      this.workingOnProjects,
      this.userId,
      this.attendanceDate});

  UserDetailsMasterModel.fromJson(Map<String, dynamic> json) {
    attendanceId = json['AttendanceId'];
    attendanceStartTime = json['AttendanceStartTime'];
    attendanceEndTime = json['AttendanceEndTime'];
    startLocationCoordinate = json['StartLocationCoordinate'];
    endLocationCoordinate = json['EndLocationCoordinate'];
    workingHours = json['WorkingHours'];
    workingOnProjects = json['WorkingOnProjects'];
    userId = json['UserId'];
    attendanceDate = json['AttendanceDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttendanceId'] = this.attendanceId;
    data['AttendanceStartTime'] = this.attendanceStartTime;
    data['AttendanceEndTime'] = this.attendanceEndTime;
    data['StartLocationCoordinate'] = this.startLocationCoordinate;
    data['EndLocationCoordinate'] = this.endLocationCoordinate;
    data['WorkingHours'] = this.workingHours;
    data['WorkingOnProjects'] = this.workingOnProjects;
    data['UserId'] = this.userId;
    data['AttendanceDate'] = this.attendanceDate;
    return data;
  }
}

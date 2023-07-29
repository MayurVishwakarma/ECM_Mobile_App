// ignore: file_names
class InfoModel {
  InfoModel({
    required this.id,
    required this.infoTypeName,
    required this.active,
    required this.infoDescription,
    required this.deviceId,
    required this.reportedBy,
    required this.reportedOn,
    required this.type,
    required this.value,
    required this.remark,
    required this.imageByteArray,
    required this.mTransId,
  });

  int? id;
  String? infoTypeName;
  String? active;
  String? infoDescription;
  int? deviceId;
  int? reportedBy;
  DateTime? reportedOn;
  String? type;
  String? value;
  String? remark;
  String? imageByteArray;
  int? mTransId;

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: json["Id"],
      infoTypeName: json["InfoTypeName"],
      active: json["Active"],
      infoDescription: json["InfoDescription"],
      deviceId: json["DeviceId"],
      reportedBy: json["ReportedBy"],
      reportedOn: DateTime.tryParse(json["ReportedOn"] ?? ""),
      type: json["Type"],
      value: json["Value"],
      remark: json["Remark"],
      imageByteArray: json["imageByteArray"],
      mTransId: json["MTransId"],
    );
  }
}

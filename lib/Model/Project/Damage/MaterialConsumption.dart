// ignore_for_file: file_names

class MaterialConsumptionModel {
  MaterialConsumptionModel({
    required this.id,
    required this.rectification,
    required this.deviceId,
    required this.reportedBy,
    required this.reportedOn,
    required this.type,
    required this.value,
    required this.remark,
    required this.imageByteArray,
    required this.mTransId,
  });

  final int? id;
  final String? rectification;
  final int? deviceId;
  final int? reportedBy;
  final DateTime? reportedOn;
  final String? type;
  String? value;
  final dynamic remark;
  final dynamic imageByteArray;
  final int? mTransId;

  factory MaterialConsumptionModel.fromJson(Map<String, dynamic> json) {
    return MaterialConsumptionModel(
      id: json["Id"],
      rectification: json["Rectification"],
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

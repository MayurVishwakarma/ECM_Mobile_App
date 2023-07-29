// ignore_for_file: file_names

class DamageHistory {
  DamageHistory({
    required this.id,
    required this.chakNo,
    required this.amsNo,
    required this.gatewayNo,
    required this.gatewayName,
    required this.rmsNo,
    required this.areaName,
    required this.description,
    required this.dateTime,
    required this.userId,
    required this.username,
    required this.remark,
    required this.electDamageList,
    required this.mechDamageList,
    required this.damageImageList,
    required this.imagePath,
    required this.images,
  });

  final int? id;
  final String? chakNo;
  final dynamic amsNo;
  final dynamic gatewayNo;
  final dynamic gatewayName;
  final dynamic rmsNo;
  final String? areaName;
  final String? description;
  final DateTime? dateTime;
  final int? userId;
  final String? username;
  final String? remark;
  final String? electDamageList;
  final String? mechDamageList;
  final String? damageImageList;
  final List<String> imagePath;
  final dynamic images;

  factory DamageHistory.fromJson(Map<String, dynamic> json) {
    return DamageHistory(
      id: json["Id"],
      chakNo: json["ChakNo"],
      amsNo: json["AmsNo"],
      gatewayNo: json["GatewayNo"],
      gatewayName: json["GatewayName"],
      rmsNo: json["RmsNo"],
      areaName: json["AreaName"],
      description: json["Description"],
      dateTime: DateTime.tryParse(json["DateTime"] ?? ""),
      userId: json["UserId"],
      username: json["Username"],
      remark: json["Remark"],
      electDamageList: json["ElectDamageList"],
      mechDamageList: json["MechDamageList"],
      damageImageList: json["DamageImageList"],
      imagePath: json["ImagePath"] == null
          ? []
          : List<String>.from(json["ImagePath"]!.map((x) => x)),
      images: json["Images"],
    );
  }
}

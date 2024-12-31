class ProjectsUserModel {
  int? userId;
  String? name;
  dynamic mobileNo;
  String? authority;

  ProjectsUserModel({this.userId, this.name, this.mobileNo, this.authority});

  ProjectsUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['Name'];
    mobileNo = json['mobileNo'];
    authority = json['Authority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['Name'] = this.name;
    data['mobileNo'] = this.mobileNo;
    data['Authority'] = this.authority;
    return data;
  }
}

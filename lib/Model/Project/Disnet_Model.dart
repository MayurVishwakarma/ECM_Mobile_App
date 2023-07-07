class SelfDiagnostic {
  String? issue;
  String? desc;
  String? category;
  List<int>? hoSupportId;

  SelfDiagnostic({
    this.issue,
    this.desc,
    this.category,
    this.hoSupportId,
  });

  factory SelfDiagnostic.fromJson(Map<String, dynamic> json) {
    return SelfDiagnostic(
      issue: json['Issue'],
      desc: json['Desc'],
      category: json['Category'],
      hoSupportId: List<int>.from(json['HOSupportId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Issue': issue,
      'Desc': desc,
      'Category': category,
      'HOSupportId': hoSupportId,
    };
  }
}
// class SelfDiagnostic {
//   String issue;
//   String desc;
//   String category;
//   List<int> hoSupportId;

//   SelfDiagnostic({
//     required this.issue,
//     required this.desc,
//     required this.category,
//     required this.hoSupportId,
//   });
// }

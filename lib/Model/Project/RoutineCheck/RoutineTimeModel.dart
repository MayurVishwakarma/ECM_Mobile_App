class RoutineTimeModel {
  String? status;
  Data? data;

  RoutineTimeModel({this.status, this.data});

  factory RoutineTimeModel.fromJson(Map<String, dynamic> json) {
    return RoutineTimeModel(
      status: json['Status'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  Response? response;
  String? status;
  dynamic message;

  Data({this.response, this.status, this.message});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      response:
          json['Response'] != null ? Response.fromJson(json['Response']) : null,
      status: json['Status'],
      message: json['Message'],
    );
  }
}

class Response {
  int? days;

  Response({this.days});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      days: json['Days'],
    );
  }
}

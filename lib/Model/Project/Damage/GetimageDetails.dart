// ignore_for_file: file_names, curly_braces_in_flow_control_structures, unnecessary_new

import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetImagePath {
  Uint8List? imageByteArray;

  GetImagePath({
    this.imageByteArray,
  });

  GetImagePath.fromJson(Map<String, dynamic> json) {
    if (json['imageByteArray'] != null)
      imageByteArray = base64.decode(json['imageByteArray']);
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = new Map<String, dynamic>();

    // ignore: unnecessary_this
    data['imageByteArray'] = this.imageByteArray;

    return data;
  }
}

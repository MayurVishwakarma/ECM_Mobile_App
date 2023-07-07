import 'dart:convert';
import 'dart:typed_data';

class ImageMasterModel {
  int? id;
  int? processId;
  String? imagePath;
  Uint8List? imageByteArray;
  String? fileType;

  ImageMasterModel(
      {this.id,
      this.processId,
      this.imagePath,
      this.imageByteArray,
      this.fileType});

  ImageMasterModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    processId = json['ProcessId'];
    imagePath = json['ImagePath'];
    if (json['imageByteArray'] != null) {
      imageByteArray = base64.decode(json['imageByteArray']);
    }
    fileType = json['FileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProcessId'] = this.processId;
    data['ImagePath'] = this.imagePath;
    data['imageByteArray'] = this.imageByteArray;
    data['FileType'] = this.fileType;
    return data;
  }
}

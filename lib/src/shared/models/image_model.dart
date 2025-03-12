class ImageModel {
  final int id;
  final int bodyPartID;
  final String bodyPart;
  final String description;
  final ImageData image;
  final DateTime createdAt;

  ImageModel({
    required this.id,
    required this.bodyPartID,
    required this.bodyPart,
    required this.description,
    required this.image,
    required this.createdAt,
  });
}

class ImageData {
  final String mime;
  final String data;

  ImageData({
    required this.mime,
    required this.data,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      mime: json['mime'],
      data: json['data'],
    );
  }
}
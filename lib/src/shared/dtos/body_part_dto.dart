class BodyPartResponseDTO {
  final int id;
  final String name;

  BodyPartResponseDTO({
    required this.id,
    required this.name,
  });

  factory BodyPartResponseDTO.fromJson(Map<String, dynamic> json) {
    return BodyPartResponseDTO(
      id: json['id'],
      name: json['name'],
    );
  }
}

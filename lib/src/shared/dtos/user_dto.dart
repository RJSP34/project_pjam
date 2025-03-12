class ProfileDTO {
  String name;
  String email;
  String roleDescription;
  DateTime createdAt;

  ProfileDTO({
    required this.name,
    required this.email,
    this.roleDescription = '',
    required this.createdAt,
  });

  factory ProfileDTO.fromJson(Map<String, dynamic> json) {
    return ProfileDTO(
      name: json['name'],
      email: json['email'],
      roleDescription: json['role_description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ClinicianDTO {
  int id;
  String name;
  String email;
  String profilePicture;

  ClinicianDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  factory ClinicianDTO.fromJson(Map<String, dynamic> json) {
    return ClinicianDTO(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
    );
  }
}

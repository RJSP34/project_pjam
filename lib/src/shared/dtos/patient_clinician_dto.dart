class PatientClinicianDTO {
  final int clinicianId;

  PatientClinicianDTO({required this.clinicianId});

  factory PatientClinicianDTO.fromJson(Map<String, dynamic> json) {
    return PatientClinicianDTO(clinicianId: json['clinician_id']);
  }
}

class AllowedClinicianDTO {
  final int clinicianId;

  AllowedClinicianDTO({required this.clinicianId});

  factory AllowedClinicianDTO.fromJson(Map<String, dynamic> json) {
    return AllowedClinicianDTO(clinicianId: json['clinician_id']);
  }
}

class AllowedPatientsClinicianDTO {
  final int clinicianId;
  final int patientId;
  final String patientName;
  final String patientEmail;

  AllowedPatientsClinicianDTO({
    required this.clinicianId,
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
  });

  factory AllowedPatientsClinicianDTO.fromJson(Map<String, dynamic> json) {
    return AllowedPatientsClinicianDTO(
      clinicianId: json['clinician_id'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      patientEmail: json['patient_email'],
    );
  }
}

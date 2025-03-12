class RegisterDTO {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterDTO({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

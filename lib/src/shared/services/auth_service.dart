import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _jwtToken;

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> setAuthToken(String token) async {
    _jwtToken = token;
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getAuthToken() async {
    if (_jwtToken != null) {
      return _jwtToken;
    }

    _jwtToken = await _secureStorage.read(key: 'jwt_token');
    return _jwtToken;
  }

  Future<void> clearAuthToken() async {
    _jwtToken = null;
    await _secureStorage.delete(key: 'jwt_token');
  }

  String getUserRole() {
    if (_jwtToken == null) {
      return "";
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_jwtToken!);
    return decodedToken["role"];
  }

  int getUserID() {
    if (_jwtToken == null) {
      return 0;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_jwtToken!);
    return int.parse(decodedToken["user_id"]);
  }

  Future<bool> isAuthTokenValid() async {
    String? token = await getAuthToken();
    if (token != null) {
      return !_isTokenExpired(token);
    }
    return false;
  }

  bool _isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}

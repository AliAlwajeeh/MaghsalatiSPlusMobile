// lib/models/auth/login_response.dart

class LoginResponse {
  final String token;
  final DateTime expiration;

  LoginResponse({required this.token, required this.expiration});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
    );
  }
}

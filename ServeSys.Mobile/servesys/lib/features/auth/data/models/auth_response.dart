class AuthResponseData {
  final String token;
  final String refreshToken;
  final DateTime expiration;
  final String? email;
  final String fullName;

  AuthResponseData({
    required this.token,
    required this.refreshToken,
    required this.expiration,
    this.email,
    required this.fullName,
  });

  factory AuthResponseData.fromJson(Map<String, dynamic> json) {
    return AuthResponseData(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      expiration: DateTime.parse(json['expiration'] as String).toUtc(),
      email: json['email'] as String?,
      fullName: json['fullName'] as String,
    );
  }
}

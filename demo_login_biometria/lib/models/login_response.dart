import 'package:demo_login_biometria/models/user_model.dart';

class LoginResponse {
  final String accessToken;
  final String expiresIn;
  final UserModel dataUser;

  LoginResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.dataUser,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? '',
      dataUser: UserModel.fromJson(json['data_user']),
    );
  }
}
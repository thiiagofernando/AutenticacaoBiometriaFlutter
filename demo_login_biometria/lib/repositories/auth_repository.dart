import 'package:dio/dio.dart';

import '../models/login_response.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://localhost.com.br/api',
  ));

  Future<LoginResponse> login(String cpf, String senha) async {
    try {
      final response = await _dio.post('/Tecnico/Login', data: {
        'cpf': cpf,
        'senha': senha,
      });

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Falha no login');
    }
  }
}
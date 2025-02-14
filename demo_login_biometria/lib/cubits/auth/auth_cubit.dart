import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/auth_repository.dart';
import '../../services/biometric_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final BiometricService _biometricService;
  int _biometricAttempts = 0;

  AuthCubit(this._repository, this._biometricService) : super(AuthInitial());


  Future<void> checkAndAuthenticateWithBiometric() async {
    if (await _biometricService.isBiometricAvailable() && 
        _biometricService.isBiometricEnabled()) {
      emit(AuthBiometricRequired());
    }
  }

  Future<void> authenticateWithBiometric() async {
    if (_biometricAttempts >= 3) {
      emit(AuthBiometricFailed());
      return;
    }

    final isAuthenticated = await _biometricService.authenticate();
    if (isAuthenticated) {
      final credentials = await _biometricService.getSavedCredentials();
      if (credentials != null) {
        await login(credentials['cpf']!, credentials['senha']!);
      } else {
        emit(AuthBiometricFailed());
      }
    } else {
      _biometricAttempts++;
      if (_biometricAttempts >= 3) {
        emit(AuthBiometricFailed());
      } else {
        emit(AuthBiometricRequired());
      }
    }
  }

  bool isBiometricEnabled() {
    return _biometricService.isBiometricEnabled();
  }

  Future<void> checkBiometric() async {
    if (await _biometricService.isBiometricAvailable() &&
        _biometricService.isBiometricEnabled()) {
      emit(AuthBiometricRequired());
    }
  }


  Future<void> login(String cpf, String senha) async {
    emit(AuthLoading());
    try {
      print('cpf $cpf');
      final response = await _repository.login(cpf, senha);
      emit(AuthSuccess(response));
    } catch (e) {
      print('Erro no login: $e');
      emit(AuthError('Falha no login'));
    }
  }

  Future<void> enableBiometric(String cpf, String senha) async {
    await _biometricService.enableBiometric(cpf, senha);
  }

  Future<void> disableBiometric() async {
    await _biometricService.disableBiometric();
  }
}

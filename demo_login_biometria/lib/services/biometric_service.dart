import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final SharedPreferences _prefs;

  BiometricService(this._prefs);

  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _userCredentialsKey = 'user_credentials';

  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics && 
             await _localAuth.isDeviceSupported();
    } catch (e) {
      print('Erro ao verificar disponibilidade biométrica: $e');
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Autentique para acessar o app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print('Erro na autenticação biométrica: $e');
      return false;
    }
  }

  Future<void> enableBiometric(String cpf, String senha) async {
    try {
      await _prefs.setBool(_biometricEnabledKey, true);
      await _prefs.setString(_userCredentialsKey, '$cpf|$senha');
      print('Biometria habilitada com sucesso');
    } catch (e) {
      print('Erro ao habilitar biometria: $e');
      throw Exception('Falha ao habilitar biometria');
    }
  }

  Future<void> disableBiometric() async {
    await _prefs.setBool(_biometricEnabledKey, false);
    await _prefs.remove(_userCredentialsKey);
  }

  bool isBiometricEnabled() {
    return _prefs.getBool(_biometricEnabledKey) ?? false;
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final credentials = _prefs.getString(_userCredentialsKey);
    if (credentials != null) {
      final parts = credentials.split('|');
      return {
        'cpf': parts[0],
        'senha': parts[1],
      };
    }
    return null;
  }
}
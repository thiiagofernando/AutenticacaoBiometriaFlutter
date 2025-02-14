import 'package:equatable/equatable.dart';

import '../../models/login_response.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthBiometricRequired extends AuthState {}
class AuthBiometricFailed extends AuthState {}
class AuthSuccess extends AuthState {
  final LoginResponse loginResponse;

  AuthSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
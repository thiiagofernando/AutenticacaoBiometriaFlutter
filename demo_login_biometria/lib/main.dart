import 'package:demo_login_biometria/repositories/auth_repository.dart';
import 'package:demo_login_biometria/screens/login_screen.dart';
import 'package:demo_login_biometria/services/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubits/auth/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final authRepository = AuthRepository();
  final biometricService = BiometricService(prefs);

  runApp(MyApp(
    authRepository: authRepository,
    biometricService: biometricService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final BiometricService biometricService;

  const MyApp({
    required this.authRepository,
    required this.biometricService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepository, biometricService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
import 'package:demo_login_biometria/cubits/auth/auth_cubit.dart';
import 'package:demo_login_biometria/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndAuthenticateBiometric();
    });
  }

  Future<void> _checkAndAuthenticateBiometric() async {
    final authCubit = context.read<AuthCubit>();
    await authCubit.checkAndAuthenticateWithBiometric();
  }

  void _showBiometricEnableDialog(String cpf, String senha) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar clicando fora
      builder: (context) => AlertDialog(
        title: const Text('Ativar Biometria'),
        content: const Text('Deseja realizar o próximo login usando biometria?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().enableBiometric(cpf, senha);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Verifica se a biometria já está habilitada antes de mostrar o diálogo
            if (!context.read<AuthCubit>().isBiometricEnabled()) {
              _showBiometricEnableDialog(_cpfController.text, _senhaController.text);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthBiometricFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Falha na autenticação biométrica. Por favor, use login e senha.')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthBiometricRequired) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AuthCubit>().authenticateWithBiometric();
            });
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Use sua biometria para entrar'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().authenticateWithBiometric();
                    },
                    child: const Text('Autenticar com Biometria'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthCubit>().login(
                                    _cpfController.text,
                                    _senhaController.text,
                                  );
                            }
                          },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text('Entrar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

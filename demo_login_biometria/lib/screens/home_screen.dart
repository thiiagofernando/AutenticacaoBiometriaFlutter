import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          final user = state.loginResponse.dataUser;

          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(user.nome),
                    accountEmail: Text('CPF: ${user.cpf}'),
                    currentAccountPicture: CircleAvatar(
                      child: Text(user.nome[0]),
                    ),
                  ),
                  ListTile(
                    title: Text('Sair'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: Text('Bem-vindo(a), ${user.nome}!'),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../widgets/logo_appbar.dart';
import '../interactor/bloc/auth_bloc.dart';
import '../interactor/states/auth_state.dart';
import 'widgets/login_form.dart';
import 'widgets/sign_up_form.dart';

class AuthPage extends StatelessWidget {
  final _authBloc = Modular.get<AuthBloc>();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar.generateLogoAppBar(context),
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          if (state is LoginState) {
            return const LoginForm();
          } else if (state is SignUpState) {
            return const SignUpForm();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

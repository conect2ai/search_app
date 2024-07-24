import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/themes/app_colors.dart';
import '../../../mixins/logo_appbar.dart';
import '../interactor/bloc/auth_bloc.dart';
import '../interactor/states/auth_state.dart';
import 'widgets/login_form.dart';
import 'widgets/sign_up_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with LogoAppBar {
  final _authBloc = Modular.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateLogoAppBar(
        context,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          if (state is LoginState) {
            return LoginForm(
                username: state.username, password: state.password);
          } else if (state is SignUpState) {
            return const SignUpForm();
          } else {
            return const SpinKitSpinningLines(
              size: 100,
              color: AppColors.mainColor,
            );
          }
        },
      ),
    );
  }
}

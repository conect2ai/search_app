import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../widgets/logo_appbar.dart';
import '../interactor/bloc/auth_bloc.dart';
import 'widgets/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth_bloc = Modular.get<AuthBloc>();

    return Scaffold(
        appBar: LogoAppBar.generateLogoAppBar(context), body: AuthForm());
  }
}

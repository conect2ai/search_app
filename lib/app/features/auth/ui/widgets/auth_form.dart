import 'package:app_search/app/features/auth/interactor/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/bloc/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _auth_bloc = Modular.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Email',
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your email';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your password';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            bloc: _auth_bloc,
            builder: (context, state) {
              if (state is LoginState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () => _auth_bloc.add(SwitchToSignUpEvent()),
                        child: const Text('Sign up'))
                  ],
                );
              } else {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Sign up'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () => _auth_bloc.add(SwitchToLoginEvent()),
                        child: const Text('Login'))
                  ],
                );
              }
            },
          )
        ],
      )),
    );
  }
}

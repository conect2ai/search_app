import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/bloc/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
          ),
          const SizedBox(
            height: 15,
          ),
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
      )),
    );
  }
}

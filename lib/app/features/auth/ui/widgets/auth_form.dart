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
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObscureText = true;

  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  @override
  void initState() {
    _passwordTextController.text = '';
    _emailTextController.text = '';
    _formData['email'] = _emailTextController.text;
    _formData['password'] = _passwordTextController.text;
    super.initState();
  }

  void _saveFormData() {
    _formData['email'] = _emailTextController.text;
    _formData['password'] = _passwordTextController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
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
              Stack(
                children: [
                  TextFormField(
                    obscureText: _isObscureText,
                    controller: _passwordTextController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert your password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Positioned(
                    right: 5,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscureText = !_isObscureText;
                          });
                        },
                        icon: Icon(
                          _isObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        )),
                  )
                ],
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveFormData();
                              _auth_bloc.Login(_formData);
                            }
                          },
                          child: const Text('Login'),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                            onPressed: () =>
                                _auth_bloc.add(SwitchToSignUpEvent()),
                            child: const Text('Sign up'))
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveFormData();
                              _auth_bloc.SignUp(_formData);
                            }
                          },
                          child: const Text('Sign up'),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                            onPressed: () =>
                                _auth_bloc.add(SwitchToLoginEvent()),
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

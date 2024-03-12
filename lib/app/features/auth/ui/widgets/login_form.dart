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
  final _authBloc = Modular.get<AuthBloc>();
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40, top: 20),
        child: SingleChildScrollView(
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
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _saveFormData();
                          final isLogged = await _authBloc.Login(_formData);
                          if (isLogged) {
                            Modular.to.navigate('/home/');
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () => _authBloc.add(SwitchToSignUpEvent()),
                        child: const Text('Sign up'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

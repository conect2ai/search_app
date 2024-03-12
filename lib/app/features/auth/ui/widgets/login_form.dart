import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/bloc/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';

class LoginForm extends StatefulWidget {
  final String? username;
  final String? password;
  const LoginForm({this.username, this.password, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _authBloc = Modular.get<AuthBloc>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObscureText = true;
  final _passwordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  final _passwordTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  @override
  void initState() {
    _passwordTextController.text = widget.password ?? '';
    _usernameTextController.text = widget.username ?? '';
    _formData['username'] = _usernameTextController.text;
    _formData['password'] = _passwordTextController.text;
    super.initState();
  }

  void _saveFormData() {
    _formData['username'] = _usernameTextController.text;
    _formData['password'] = _passwordTextController.text;
  }

  void _unfocusAllTextFields() {
    if (_passwordFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
    if (_usernameFocusNode.hasFocus) {
      _usernameFocusNode.unfocus();
    }
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
                  focusNode: _usernameFocusNode,
                  controller: _usernameTextController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert your username';
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
                      focusNode: _passwordFocusNode,
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
                        _unfocusAllTextFields();
                        if (_formKey.currentState!.validate()) {
                          _saveFormData();
                          final isLogged = await _authBloc.login(_formData);
                          if (isLogged) {
                            Modular.to.navigate('/home/');
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Credenciais inválidas!'),
                                  duration: Duration(milliseconds: 600),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () {
                          _unfocusAllTextFields();
                          _authBloc.add(SwitchToSignUpEvent(
                              username: _usernameTextController.text,
                              password: _passwordTextController.text));
                        },
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

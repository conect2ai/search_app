import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../interactor/bloc/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';

enum Roles {
  admin,
  motorista,
}

class SignUpForm extends StatefulWidget {
  final String? username;
  final String? password;

  const SignUpForm({this.username, this.password, super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _authBloc = Modular.get<AuthBloc>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObscureText = true;
  Roles _selectedRole = Roles.motorista;
  final _passwordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  @override
  void initState() {
    _passwordTextController.text = widget.password ?? '';
    _emailTextController.text = '';
    _usernameTextController.text = widget.username ?? '';
    _selectedRole = Roles.motorista;
    _formData['email'] = _emailTextController.text;
    _formData['password'] = _passwordTextController.text;
    _formData['username'] = _usernameTextController.text;
    _formData['role'] = '';
    super.initState();
  }

  void _saveFormData() {
    _formData['email'] = _emailTextController.text;
    _formData['password'] = _passwordTextController.text;
    _formData['username'] = _usernameTextController.text;
    _formData['role'] = _selectedRole.name.toUpperCase();
  }

  void _unfocusAllTextFields() {
    if (_passwordFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
    if (_usernameFocusNode.hasFocus) {
      _usernameFocusNode.unfocus();
    }
    if (_emailFocusNode.hasFocus) {
      _emailFocusNode.unfocus();
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
                TextFormField(
                  focusNode: _emailFocusNode,
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
                DropdownMenu(
                  textStyle:
                      const TextStyle(color: Colors.black54, fontSize: 14),
                  inputDecorationTheme: InputDecorationTheme(
                      isCollapsed: true,
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      floatingLabelAlignment: FloatingLabelAlignment.start),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                        value: Roles.motorista,
                        label: 'Motorista',
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black54)),
                    DropdownMenuEntry(
                        value: Roles.admin,
                        label: 'Admin',
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black54)),
                  ],
                  initialSelection: _selectedRole,
                  onSelected: (value) {
                    setState(() {
                      _selectedRole = value ?? Roles.motorista;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor),
                      onPressed: () async {
                        _unfocusAllTextFields();
                        if (_formKey.currentState!.validate()) {
                          _saveFormData();
                          final isSignedUp = await _authBloc.signUp(_formData);
                          if (mounted) {
                            if (isSignedUp) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Registro concluído com sucesso!'),
                                duration: Duration(milliseconds: 600),
                              ));
                              _authBloc.add(SwitchToLoginEvent());
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Falha no registro, tente novamente!'),
                                duration: Duration(milliseconds: 600),
                              ));
                            }
                          }
                        }
                      },
                      child: const Text('Sign up'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        _unfocusAllTextFields();
                        _authBloc.add(SwitchToLoginEvent(
                            username: _usernameTextController.text,
                            password: _passwordTextController.text));
                      },
                      child: const Text('Login'),
                    )
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

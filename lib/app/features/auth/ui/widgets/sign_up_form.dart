import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/bloc/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';

enum Roles {
  admin,
  motorista,
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _authBloc = Modular.get<AuthBloc>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObscureText = true;
  Roles _selectedRole = Roles.motorista;

  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  @override
  void initState() {
    _passwordTextController.text = '';
    _emailTextController.text = '';
    _usernameTextController.text = '';
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _saveFormData();
                          final isLogged = await _authBloc.SignUp(_formData);
                          if (isLogged) {
                            Modular.to.navigate('/home/');
                          }
                        }
                      },
                      child: const Text('Sign up'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () => _authBloc.add(SwitchToLoginEvent()),
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

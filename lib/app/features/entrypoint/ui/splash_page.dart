import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/themes/app_colors.dart';
import '../interactor/bloc/splash_page_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _bloc = Modular.get<SplashPageBloc>();
  @override
  void initState() {
    _bloc.loadUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            color: AppColors.mainColor,
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }
}

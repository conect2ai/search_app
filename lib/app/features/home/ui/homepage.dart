import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/themes/app_colors.dart';
import '../../../mixins/logo_appbar.dart';
import '../interactor/bloc/homepage_bloc.dart';
import '../interactor/states/homepage_states.dart';
import 'widgets/api_key_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with LogoAppBar {
  final _homePageBloc = Modular.get<HomePageBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateLogoAppBar(
        context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          bloc: _homePageBloc,
          builder: (context, state) {
            if (state is InputApiKeyState) {
              return ApiKeyInput(
                homebloc: _homePageBloc,
              );
            } else {
              return const SpinKitSpinningLines(
                size: 100,
                color: AppColors.mainColor,
              );
            }
          },
        ),
      ),
    );
  }
}

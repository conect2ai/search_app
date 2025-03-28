import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../mixins/logo_appbar.dart';

class MenuPage extends StatelessWidget with LogoAppBar {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateLogoAppBar(context),
      body: Center(
        child: GridView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10),
          children: [
            GestureDetector(
              onTap: () => Modular.to.pushReplacementNamed('/chat/'),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.menuScreenIconContainerColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded,
                          color: Colors.white, size: 50),
                      Text('Manual', style: AppTextStyles.mainTextStyle),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Modular.to.pushNamed('/report-problem/'),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.menuScreenIconContainerColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.report_problem_rounded,
                          color: Colors.white, size: 50),
                      Text('Report Problem',
                          style: AppTextStyles.mainTextStyle),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../../mixins/logo_appbar.dart';
import 'widgets/manual_upload_widget.dart';

class ManualCheckPage extends StatefulWidget {
  const ManualCheckPage({super.key});

  @override
  State<ManualCheckPage> createState() => _ManualCheckPageState();
}

class _ManualCheckPageState extends State<ManualCheckPage> with LogoAppBar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateLogoAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 270,
              child: Text(
                'Nenhum dado disponível.Por favor, selecione um PDF para realizar consultas!',
                style: AppTextStyles.manualCheckTextField,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const ManualUploadWidget(),
          ],
        ),
      ),
    );
  }
}

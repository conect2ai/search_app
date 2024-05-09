import 'package:flutter/material.dart';

import '../core/themes/app_text_styles.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final String buttonMessage;
  const CustomDialog(
      {required this.message, required this.buttonMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.8)),
        height: 350,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Text(
                  message,
                  style: AppTextStyles.dialogTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  buttonMessage,
                  style: AppTextStyles.dialogTextButtonStyle,
                ))
          ],
        ),
      ),
    );
  }
}

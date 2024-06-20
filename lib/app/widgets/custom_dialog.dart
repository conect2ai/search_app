import 'package:flutter/material.dart';

import '../core/themes/app_text_styles.dart';

class CustomDialog extends StatelessWidget {
  final String _message;
  final String _buttonMessage;
  const CustomDialog(
      {String message = '', String buttonMessage = '', super.key})
      : _message = message,
        _buttonMessage = buttonMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        height: 250,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: 200,
                child: Text(
                  _message,
                  style: AppTextStyles.dialogTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  _buttonMessage,
                  style: AppTextStyles.dialogTextButtonStyle,
                ))
          ],
        ),
      ),
    );
  }
}

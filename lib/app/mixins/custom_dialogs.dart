import 'package:flutter/material.dart';

import '../core/themes/app_text_styles.dart';

mixin CustomDialogs {
  void dialog(BuildContext context, Widget content) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: content,
        );
      },
    );
  }

  Widget dialogWithButtons(
      {required String title,
      required Widget content,
      required List<String> actions,
      required ValueChanged<int> callBack}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: AppTextStyles.dialogTextStyle,
            ),
          ),
          const Divider(
            height: 20,
            thickness: 2,
          ),
          content,
          const Divider(
            height: 20,
            thickness: 2,
          ),
          _buildActionButtons(actions, callBack)
        ],
      ),
    );
  }

  Widget _buildActionButtons(List<String> actions, ValueChanged<int> callBack) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
          spacing: 30,
          children: List.generate(
              actions.length,
              (index) => TextButton(
                  onPressed: () => callBack(index),
                  child: Text(
                    actions[index],
                    style: AppTextStyles.dialogTextButtonStyle,
                  )))),
    );
  }
}

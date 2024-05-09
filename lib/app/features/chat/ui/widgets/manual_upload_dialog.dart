import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../mixins/custom_dialogs.dart';

class ManualUploadDialog extends StatefulWidget {
  const ManualUploadDialog({super.key});

  @override
  State<ManualUploadDialog> createState() => _ManualUploadDialogState();
}

class _ManualUploadDialogState extends State<ManualUploadDialog>
    with CustomDialogs {
  bool _isManualSelected = false;
  late String _selectedManual;

  @override
  void initState() {
    _selectedManual = 'Selecione o manual';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Manual Upload',
        content: _buildManualUploadField(),
        actions: ['Cancel', 'Upload'],
        callBack: onTapActions);
  }

  Widget _buildManualUploadField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextButton(
                onPressed: () {
                  setState(() {
                    _isManualSelected = true;
                    _selectedManual = 'Meu manual';
                  });
                },
                child: Text(
                  _selectedManual,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          Visibility(
              visible: _isManualSelected,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isManualSelected = false;
                    _selectedManual = 'Selecione o manual';
                  });
                },
                icon: const Icon(
                  Icons.cancel,
                ),
                iconSize: 20,
              ))
        ],
      ),
    );
  }

  void onTapActions(int index) {
    switch (index) {
      case 0:
        Modular.to.pop();
        break;
      case 1:
        _isManualSelected ? print('Upload realizado com sucesso!') : null;
        // Modular.to.pop();
        break;
      default:
    }
  }
}

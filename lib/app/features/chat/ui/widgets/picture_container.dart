import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureContainer extends StatefulWidget {
  final XFile? _file;

  const PictureContainer({file, super.key}) : _file = file;

  @override
  State<PictureContainer> createState() => _PictureContainerState();
}

class _PictureContainerState extends State<PictureContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
      ),
      width: 200,
      height: 200,
      child: widget._file != null
          ? Image.file(
              File(widget._file!.path),
              fit: BoxFit.fill,
              width: 194,
              height: 194,
            )
          : const Text(
              'Tirar foto',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
    );
  }
}

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/themes/app_colors.dart';
import '../widgets/camera_page_text_input.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> _cameras;
  const CameraPage(this._cameras, {super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  XFile? _picture;
  File? _pictureFile;
  bool _isCameraPaused = false;
  var _selectedFlashMode = FlashMode.off;
  int _indexFlash = 0;

  List<FlashMode> _flashModes = [
    FlashMode.off,
    FlashMode.torch,
    FlashMode.auto,
  ];

  @override
  void initState() {
    _controller = CameraController(widget._cameras[0], ResolutionPreset.max);
    _initializeController();
    _controller.setFlashMode(_selectedFlashMode);
    super.initState();
  }

  void _initializeController() {
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void _toggleFlashMode() {
    setState(() {
      _indexFlash++;
      if (_indexFlash > 2) {
        _indexFlash = 0;
      }
      _selectedFlashMode = _flashModes[_indexFlash];
      _controller.setFlashMode(_selectedFlashMode);
    });
  }

  @override
  void dispose() {
    _controller.setFlashMode(FlashMode.off);
    _indexFlash = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CameraPreview(
            _controller,
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: IconButton(
                iconSize: 20,
                onPressed: () {
                  if (_isCameraPaused) {
                    setState(() {
                      _isCameraPaused = false;
                      _picture = null;
                      _pictureFile = null;
                    });
                    _controller.resumePreview();
                  } else {
                    Modular.to.pop();
                  }
                },
                icon: Icon(
                  _isCameraPaused ? Icons.close : Icons.arrow_back_ios_rounded,
                  color: AppColors.backgroundColor,
                )),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.4,
          right: 20,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: IconButton(
                iconSize: 20,
                onPressed: () {
                  if (!_isCameraPaused) {
                    _toggleFlashMode();
                  }
                },
                icon: Icon(
                  _selectedFlashMode == FlashMode.off
                      ? Icons.flash_off_outlined
                      : _selectedFlashMode == FlashMode.torch
                          ? Icons.flash_on_outlined
                          : Icons.flash_auto_outlined,
                  color: AppColors.backgroundColor,
                )),
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 20,
          child: Visibility(
            visible: _picture != null,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                height: 50,
                child: CameraPageTextInput(_pictureFile)),
          ),
        )
      ]),
      floatingActionButton: _pictureFile != null
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.mainColor,
              onPressed: () async {
                _picture = await _controller.takePicture();
                final dir = await getApplicationCacheDirectory();
                final path = dir.path;
                _pictureFile = File('$path/${_picture?.name}');
                _controller.pausePreview();
                setState(() {
                  _isCameraPaused = true;
                });
                final pdfData = await _picture!.readAsBytes();
                await _pictureFile?.writeAsBytes(pdfData);
              },
              child: const Icon(
                Icons.camera_alt,
                size: 30,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

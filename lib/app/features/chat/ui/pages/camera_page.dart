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
  bool _isFlashOn = false;

  @override
  void initState() {
    _controller = CameraController(widget._cameras[0], ResolutionPreset.max);
    _initializeController();
    _controller.setFlashMode(FlashMode.off);
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

  void _takePicture() async {
    if (_isFlashOn) {
      await _controller.setFlashMode(FlashMode.torch);
    } else {
      await _controller.setFlashMode(FlashMode.off);
    }

    _picture = await _controller.takePicture();

    final dir = await getApplicationCacheDirectory();
    final path = dir.path;
    _pictureFile = File('$path/${_picture?.name}');
    setState(() {
      _isCameraPaused = true;
    });
    _controller.pausePreview();
    final pdfData = await _picture!.readAsBytes();
    await _pictureFile?.writeAsBytes(pdfData);
  }

  void _toggleFlashMode() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _updateFlashMode();
    });
  }

  void _updateFlashMode([bool isDisposing = false]) async {
    if (isDisposing) {
      _isCameraPaused ? await _controller.resumePreview() : null;

      await _controller.setFlashMode(FlashMode.off);
    } else {
      await _controller
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    }
  }

  @override
  void dispose() {
    _updateFlashMode(true);
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
                    _updateFlashMode();
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
                  !_isFlashOn
                      ? Icons.flash_off_outlined
                      : Icons.flash_on_outlined,
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
              onPressed: () {
                _takePicture();
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

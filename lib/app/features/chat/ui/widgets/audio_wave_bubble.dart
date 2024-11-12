import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class WaveBubble extends StatefulWidget {
  final String path;
  const WaveBubble({required this.path, super.key});

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late PlayerController _playerController;
  int duration = 0;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  @override
  void initState() {
    _playerController = PlayerController();
    _preparePlayer();
    _playerStateSubscription =
        _playerController.onPlayerStateChanged.listen((playerState) async {
      if (playerState.isPaused) {
        setState(() {});
      } else if (playerState.isStopped) {
        _refreshPlayer();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  void _preparePlayer() async {
    await _playerController.preparePlayer(
      path: widget.path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
  }

  void _startOrPausePlayer() async {
    if (_playerController.playerState.isPlaying) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer(finishMode: FinishMode.pause);
    }
    setState(() {});
  }

  void _refreshPlayer() async {
    _preparePlayer();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _startOrPausePlayer,
            icon: Icon(
              _playerController.playerState.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width * 0.5, 40),
              playerController: _playerController,
              backgroundColor: AppColors.mainColor,
              waveformType: WaveformType.long,
              playerWaveStyle: const PlayerWaveStyle(
                showSeekLine: true,
                spacing: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

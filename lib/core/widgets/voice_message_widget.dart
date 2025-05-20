import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class VoicePlayer extends StatefulWidget {
  final File audioFile;

  const VoicePlayer({Key? key, required this.audioFile}) : super(key: key);

  @override
  _VoicePlayerState createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  late PlayerController _playerController;

  @override
  void initState() {
    super.initState();

    _playerController = PlayerController();
    _initializePlayer();
  }

  void _initializePlayer() async {
    String path = widget.audioFile.path;
    await _playerController.preparePlayer(path: path);

    _playerController.onCompletion.listen((_) async {
      await _playerController.stopPlayer();
      _playerController.seekTo(0);
      setState(() {});
    });
  }

  void _togglePlayback() async {
    if (_playerController.playerState == PlayerState.playing) {
      await _playerController.stopPlayer();
    } else {
      if (_playerController.playerState == PlayerState.stopped) {
        await _playerController.preparePlayer(path: widget.audioFile.path);
      }

      await _playerController.startPlayer().then((value) {
        setState(() {});
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AudioFileWaveforms(
          playerController: _playerController,
          size: Size(MediaQuery.of(context).size.width - 60, 50),
          playerWaveStyle: PlayerWaveStyle(
            spacing: 4,
            waveCap: StrokeCap.round,
            liveWaveColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        IconButton(
          icon: Icon(_playerController.playerState == PlayerState.playing
              ? Icons.pause
              : Icons.play_arrow),
          onPressed: _togglePlayback,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _playerController.stopPlayer();
    _playerController.dispose();
    super.dispose();
  }
}

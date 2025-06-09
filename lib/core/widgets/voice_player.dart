import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class VoicePlayer extends StatefulWidget {
  final File audioFile;
  final void Function()? onClosePressed;
  final double width;
  final double height;

  const VoicePlayer(
      {super.key,
      required this.audioFile,
      this.onClosePressed,
      required this.width,
      required this.height});

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
    return Container(
      padding: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.onClosePressed != null)
            IconButton(
              onPressed: widget.onClosePressed,
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          AudioFileWaveforms(
            playerController: _playerController,
            size: Size(widget.width, widget.height),
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: PlayerWaveStyle(
              seekLineThickness: 3,
              waveThickness: 5,
              spacing: 6,
              waveCap: StrokeCap.round,
              liveWaveColor: Theme.of(context).colorScheme.primary,
              scaleFactor: 120,
            ),
          ),
          IconButton(
            icon: Icon(
              _playerController.playerState == PlayerState.playing
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 40,
            ),
            onPressed: _togglePlayback,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _playerController.stopPlayer();
    _playerController.dispose();
    super.dispose();
  }
}

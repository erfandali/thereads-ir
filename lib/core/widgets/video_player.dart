import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPlayer extends StatefulWidget {
  final File videoFile;

  const VideoPreviewPlayer({Key? key, required this.videoFile})
      : super(key: key);

  @override
  State<VideoPreviewPlayer> createState() => _VideoPreviewPlayerState();
}

class _VideoPreviewPlayerState extends State<VideoPreviewPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      final isPlaying = _controller.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? LayoutBuilder(builder: (context, constrants) {
            final aspectratio = _controller.value.aspectRatio;
            final width = MediaQuery.of(context).size.width;
            final height = width / (aspectratio - 1);
            print(aspectratio);
            print(width);
            print(height);
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: VideoPlayer(_controller),
                ),
                /* Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        
                      });
                    },
                  ),
                ), */
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 60,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
            );
          })
        : Center(
            child: CircularProgressIndicator());
  }
}

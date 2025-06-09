import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPlayer extends StatefulWidget {
  final File videoFile;
  final double maxHeight;
  final void Function()? onClosePressed;

  const VideoPreviewPlayer({
    super.key,
    required this.videoFile,
    required this.maxHeight,
    this.onClosePressed,
  });

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
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LayoutBuilder(builder: (context, constraints) {
              final aspectRatio = _controller.value.aspectRatio;
              final availableWidth = constraints.maxWidth;

              // Calculate the ideal height based on the full width and aspect ratio
              final idealHeight = availableWidth / aspectRatio;

              // Determine the actual height to use, respecting the maxHeight
              final actualHeight = idealHeight > widget.maxHeight
                  ? widget.maxHeight
                  : idealHeight;

              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: availableWidth,
                    height: actualHeight,
                    child: FittedBox(
                      fit: BoxFit.contain, // Or other BoxFit options as needed
                      child: SizedBox(
                        width:
                            availableWidth, // Intrinsic width (will be scaled)
                        height:
                            idealHeight, // Intrinsic height based on full width
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
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
                  if (widget.onClosePressed != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.black45),
                        onPressed: widget.onClosePressed,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              );
            }),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

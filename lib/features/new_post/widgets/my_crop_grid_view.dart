import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

class MyCropGridView extends StatelessWidget {
  const MyCropGridView(
      {super.key, required this.controller, required this.maxHeight});

  final VideoEditorController controller;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = controller.video.value.aspectRatio;
        final availableWidth = constraints.maxWidth;

        // Calculate the ideal height based on the full width and aspect ratio
        final idealHeight = availableWidth / aspectRatio;

        // Determine the actual height to use, respecting the maxHeight
        final actualHeight = idealHeight > maxHeight ? maxHeight : idealHeight;

        return SizedBox(
          width: availableWidth,
          height: actualHeight,
          child: FittedBox(
            fit: BoxFit.contain, // Or other BoxFit options as needed
            child: SizedBox(
              width: availableWidth, // Intrinsic width (will be scaled)
              height: idealHeight, // Intrinsic height based on full width
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CropGridViewer.preview(controller: controller),
                  AnimatedBuilder(
                    animation: controller.video,
                    builder: (_, __) => AnimatedOpacity(
                      opacity: controller.isPlaying ? 0 : 1,
                      duration: kThemeAnimationDuration,
                      child: GestureDetector(
                        onTap: controller.video.play,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

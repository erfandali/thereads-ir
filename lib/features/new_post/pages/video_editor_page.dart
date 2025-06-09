import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:threads/features/new_post/pages/crop_video_page.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

import '../../../core/models/my_aspect_ratio.dart';

import '../../../core/services/export_service.dart';
import '../widgets/aspect_ratio_container.dart';
import '../widgets/my_crop_grid_view.dart';

class VideoEditorPage extends StatefulWidget {
  const VideoEditorPage({
    super.key,
    required this.video,
    required this.onVideoEdited,
  });

  final File video;
  final Function(File video) onVideoEdited;

  @override
  State<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
/* 
  late final VideoEditorController widget.controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 10),
  ); */

  late final VideoPlayerController videoPlayerController;
  late VideoEditorController _videoEditController;

  @override
  void initState() {
    super.initState();

    _videoEditController = VideoEditorController.file(
      widget.video,
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 100),
    );

    videoPlayerController = VideoPlayerController.file(widget.video);

    videoPlayerController.initialize().then((_) {
      final duration = videoPlayerController.value.duration;

      if (duration > Duration.zero) {
        _videoEditController = VideoEditorController.file(
          widget.video,
          minDuration: const Duration(seconds: 1),
          maxDuration: duration,
        );

        _videoEditController.initialize().then((_) {
          setState(() {});
        });
      } else {}
    }).catchError((e) {});
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _isExporting.dispose();
    videoPlayerController.dispose();

    super.dispose();
  }

  Future<File?> applyCropVideo(
      File inputVideo, double width, double height, double x, double y) async {
    final directory = await getTemporaryDirectory();
    final outputPath = '${directory.path}/cropped_video.mp4';

    // FFmpeg crop command
    String command =
        '-i ${inputVideo.path} -vf "crop=${width.toInt()}:${height.toInt()}:${x.toInt()}:${y.toInt()}" -c:a copy $outputPath';

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      final failStackTrace = await session.getFailStackTrace();
      print('returnCode: $returnCode');
      print('Fail stack trace: $failStackTrace');

      if (returnCode != null && returnCode.isValueSuccess()) {
        print("Video successfully cropped!");
        return File(outputPath);
      } else {
        print("FFmpeg failed! Stack trace: $failStackTrace");
        return null;
      }
    });

    return null;
  }

  void _exportVideo() async {
    final config = VideoFFmpegVideoEditorConfig(_videoEditController);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Wrap(
          children: [
            Text(
                'در حال تغییر سایز ویدیو. ${_videoEditController.videoDuration.inSeconds > 20 ? 'ممکن است کمی زمان ببرد' : ''}...'),
          ],
        ),
        duration: Duration(seconds: 1000),
      ),
    );

    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        _exportingProgress.value =
            config.getFFmpegProgress(stats.getTime().toInt());
      },
      onError: (e, s) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.of(context).push(
          ModalBottomSheetRoute(
            enableDrag: true,
            showDragHandle: true,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('error:\n${e.toString()} \n\n stacktrace:\n$s'),
              ),
            ),
            isScrollControlled: true,
          ),
        );
        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error:\n${e.toString()} \n\n stacktrace:\n$s'),
            duration: Duration(seconds: 5),
          ),
        ); */
      },
      onCompleted: (file) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _isExporting.value = false;
        if (!mounted) return;

        widget.onVideoEdited(file);

        Navigator.of(context).pop();
      },
    );
  }

  MyAspectRatio? selectedAspecRatio;

  void _onAspectRatioSelected(MyAspectRatio aspectRatio) async {
    _videoEditController.preferredCropAspectRatio = aspectRatio.ratio;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CropVideoPage(
          controller: _videoEditController,
          onDone: () {
            print(_videoEditController.cacheMaxCrop);
            print(_videoEditController.cacheMinCrop);
            _videoEditController.applyCacheCrop();

            setState(() {
              selectedAspecRatio = aspectRatio;
            });
          },
          onCancle: () {
            if (selectedAspecRatio != null) {
              _videoEditController.preferredCropAspectRatio =
                  selectedAspecRatio!.ratio;
            }
          },
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _videoEditController.initialized
            ? SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    MyCropGridView(
                      controller: _videoEditController,
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'بوم',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                onPressed: _exportVideo,
                                icon: Icon(
                                  Icons.done_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 10,
                            children: [
                              const SizedBox(width: 10),
                              ...[
                                MyAspectRatio(xAspect: 1, yAspect: 1),
                                MyAspectRatio(xAspect: 9, yAspect: 16),
                                MyAspectRatio(xAspect: 16, yAspect: 9),
                                MyAspectRatio(xAspect: 4, yAspect: 5),
                              ].map(
                                (ar) => AspectRatioContainer(
                                  onTap: () => _onAspectRatioSelected(ar),
                                  aspectRatio: ar,
                                  selected: selectedAspecRatio == ar,
                                  icon: Icon(Icons.tiktok_rounded),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

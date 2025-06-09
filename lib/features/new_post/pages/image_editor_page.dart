import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../core/models/my_aspect_ratio.dart';

import '../widgets/aspect_ratio_container.dart';

class ImageEditorPage extends StatefulWidget {
  const ImageEditorPage({
    super.key,
    required this.image,
    required this.onImageEdited,
  });

  final File image;
  final Function(File image) onImageEdited;

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  MyAspectRatio? selectedAspecRatio;
  late File image;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<File?> cropImage(File file, MyAspectRatio aspectRatio) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(
          ratioX: aspectRatio.xAspect.toDouble(),
          ratioY: aspectRatio.yAspect.toDouble(),
        ),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'کراپ عکس',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  void _onAspectRatioSelected(MyAspectRatio aspectRatio) async {
    final cropped = await cropImage(widget.image, aspectRatio);

    if (cropped != null) {
      image = cropped;
      selectedAspecRatio = aspectRatio;

      setState(() {});
    }
  }

  void _exportImage() async {
    widget.onImageEdited(image);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Image.file(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
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
                          onPressed: _exportImage,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: SingleChildScrollView(
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
                              selected:
                                  selectedAspecRatio?.xAspect == ar.xAspect &&
                                      selectedAspecRatio?.yAspect == ar.yAspect,
                              icon: SizedBox.shrink(),
                              //icon: Icon(Icons.tiktok_rounded),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

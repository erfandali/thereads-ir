import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/models/my_aspect_ratio.dart';

import '../widgets/aspect_ratio_container.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}


class ImageEditorPage extends StatefulWidget {
  const ImageEditorPage({
    super.key,
    required this.image,
    required this.onImageEdited,
  });

  final File image;
  final Function(File imageCroped) onImageEdited;

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  MyAspectRatio? selectedAspecRatio;
  late File imageTempFile;
  bool isLoading = false;
  bool userCropImage=false;

  @override
  void initState() {
    super.initState();
    imageTempFile = widget.image;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<File?> _autoCropTo916(File imageFile) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not decode image")));
        setState(() { isLoading = false; });
        return null;
      }

      int originalWidth = originalImage.width;
      int originalHeight = originalImage.height;
      double targetAspectRatio = 9.0 / 16.0;

      int cropWidth;
      int cropHeight;

      // Determine the largest 9:16 rectangle that fits
      if (originalWidth / originalHeight > targetAspectRatio) {
        // Original is wider than target, so height is the limiting dimension
        cropHeight = originalHeight;
        cropWidth = (originalHeight * targetAspectRatio).round();
      } else {
        // Original is taller than or equal to target, so width is the limiting dimension
        cropWidth = originalWidth;
        cropHeight = (originalWidth / targetAspectRatio).round();
      }

      // Calculate top-left corner for center cropping
      int offsetX = ((originalWidth - cropWidth) / 2).round();
      int offsetY = ((originalHeight - cropHeight) / 2).round();

      img.Image croppedImage = img.copyCrop(
        originalImage,
        x: offsetX,
        y: offsetY,
        width: cropWidth,
        height: cropHeight,
      );

      //Save the cropped image to a temporary file
     final tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        await imageFile.delete();
      }catch(e){}
      final File tempFile = File('${tempDir.path}/cropped_$timestamp.jpg');
      await tempFile.writeAsBytes(img.encodeJpg(croppedImage, quality: 100));
      await Future.delayed(Duration(milliseconds: 300));
      return tempFile;
    } catch (e) {
      print("Error during auto-crop: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error auto-cropping: $e")));
      setState(() { isLoading = false; });
      return null;
    }
  }

  Future<File?> cropImage(File file, MyAspectRatio aspectRatio) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(
          ratioX: aspectRatio.xAspect.toDouble(),
          ratioY: aspectRatio.yAspect.toDouble(),
        ),
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'کراپ عکس',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'کراپ عکس',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
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
     
      setState(() {
        imageTempFile = cropped;
        selectedAspecRatio = aspectRatio;
        userCropImage=true;
      });
    }
  }

  void _exportImage() async {
    if (userCropImage)
      {
        widget.onImageEdited(imageTempFile);
      }else {
      setState(() {
        isLoading = true;
      });
      File? cropped916 = await _autoCropTo916(widget.image);
      if (cropped916 != null && cropped916.path.isNotEmpty){
      print("_exportImage = ${imageTempFile.path}");
      widget.onImageEdited(cropped916);
    }else{
        setState(() { isLoading = false; });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error auto-cropping, Please select other picture")));
      }
    }
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
                    imageTempFile,
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
                          icon:
                          ((isLoading)?
                          SizedBox(
                              width: 24,
                              height: 24,
                              child: const CircularProgressIndicator())
                              :
                          const Icon(Icons.done_rounded))
                          ,
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

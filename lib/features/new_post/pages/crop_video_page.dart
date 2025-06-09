import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart' /* as ve */;

class CropVideoPage extends StatelessWidget {
  const CropVideoPage(
      {super.key,
      required this.controller,
      required this.onDone,
      required this.onCancle});

  final VideoEditorController controller;
  final void Function() onDone;
  final void Function() onCancle;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              onCancle.call();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close_rounded),
          ),
          actions: [
            IconButton(
              onPressed: () {
                onDone.call();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.done_rounded),
            ),
          ],
        ),
        body: CropGridViewer.edit(
          controller: controller,
        ),
      ),
    );
  }
}

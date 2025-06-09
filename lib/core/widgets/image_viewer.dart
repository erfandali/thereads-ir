import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.image,
    this.onClosePressed,
  });

  final Image image;
  final void Function()? onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: image,
        ),
        if (onClosePressed != null)
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.black45),
            onPressed: onClosePressed,
            icon: Icon(
              Icons.close_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ),
      ],
    );
  }
}

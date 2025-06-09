import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/models/my_aspect_ratio.dart';

class AspectRatioContainer extends StatelessWidget {
  const AspectRatioContainer({
    super.key,
    required this.aspectRatio,
    required this.selected,
    this.onTap,
    required this.icon,
  });

  final MyAspectRatio aspectRatio;
  final bool selected;
  final Widget icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double baseSize = 120;
    double scaleFactor =
        baseSize / max(aspectRatio.xAspect, aspectRatio.yAspect);
    double width = aspectRatio.xAspect * scaleFactor;
    double height = aspectRatio.yAspect * scaleFactor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : const Color.fromARGB(255, 52, 52, 52),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    offset: Offset(3, 3),
                    blurRadius: 3,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    offset: Offset(-3, -3),
                    blurRadius: 3,
                    spreadRadius: 3,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
                '${aspectRatio.xAspect.toInt()}:${aspectRatio.yAspect.toInt()}'),
          ],
        ),
      ),
    );
  }
}

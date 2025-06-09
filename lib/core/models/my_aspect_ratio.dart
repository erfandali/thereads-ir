class MyAspectRatio {
  final double xAspect;
  final double yAspect;

  double get ratio => xAspect / yAspect;

  MyAspectRatio({required this.xAspect, required this.yAspect});

  @override
  bool operator ==(Object other) {
    if (other is! MyAspectRatio) {
      return false;
    }

    return xAspect == other.xAspect && yAspect == other.yAspect;
  }
}

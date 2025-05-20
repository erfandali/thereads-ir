import 'dart:io';

class Post {
  final File? selectedVideo;
  final File? selectedImage;
  final File? recordedAudio;

  Post(
      {required this.selectedVideo,
      required this.selectedImage,
      required this.recordedAudio});
}

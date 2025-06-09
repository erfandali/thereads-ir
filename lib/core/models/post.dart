import 'dart:io';
import 'package:threads/core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Post {
  int id;
  String? text;
  File? video;
  File? image;
  File? audio;
  DateTime createdAt;
  DateTime? editedAt;
  User user;
  List<String> emojies;

  Post._({
    required this.id,
    this.video,
    this.image,
    this.audio,
    required this.user,
    this.text,
    this.editedAt,
    required this.createdAt,
    this.emojies = const [],
  });

  // Factory constructor to asynchronously create a Post
  static Future<Post> fromUrl({
    String? text,
    String? imageUrl,
    String? videoUrl,
    String? audioUrl,
    required User user,
    DateTime? editedAt,
    required DateTime createdAt,
    List<String> emojies = const [],
  }) async {
    File? imageFile;
    File? videoFile;
    File? audioFile;

    // Download image if it's a URL
    if (imageUrl != null && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      imageFile = await _downloadFile(
          imageUrl, "${DateTime.now().millisecondsSinceEpoch}.jpg");
    } else if (imageUrl != null) {
      imageFile = File(imageUrl);
    }

    // Handle video & audio the same way
    if (videoUrl != null && Uri.tryParse(videoUrl)?.hasAbsolutePath == true) {
      videoFile = await _downloadFile(
          videoUrl, "${DateTime.now().millisecondsSinceEpoch}.mp4");
    } else if (videoUrl != null) {
      videoFile = File(videoUrl);
    }

    if (audioUrl != null && Uri.tryParse(audioUrl)?.hasAbsolutePath == true) {
      audioFile = await _downloadFile(
          audioUrl, "${DateTime.now().millisecondsSinceEpoch}.mp3");
    } else if (audioUrl != null) {
      audioFile = File(audioUrl);
    }

    return Post._(
      id: DateTime.now().microsecondsSinceEpoch,
      text: text,
      image: imageFile,
      video: videoFile,
      audio: audioFile,
      user: user,
      editedAt: editedAt,
      createdAt: createdAt,
      emojies: emojies,
    );
  }

  factory Post.fromFile({
    String? text,
    File? image,
    File? video,
    File? audio,
    required User user,
    DateTime? editedAt,
    required DateTime createdAt,
    List<String> emojies = const [],
  }) {
    return Post._(
      id: DateTime.now().microsecondsSinceEpoch,
      text: text,
      image: image,
      video: video,
      audio: audio,
      user: user,
      editedAt: editedAt,
      createdAt: createdAt,
      emojies: emojies,
    );
  }

  // Helper function to download a file
  static Future<File> _downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$filename';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } else {
      throw Exception("Failed to download file: $url");
    }
  }
}

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<File> downloadImage(String url, String filename) async {
    try {
      // Fetch image from URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get local storage directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$filename';

        // Save file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("Image saved at: $filePath");
        return file;
      } else {
        throw Exception("Failed to download image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading image: $e");
      return Future.error(e);
    }
  }
}

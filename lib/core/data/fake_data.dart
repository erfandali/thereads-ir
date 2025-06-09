import 'package:threads/core/models/user.dart';

import '../models/post.dart';

class FakeData {
  static User currentUser = User(
    username: 'Mahtaab',
    profilePicUrl: 'https://i.redd.it/5pi46xym7d281.jpg',
  );

  static List<Future<Post>> posts = [
    Post.fromUrl(
      user: FakeData.currentUser,
      emojies: ['😊', '😍', '👍', '😂', '🌟', '🔥', '💬'],
      text:
          'This portfolio is a collection of my digital and conceptual artworks, showcasing a blend of imagination, cinematic atmospheres, and visual storytelling.',
      imageUrl:
          'https://a.storyblok.com/f/178900/800x420/d8889e2cbf/the-guy-she-was-interested-in-wasnt-a-guy-at-all.jpg',
      createdAt: DateTime.now(),
    ),
    Post.fromUrl(
      user: FakeData.currentUser,
      emojies: ['😊', '😍', '👍', '😂', '🌟', '🔥', '💬'],
      text: 'This is a text-only post, without any image or voice.',
      createdAt: DateTime.now(),
    ),
    Post.fromUrl(
      user: FakeData.currentUser,
      emojies: ['😊', '😍', '👍', '😂', '🌟', '🔥', '💬'],
      text: 'This should be a post with voice',
      createdAt: DateTime.now(),
    ),
    Post.fromUrl(
      user: FakeData.currentUser,
      emojies: ['😊', '😍', '👍', '😂', '🌟', '🔥', '💬'],
      text: 'I WILL TATTOO THIS CLIP!',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      createdAt: DateTime.now(),
    )
  ];
}

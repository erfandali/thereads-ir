import 'package:edea/features/new_post/pages/new_post_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../widgets/emoji_bubble.dart';
import '../widgets/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Card Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PostCards(

                  username: 'Mahtaab',
                  time: '17:07',
                  postText:
                  'This portfolio is a collection of my digital and conceptual artworks, showcasing a blend of imagination, cinematic atmospheres, and visual storytelling.',
                  imageUrl:
                  'https://a.storyblok.com/f/178900/800x420/d8889e2cbf/the-guy-she-was-interested-in-wasnt-a-guy-at-all.jpg', // Replace with a real URL
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ], mypost: true,
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 10),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: 'This is a text-only post, without any image or voice.',
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ], mypost: false,
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 10),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: 'This should be a post with voice',
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],mypost: false,
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 10),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:10',
                  postText: 'I WILL TATTOO THIS CLIP!',
                  videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // Replace with a real URL
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],mypost: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmojiBubble extends StatelessWidget {
  final String emoji;

  const EmojiBubble({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white
      ),
    );
  }
}
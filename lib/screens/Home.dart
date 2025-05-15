import 'package:flutter/material.dart';

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
                PostCard(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText:
                  'This portfolio is a collection of my digital and conceptual artworks, showcasing a blend of imagination, cinematic atmospheres, and visual storytelling.',
                  isThisPicture: true,
                  imageUrl: 'assets/img/image.png',
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 20),
                PostCard(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: 'This is a text-only post, without any image or voice.',
                  isThisText: true,
                  isThisPicture: false,
                  isThisVoice: false,
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 20),
                PostCard(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: '',
                  isThisText: false,
                  isThisPicture: false,
                  isThisVoice: true,
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final String username;
  final String time;
  final String postText;
  final bool isThisPicture;
  final bool isThisVoice;
  final bool isThisText;
  final String? imageUrl;
  final String profilePicUrl;
  final List<Widget> emojis;

  const PostCard({
    super.key,
    required this.username,
    required this.time,
    required this.postText,
    this.isThisPicture = false,
    this.isThisVoice = false,
    this.isThisText = false,
    this.imageUrl,
    required this.profilePicUrl,
    required this.emojis,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(widget.profilePicUrl),
                radius: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.6),)
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          text: widget.postText,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          children: [
                            if (!isExpanded && widget.postText.length > 100)
                              const TextSpan(
                                text: " more...",
                                style: TextStyle(color: Colors.white60),
                              ),
                            if (isExpanded)
                              const TextSpan(
                                text: " less",
                                style: TextStyle(color: Colors.white38),
                              ),
                          ],
                        ),
                        maxLines: isExpanded || widget.postText.length <= 100 ? null : 2,
                        overflow: isExpanded || widget.postText.length <= 100
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (widget.isThisPicture && widget.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(widget.imageUrl!),
            ),

          if (widget.isThisVoice)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.voice_chat, color: Colors.white.withOpacity(0.6)),
                  SizedBox(width: 8),
                  Text(
                    "Voice Post",
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.open_in_full_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.emojis.map((emoji) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
                            child: emoji,
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 50,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class EmojiBubble extends StatelessWidget {
  final String emoji;

  const EmojiBubble({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 19),
    );
  }
}
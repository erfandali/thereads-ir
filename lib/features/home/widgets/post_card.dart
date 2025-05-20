import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostCards extends StatefulWidget {
  final String username;
  final String time;
  final String profilePicUrl;
  final bool mypost;

  final String? postText;
  final String? imageUrl;
  final String? voiceLabel;
  final String? videoUrl;

  final List<Widget> emojis;

  const PostCards({
    super.key,
    required this.username,
    required this.time,
    required this.profilePicUrl,
    required this.mypost,
    this.postText,
    this.imageUrl,
    this.voiceLabel,
    this.videoUrl,
    this.emojis = const [],
  });

  @override
  State<PostCards> createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  bool isExpanded = false;
  bool _isMuted = true;
  bool _isLiked = false;
  VideoPlayerController? _videoController;
  Duration? _currentPosition;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _videoController =
      VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
        ..initialize().then((_) {
          setState(() {});
        })
        ..setLooping(true)
        ..setVolume(0.0);

      _videoController!.addListener(() {
        setState(() {
          _currentPosition = _videoController!.value.position;
        });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleSound() {
    if (_videoController != null) {
      setState(() {
        _isMuted = !_isMuted;
        _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
      });
    }
  }

  void _toggleFullScreen() async {
    if (_videoController != null) {
      Duration currentPosition = _videoController!.value.position;
      _videoController!.pause();

      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPage(
            videoUrl: widget.videoUrl!,
            initialPosition: currentPosition,
          ),
        ),
      )
          .then((_) {
        if (mounted) {
          _videoController!.seekTo(
              FullScreenVideoPage.currentPosition ?? Duration.zero);
          _videoController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl ?? widget.imageUrl ?? widget.postText ?? "post"),
      onVisibilityChanged: (info) {
        if (_videoController != null) {
          if (info.visibleFraction > 0.5) {
            _videoController!.play();
          } else {
            _videoController!.pause();
          }
        }
      },
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profilePicUrl),
                  radius: 25,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.username,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),

                          SizedBox(
                            width: 10,
                          ),

                          Text(widget.time,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14)),
                        ],
                      ),


                      if (widget.postText != null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              text: widget.postText!,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                              children: [
                                if (!isExpanded && widget.postText!.length > 100)
                                  const TextSpan(
                                      text: " more...",
                                      style: TextStyle(color: Colors.white60)),
                                if (isExpanded)
                                  const TextSpan(
                                      text: " less",
                                      style: TextStyle(color: Colors.white38)),
                              ],
                            ),
                            maxLines:
                            isExpanded || widget.postText!.length <= 100 ? null : 2,
                            overflow: isExpanded || widget.postText!.length <= 100
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz,
                      color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
            const SizedBox(height: 5),



            if (widget.imageUrl != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl!,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Failed to load image',
                        style: TextStyle(color: Colors.white));
                  },
                ),
              ),
            ],

            if (widget.voiceLabel != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.voice_chat, color: Colors.white.withOpacity(0.6)),
                  const SizedBox(width: 8),
                  Text(widget.voiceLabel!,
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                ],
              ),
            ],

            if (_videoController != null &&
                _videoController!.value.isInitialized) ...[
              const SizedBox(height: 16),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: _toggleFullScreen,
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _toggleSound,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (widget.emojis.isNotEmpty) ...[
              const SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 30,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.open_in_full_outlined,
                                color: Colors.white, size: 15),
                          ),
                          Container(
                            height: 32,
                            width: 150,

                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: widget.emojis.map((emoji) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 7),
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
                                            Colors.black,
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
                  widget.mypost
                      ? InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text("ویرایش ادعا",
                          style: GoogleFonts.notoSansArabic(fontSize: 13, color: Colors.white)
                    ),
                  )
                  ): const SizedBox.shrink(),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : Colors.white,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenVideoPage extends StatelessWidget {
  final String videoUrl;
  final Duration initialPosition;
  static Duration? currentPosition;

  const FullScreenVideoPage({
    super.key,
    required this.videoUrl,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            controller.seekTo(initialPosition);
            controller.play();
            controller.addListener(() {
              currentPosition = controller.value.position;
            });

            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
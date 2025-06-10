import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:threads/core/extentions/date_time_extentions.dart';
import 'package:threads/core/widgets/voice_player.dart';
import 'package:threads/features/home/pages/home_page.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/models/post.dart';
import '../../new_post/pages/edit_post_page.dart';

class PostCards extends StatefulWidget {
  final Post post;
  final bool editable;

  const PostCards({
    super.key,
    required this.post,
    required this.editable,
  });

  @override
  State<PostCards> createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  bool isExpanded = false;
  bool _isMuted = true;
  /* bool _isLiked = false; */
  VideoPlayerController? _videoController;
  /* Duration? _currentPosition; */

  @override
  void initState() {
    super.initState();
    if (widget.post.video != null) {
      _videoController = VideoPlayerController.file(widget.post.video!)
        ..initialize().then((_) {
          setState(() {});
        })
        ..setLooping(true)
        ..setVolume(0.0);

      _videoController!.addListener(() {
        setState(() {
          /* _currentPosition = _videoController!.value.position; */
        });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  /* void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  } */

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
            video: widget.post.video!,
            initialPosition: currentPosition,
          ),
        ),
      )
          .then((_) {
        if (mounted) {
          _videoController!
              .seekTo(FullScreenVideoPage.currentPosition ?? Duration.zero);
          _videoController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: VisibilityDetector(
        key: Key(
          widget.post.video?.path ??
              widget.post.image?.path ??
              widget.post.text ??
              "post",
        ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.post.user.profilePicUrl),
                    radius: 25,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.post.user.username,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.post.createdAt.toTimeOnly(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (widget.post.text != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: RichText(
                                textDirection: TextDirection.rtl,
                                text: TextSpan(
                                  text: widget.post.text!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  children: [
                                    if (!isExpanded &&
                                        widget.post.text!.length > 100)
                                      const TextSpan(
                                          text: " بیشتر... ",
                                          style:
                                              TextStyle(color: Colors.white60)),
                                    if (isExpanded)
                                      const TextSpan(
                                          text: " کمتر ",
                                          style:
                                              TextStyle(color: Colors.white38)),
                                  ],
                                ),
                                maxLines:
                                    isExpanded || widget.post.text!.length <= 100
                                        ? null
                                        : 2,
                                overflow:
                                    isExpanded || widget.post.text!.length <= 100
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditPostPage(
                            post: widget.post,
                          ),
                        ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8,bottom: 8),
                      child: Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.6)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              if (widget.post.image != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(widget.post.image!),
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
              if (widget.post.audio != null) ...[
                const SizedBox(height: 16),
                VoicePlayer(
                  audioFile: widget.post.audio!,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 30,
                ),
                /* Row(
                  children: [
                    Icon(Icons.voice_chat, color: Colors.white.withOpacity(0.6)),
                    const SizedBox(width: 8),
                    Text('widget.voiceLabel!',
                        style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  ],
                ), */
              ],
              if (widget.post.emojies.isNotEmpty) ...[
                const SizedBox(height: 23),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.editable
                        ? InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditPostPage(
                                    post: widget.post,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text("ویرایش ادعا",
                                  style: GoogleFonts.notoSansArabic(
                                      fontSize: 13, color: Colors.white)),
                            ))
                        : const SizedBox.shrink(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditPostPage(
                              post: widget.post,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.open_in_full_outlined,
                            color: Colors.white, size: 15),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              /* Row(
                children: [
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                    ),
                  ),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenVideoPage extends StatelessWidget {
  final File video;
  final Duration initialPosition;
  static Duration? currentPosition;

  const FullScreenVideoPage({
    super.key,
    required this.video,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.file(video);

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

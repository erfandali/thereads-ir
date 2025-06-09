import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:threads/core/models/post.dart';

import '../../../core/data/fake_data.dart';
import '../../../core/providers/post_provider.dart';
import '../../../core/widgets/image_viewer.dart';
import '../../../core/widgets/video_player.dart';
import '../../../core/widgets/voice_player.dart';
import 'image_editor_page.dart';
import 'video_editor_page.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  File? _selectedImage;
  File? _selectedVideo;
  File? _recordedAudio;
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  final RecorderController recorderController = RecorderController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedImage = widget.post.image;
    _selectedVideo = widget.post.video;
    _recordedAudio = widget.post.audio;
    _textController.text = widget.post.text ?? '';
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageEditorPage(
            image: File(image.path),
            onImageEdited: (image) {
              setState(() {
                _selectedImage = image;
                _selectedVideo = null;
                _recordedAudio = null;
              });
            },
          ),
        ),
      );
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoEditorPage(
            video: File(video.path),
            onVideoEdited: (video) {
              setState(() {
                _selectedVideo = video;
                _selectedImage = null;
                _recordedAudio = null;
              });
            },
          ),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageEditorPage(
            image: File(image.path),
            onImageEdited: (image) {
              setState(() {
                _selectedImage = image;
                _selectedVideo = null;
                _recordedAudio = null;
              });
            },
          ),
        ),
      );
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() {
        _recordedAudio = path != null ? File(path) : null;
        _isRecording = false;
        _selectedVideo = null;
        _selectedImage = null;
      });
    } else {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/my_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });
      }
    }
  }

  void _submit() {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ' متن ادعا را وارد کنید.',
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: const Color(0xFF4E4E4E),
        ),
      );
      return;
    }

    Provider.of<PostProvider>(context, listen: false).updatePost(
      widget.post.id,
      Post.fromFile(
        image: _selectedImage,
        video: _selectedVideo,
        audio: _recordedAudio,
        text: _textController.text,
        user: FakeData.currentUser,
        createdAt: widget.post.createdAt,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _player.dispose();
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ایجاد ادعای جدید',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close_rounded),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(FakeData.currentUser.profilePicUrl),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Text(
                          FakeData.currentUser.username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12),
                        Expanded(
                          flex: 10,
                          child: Text(
                            'افزودن موضوع',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    subtitle: TextField(
                      maxLines: null,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'ادعای خودتو اضافه کن ...',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      /* Container(
                        width: 2,
                        height: 50,
                        color: Colors.grey,
                      ), */
                      const SizedBox(width: 25),
                      IconButton(
                        onPressed: _pickImage,
                        icon: Icon(Icons.photo_library_rounded,
                            color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: _pickVideo,
                        icon: Icon(Icons.video_library_rounded,
                            color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: _takePhoto,
                        icon:
                            Icon(Icons.camera_alt_rounded, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: _toggleRecording,
                        icon: Icon(
                          _isRecording
                              ? Icons.stop_circle
                              : Icons.keyboard_voice_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (_selectedVideo != null)
                    /* CropGridViewer.edit(
                      controller: VideoEditorController.file(_selectedVideo!),
                    ), */
                    VideoPreviewPlayer(
                      videoFile: _selectedVideo!,
                      maxHeight: double.infinity,
                      onClosePressed: () => setState(
                        () {
                          _selectedVideo = null;
                        },
                      ),
                    ),
                  if (_selectedImage != null)
                    ImageViewer(
                      image: Image.file(
                        _selectedImage!,
                        width: screenSize.width,
                      ),
                      onClosePressed: () => setState(
                        () {
                          _selectedImage = null;
                        },
                      ),
                    ),
                  /* ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      width: screenSize.width,
                    ),
                  ), */
                  if (_recordedAudio != null) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: VoicePlayer(
                        audioFile: _recordedAudio!,
                        height: 40,
                        width: MediaQuery.of(context).size.width - 140,
                        onClosePressed: () => setState(
                          () {
                            _recordedAudio = null;
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            width: screenSize.width,
            child: Container(
              width: screenSize.width - 30,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'هر کسی میتواند ادعای شما رو ببیند و شما رو دوئل دعوت کند.',
                        style: TextStyle(fontSize: 11, color: Colors.grey[300]),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            width: 1,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      child: Text(
                        'پست',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

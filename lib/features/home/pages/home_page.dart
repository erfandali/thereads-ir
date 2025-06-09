import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/core/data/fake_data.dart';
import 'package:threads/core/providers/post_provider.dart';
import 'package:threads/core/widgets/scrollable_column.dart';
import '../../../core/models/post.dart';
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
        backgroundColor: Colors.white10,
        appBar: AppBar(
          title: Text(
            'نمایش',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Consumer<PostProvider>(
            builder: (context, postProvider, child) => ScrollableColumn(
              spacing: 2,
              children: List.generate(
                postProvider.posts.length,
                (index) => FutureBuilder(
                    future: postProvider.posts[index],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      Post post = snapshot.data ??
                          Post.fromUrl(
                            user: FakeData.currentUser,
                            text: 'error',
                            createdAt: DateTime.now(),
                          ) as Post;

                      return PostCards(
                        post: post,
                        editable: index == 0,
                      );
                    }),
              ),
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
          borderRadius: BorderRadius.circular(100), color: Colors.white),
    );
  }
}

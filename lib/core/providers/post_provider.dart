import 'package:flutter/material.dart';

import '../data/fake_data.dart';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final List<Future<Post>> _posts = FakeData.posts;

  List<Future<Post>> get posts => [..._posts];

  void updatePost(int id, Post newPost) async {
    print('here2-1');

    print('newpost.text: ${newPost.text}');
    final posts = await Future.wait(_posts);

    int index = posts.indexWhere(
      (post) => post.id == id,
    );
    newPost.emojies = posts[index].emojies;
    newPost.editedAt = DateTime.now();
    _posts[index] = Future.value(newPost);

    print('here2-2');
    notifyListeners();
    print('here2-3');
  }
}

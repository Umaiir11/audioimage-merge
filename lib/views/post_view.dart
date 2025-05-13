import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musictiktok/views/post_details.dart';
import 'package:path/path.dart' as path;

import '../controllers/controller.dart';
import '../main.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Posts'),
      ),
      body: Obx(() => postController.posts.isEmpty
          ? const Center(
        child: Text(
          'No posts yet! Tap the + icon to create your first post.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: postController.posts.length,
        itemBuilder: (context, index) {
          final post = postController.posts[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => PostViewPage(post: post));
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.file(
                    File(post.imagePath),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.music_note),
                        const SizedBox(width: 8),
                        Text(path.basename(post.audioPath)),
                        const Spacer(),
                        Text(
                          '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
      ),
    );
  }
}

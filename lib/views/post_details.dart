import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart' as path;

import '../controllers/audio_controller.dart';
import '../controllers/controller.dart';
import '../main.dart';
import '../models/model.dart';

class PostViewPage extends StatelessWidget {
  final Post post;

  const PostViewPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioController audioController = Get.put(AudioController());

    // Initialize audio when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioController.setAudioSource(post.audioPath);
      audioController.playPause(); // Auto-play when opening the post
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: audioController.playPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.file(File(post.imagePath), fit: BoxFit.cover),

            // Gradient overlay for better visibility
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
                ),
              ),
            ),

            // Audio controls
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Icon(audioController.isPlaying.value ? Icons.pause : Icons.play_arrow, color: Colors.white)),
                          const SizedBox(width: 8),
                          Text(path.basename(post.audioPath), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

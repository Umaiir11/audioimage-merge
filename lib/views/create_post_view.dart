

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart' as path;

import '../controllers/controller.dart';
import '../controllers/create_post_controller.dart';
import '../main.dart';
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CreatePostController controller = Get.put(CreatePostController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Obx(() => controller.isCreating.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => controller.selectedImage.value != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      controller.selectedImage.value!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 64),
                        SizedBox(height: 16),
                        Text('Tap to select an image'),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton.icon(
                onPressed: controller.pickAudio,
                icon: const Icon(Icons.music_note),
                label: Text(
                  controller.selectedAudio.value != null
                      ? 'Selected: ${path.basename(controller.selectedAudio.value!.path)}'
                      : 'Select Audio',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              )),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: controller.createPost,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Create Post',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

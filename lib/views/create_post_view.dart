import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../controllers/controller.dart';

class PostCreationScreen extends StatelessWidget {
  const PostCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostCreationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _showImagePickerOptions(context),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    image: controller.imageFile.value != null
                        ? DecorationImage(
                      image: FileImage(controller.imageFile.value!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.imageFile.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to select image', style: TextStyle(color: Colors.grey)),
                    ],
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.audioFile.value != null ? Icons.audiotrack : Icons.music_note,
                      color: controller.audioFile.value != null ? Colors.purpleAccent : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.audioFile.value != null
                            ? 'Audio: ${controller.audioFile.value!.path.split('/').last}'
                            : 'No audio selected',
                        style: TextStyle(
                          color: controller.audioFile.value != null ? Colors.white : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.music_note),
                      color: Colors.purpleAccent,
                      onPressed: controller.pickAudio,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              controller.isProcessing.value
                  ? Column(
                children: [
                  const SpinKitWave(
                    color: Colors.purpleAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.processingStatus.value,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              )
                  : ElevatedButton.icon(
                onPressed: controller.createVideo,
                icon: const Icon(Icons.movie_creation),
                label: const Text('Create Video Post'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    final controller = Get.find<PostCreationController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.purpleAccent),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(fromCamera: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.purpleAccent),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                controller.pickImage(fromCamera: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
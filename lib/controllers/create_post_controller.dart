

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musictiktok/services/storage_service.dart';

import '../models/model.dart';
import 'controller.dart';

class CreatePostController extends GetxController {
  final PostController _postController = Get.find<PostController>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> selectedAudio = Rx<File?>(null);
  final RxBool isCreating = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      selectedAudio.value = File(result.files.single.path!);
    }
  }

  Future<void> createPost() async {
    if (selectedImage.value == null || selectedAudio.value == null) {
      Get.snackbar('Error', 'Please select both an image and audio file');
      return;
    }

    isCreating.value = true;

    try {
      // Save files to app directory
      final imagePath = await _storageService.saveFileToAppDirectory(selectedImage.value!);
      final audioPath = await _storageService.saveFileToAppDirectory(selectedAudio.value!);

      // Create and save post
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: imagePath,
        audioPath: audioPath,
        createdAt: DateTime.now(),
      );

      await _postController.savePost(post);

      isCreating.value = false;
      selectedImage.value = null;
      selectedAudio.value = null;

      Get.snackbar('Success', 'Post created successfully!');
    } catch (e) {
      isCreating.value = false;
      Get.snackbar('Error', 'Error creating post: $e');
    }
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musictiktok/services/storage_service.dart';

import '../models/model.dart';

class PostController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final RxList<Post> posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  void loadPosts() {
    final loadedPosts = _storageService.getPosts();
    loadedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    posts.value = loadedPosts;
  }

  Future<void> savePost(Post post) async {
    posts.add(post);
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _storageService.savePosts(posts);
  }
}

// Audio controller using GetX and just_audio


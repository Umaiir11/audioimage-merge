import 'dart:io';
import 'package:get/get.dart';

import '../config/app_routes.dart';
import '../repo/repo.dart';
import '../services/ffmpeg_service.dart';

import '../services/file_service.dart';
import '../services/permission_service.dart';

class PostCreationController extends GetxController {
  final PostRepository _postRepository;
  final FileService _fileService;
  final PermissionService _permissionService;

  PostCreationController()
      : _postRepository = PostRepository(FFmpegService(), FileService()),
        _fileService = FileService(),
        _permissionService = PermissionService();

  final imageFile = Rx<File?>(null);
  final audioFile = Rx<File?>(null);
  final isProcessing = false.obs;
  final processingStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _permissionService.requestPermissions();
  }

  Future<void> pickImage({bool fromCamera = false}) async {
    final file = await _fileService.pickImage(fromCamera: fromCamera);
    if (file != null) {
      imageFile.value = file;
    }
  }

  Future<void> pickAudio() async {
    final file = await _fileService.pickAudio();
    if (file != null) {
      audioFile.value = file;
    }
  }

  Future<void> createVideo() async {
    if (imageFile.value == null || audioFile.value == null) {
      Get.snackbar('Error', 'Please select both image and audio');
      return;
    }

    isProcessing.value = true;
    processingStatus.value = 'Processing...';

    try {
      processingStatus.value = 'Encoding...';
      final post = await _postRepository.createPost(
        imageFile.value!.path,
        audioFile.value!.path,
      );
      isProcessing.value = false;
      Get.offNamed(AppRoutes.postDisplay, arguments: post.videoFile);
    } catch (e) {
      isProcessing.value = false;
      Get.snackbar('Error', 'Failed to create video: $e');
    }
  }
}
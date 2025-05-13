import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../config/app_routes.dart';
import '../repo/repo.dart';
import '../services/ffmpeg_service.dart';
import '../services/file_service.dart';

class PostDisplayController extends GetxController {
  final PostRepository _postRepository;

  PostDisplayController() : _postRepository = PostRepository(FFmpegService(), FileService());

  final videoController = Rx<VideoPlayerController?>(null);
  final isPlaying = false.obs;
  final isLoading = true.obs;
  final volume = 1.0.obs;
  File? videoFile;

  @override
  void onInit() {
    super.onInit();
    videoFile = Get.arguments as File?;
    loadVideo();
  }

  Future<void> loadVideo() async {
    isLoading.value = true;

    try {
      videoFile ??= await _postRepository.getLastVideoFile();
      if (videoFile != null && await videoFile!.exists()) {
        videoController.value = VideoPlayerController.file(
          videoFile!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );

        await videoController.value!.initialize();
        videoController.value!.setLooping(true);
        videoController.value!.play();
        isPlaying.value = true;

        videoController.value!.addListener(() {
          isPlaying.value = videoController.value!.value.isPlaying;
        });
      } else {
        Get.snackbar('Error', 'Video file not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error loading video: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void togglePlayPause() {
    if (videoController.value == null) return;
    if (videoController.value!.value.isPlaying) {
      videoController.value!.pause();
    } else {
      videoController.value!.play();
    }
  }

  void setVolume(double value) {
    volume.value = value;
    videoController.value?.setVolume(value);
  }

  void createNewPost() {
    Get.offNamed(AppRoutes.postCreation);
  }

  void shareVideo() {
    Get.snackbar('Info', 'Sharing will be implemented in future updates');
  }

  @override
  void onClose() {
    videoController.value?.dispose();
    super.onClose();
  }
}
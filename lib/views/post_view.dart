import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/post_display_controller.dart';

class PostDisplayScreen extends StatelessWidget {
  const PostDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostDisplayController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Video Post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.shareVideo,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.purple.shade900],
          ),
        ),
        child: Center(
          child: Obx(
                () => controller.isLoading.value
                ? const SpinKitPulse(
              color: Colors.purpleAccent,
              size: 50,
            )
                : controller.videoController.value != null &&
                controller.videoController.value!.value.isInitialized
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: controller.videoController.value!.value.aspectRatio,
                      child: VideoPlayer(controller.videoController.value!),
                    ),
                    if (!controller.isPlaying.value)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          onPressed: controller.togglePlayPause,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          controller.volume.value > 0 ? Icons.volume_up : Icons.volume_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.setVolume(controller.volume.value > 0 ? 0.0 : 1.0);
                        },
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.purpleAccent,
                          inactiveColor: Colors.grey,
                          value: controller.volume.value,
                          min: 0,
                          max: 1.0,
                          onChanged: controller.setVolume,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: controller.togglePlayPause,
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Video not available',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: controller.createNewPost,
                  child: const Text('Create New Post'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createNewPost,
        backgroundColor: Colors.purpleAccent,
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
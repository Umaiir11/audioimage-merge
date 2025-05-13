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

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Your Video Post',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: controller.shareVideo,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black87,
              Colors.deepPurple.shade900,
              Colors.purple.shade700,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Center(
                child: Obx(
                      () => controller.isLoading.value
                      ? const SpinKitFadingCube(
                    color: Colors.purpleAccent,
                    size: 50,
                  )
                      : controller.videoController.value != null &&
                      controller.videoController.value!.value.isInitialized
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 3,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: controller.videoController
                                .value!.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoPlayer(controller.videoController.value!),
                                AnimatedOpacity(
                                  opacity: controller.isPlaying.value ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: GestureDetector(
                                    onTap: controller.togglePlayPause,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(24),
                                      child: Icon(
                                        controller.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 70,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      VideoProgressIndicator(
                        controller.videoController.value!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.purpleAccent,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.white24,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildControls(controller),
                      ),
                      const SizedBox(height: 80), // Space for FAB
                    ],
                  )
                      : _buildErrorState(controller),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton.extended(
          onPressed: controller.createNewPost,
          backgroundColor: Colors.purpleAccent.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(52),
          ),
          elevation: 10,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'New Post',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildControls(PostDisplayController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
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
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                activeTrackColor: Colors.purpleAccent,
                inactiveTrackColor: Colors.white.withOpacity(0.3),
                thumbColor: Colors.white,
                overlayColor: Colors.purpleAccent.withOpacity(0.4),
              ),
              child: Slider(
                value: controller.volume.value,
                min: 0,
                max: 1.0,
                onChanged: controller.setVolume,
              ),
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
    );
  }

  Widget _buildErrorState(PostDisplayController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.redAccent,
          size: 50,
        ),
        const SizedBox(height: 16),
        Text(
          'Video not available',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: controller.createNewPost,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            elevation: 10,
          ),
          child: const Text(
            'Create New Post',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }
}
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
      backgroundColor: const Color(0xFF121212), // Dark background for modern vibe
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Your Vibe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Selection Area
              GestureDetector(
                onTap: () => _showImagePickerOptions(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: controller.imageFile.value != null
                          ? [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.3)]
                          : [const Color(0xFF1E1E1E), const Color(0xFF2A2A2A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: controller.imageFile.value != null
                        ? DecorationImage(
                      image: FileImage(controller.imageFile.value!),
                      fit: BoxFit.cover,
                      opacity: 0.9,
                    )
                        : null,
                  ),
                  child: controller.imageFile.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 60,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Capture or Pick a Moment',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                      : Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () {
    },

                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Audio Selection Area
              GestureDetector(
                onTap: controller.pickAudio,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2A2A2A),
                        controller.audioFile.value != null
                            ? Colors.purpleAccent.withOpacity(0.2)
                            : const Color(0xFF1E1E1E),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: controller.audioFile.value != null
                            ? const AlwaysStoppedAnimation(1.0)
                            : const AlwaysStoppedAnimation(0.0),
                        color: controller.audioFile.value != null
                            ? Colors.purpleAccent
                            : Colors.white70,
                        size: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          controller.audioFile.value != null
                              ? 'Audio: ${controller.audioFile.value!.path.split('/').last}'
                              : 'Add a Soundtrack',
                          style: TextStyle(
                            color: controller.audioFile.value != null
                                ? Colors.white
                                : Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (controller.audioFile.value != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white70),
                          onPressed:() {}
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Create Video Button or Loading State
              controller.isProcessing.value
                  ? Column(
                children: [
                  SpinKitPouringHourGlass(
                    color: Colors.purpleAccent,
                    size: 50,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.processingStatus.value,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              )
                  : ElevatedButton(
                onPressed: controller.createVideo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  foregroundColor: Colors.white,
                  splashFactory: InkRipple.splashFactory,
                ).copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                  overlayColor: WidgetStateProperty.all(
                    Colors.purpleAccent.withOpacity(0.2),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purpleAccent, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.video_call_rounded, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Craft Your Video',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E1E1E).withOpacity(0.95),
              const Color(0xFF2A2A2A).withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildOptionTile(
                icon: Icons.photo_library_rounded,
                title: 'From Gallery',
                onTap: () {
                  Get.back();
                  controller.pickImage(fromCamera: false);
                },
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: Icons.camera_alt_rounded,
                title: 'Snap a Photo',
                onTap: () {
                  Get.back();
                  controller.pickImage(fromCamera: true);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.purpleAccent,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/postyrepo_base.dart';
import '../models/model.dart';
import '../services/ffmpeg_service.dart';
import '../services/file_service.dart';

class PostRepository implements PostRepositoryBase {
  final FFmpegService _ffmpegService;
  final FileService _fileService;

  PostRepository(this._ffmpegService, this._fileService);

  @override
  Future<Post> createPost(String imagePath, String audioPath) async {
    try {
      final outputPath = await _fileService.getOutputPath();
      print('Creating video with output path: $outputPath');

      final videoFile = await _ffmpegService.createVideo(imagePath, audioPath, outputPath);

      if (videoFile != null && await videoFile.exists()) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('post_video_path', videoFile.path);
        print('Video file saved to SharedPreferences: ${videoFile.path}');
        return Post(videoFile: videoFile);
      } else {
        throw Exception('Video file creation failed or file does not exist at $outputPath');
      }
    } catch (e) {
      print('Error creating post: $e');
      throw Exception('Failed to create video: $e');
    }
  }

  @override
  Future<File?> getLastVideoFile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final videoPath = prefs.getString('post_video_path');

      if (videoPath != null && await File(videoPath).exists()) {
        print('Retrieved video file from SharedPreferences: $videoPath');
        return File(videoPath);
      }

      print('No valid video file found in SharedPreferences');
      return null;
    } catch (e) {
      print('Error retrieving last video file: $e');
      return null;
    }
  }
}
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

class FFmpegService {
  Future<File?> createVideo(String imagePath, String audioPath, String outputPath) async {
    // Optimized FFmpeg command with resizing and pixel format correction
    final command = '-loop 1 -i "$imagePath" -i "$audioPath" '
        '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2:force_original_aspect_ratio=decrease,pad=ceil(iw/2)*2:ceil(ih/2)*2:(ow-iw)/2:(oh-ih)/2,format=yuv420p" '
        '-c:v libx264 -preset ultrafast -tune stillimage '
        '-c:a aac -b:a 128k -shortest -y "$outputPath"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      final videoFile = File(outputPath);
      if (await videoFile.exists()) {
        return videoFile;
      } else {
        throw Exception('Video file not found at $outputPath');
      }
    } else {
      final output = await session.getOutput();
      throw Exception('FFmpeg error: ${output?.substring(0, 100)}...');
    }
  }
}
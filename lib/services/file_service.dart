import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  final _picker = ImagePicker();

  Future<File?> pickImage({bool fromCamera = false}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70, // Reduced quality for faster processing
      maxWidth: 1280, // Resize to reduce processing time
      maxHeight: 720,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );
    return result?.files.single.path != null
        ? File(result!.files.single.path!)
        : null;
  }

  Future<String> getOutputPath() async {
    final cacheDir = await getTemporaryDirectory();
    return '${cacheDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
  }
}
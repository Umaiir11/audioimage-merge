import 'dart:io';

import '../models/model.dart';

abstract class PostRepositoryBase {
  Future<Post> createPost(String imagePath, String audioPath);
  Future<File?> getLastVideoFile();
}
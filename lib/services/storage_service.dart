import 'dart:convert';
import 'dart:io';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/model.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> savePosts(List<Post> posts) async {
    final List<String> jsonPosts = posts
        .map((post) => jsonEncode(post.toJson()))
        .toList();
    await _prefs.setStringList('posts', jsonPosts);
  }

  List<Post> getPosts() {
    final List<String>? jsonPosts = _prefs.getStringList('posts');
    if (jsonPosts == null) {
      return [];
    }
    return jsonPosts
        .map((jsonPost) => Post.fromJson(jsonDecode(jsonPost)))
        .toList();
  }

  Future<String> saveFileToAppDirectory(File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filename = path.basename(file.path);
    final savedFile = await file.copy('${appDocDir.path}/$filename');
    return savedFile.path;
  }
}

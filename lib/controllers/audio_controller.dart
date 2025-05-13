

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';


import '../models/model.dart';
class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;

  Future<void> setAudioSource(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      _audioPlayer.playerStateStream.listen((state) {
        isPlaying.value = state.playing;
      });
    } catch (e) {
      debugPrint('Error setting audio source: $e');
      Get.snackbar('Error', 'Failed to load audio: $e');
    }
  }

  Future<void> playPause() async {
    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestPermissions() async {
    final permissions = [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
    ];
    bool allGranted = true;
    for (var permission in permissions) {
      if (await permission.request().isDenied) {
        allGranted = false;
      }
    }
    return allGranted;
  }
}
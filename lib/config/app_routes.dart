import 'package:get/get.dart';
import '../controllers/controller.dart';
import '../controllers/post_display_controller.dart';
import '../views/create_post_view.dart';
import '../views/post_view.dart';

class AppRoutes {
  static const postCreation = '/post_creation';
  static const postDisplay = '/post_display';

  static final routes = [
    GetPage(
      name: postCreation,
      page: () => const PostCreationScreen(),
      binding: PostCreationBinding(),
    ),
    GetPage(
      name: postDisplay,
      page: () => const PostDisplayScreen(),
      binding: PostDisplayBinding(),
    ),
  ];
}

class PostCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostCreationController());
  }
}

class PostDisplayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostDisplayController());
  }
}
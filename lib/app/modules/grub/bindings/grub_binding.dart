import 'package:get/get.dart';

import '../controllers/grub_controller.dart';

class GrubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GrubController>(
      () => GrubController(),
    );
  }
}

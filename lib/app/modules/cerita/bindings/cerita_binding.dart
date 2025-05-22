import 'package:get/get.dart';

import '../controllers/cerita_controller.dart';

class CeritaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CeritaController>(
      () => CeritaController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/obrolan_controller.dart';

class ObrolanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ObrolanController>(
      () => ObrolanController(),
    );
  }
}

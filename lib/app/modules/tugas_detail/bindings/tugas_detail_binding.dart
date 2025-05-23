import 'package:get/get.dart';

import '../controllers/tugas_detail_controller.dart';

class TugasDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TugasDetailController>(
      () => TugasDetailController(),
    );
  }
}

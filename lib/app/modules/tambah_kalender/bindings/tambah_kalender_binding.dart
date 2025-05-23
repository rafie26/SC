import 'package:get/get.dart';

import '../controllers/tambah_kalender_controller.dart';

class TambahKalenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahKalenderController>(
      () => TambahKalenderController(),
    );
  }
}

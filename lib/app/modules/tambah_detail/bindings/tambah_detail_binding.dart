import 'package:get/get.dart';

import '../controllers/tambah_detail_controller.dart';

class TambahDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahDetailController>(
      () => TambahDetailController(),
    );
  }
}

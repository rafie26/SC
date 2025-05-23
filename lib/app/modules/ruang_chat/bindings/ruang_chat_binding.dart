import 'package:get/get.dart';

import '../controllers/ruang_chat_controller.dart';

class RuangChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuangChatController>(
      () => RuangChatController(),
    );
  }
}

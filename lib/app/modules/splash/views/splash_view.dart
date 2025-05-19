import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get device screen size
    final Size screenSize = MediaQuery.of(context).size;
    
    // Calculate responsive logo size (50% of screen width, max 300)
    final double logoSize = screenSize.width * 0.5 > 300 ? 300 : screenSize.width * 0.5;

    return Scaffold(
      // Purple background color
      backgroundColor: const Color(0xFF8B2FCA), 
      body: Center(
        child: Obx(() => Opacity(
          opacity: controller.opacity.value,
          child: Image.asset(
            'assets/logo.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
          ),
        )),
      ),
    );
  }
}

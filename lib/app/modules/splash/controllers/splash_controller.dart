import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final opacity = 0.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    // Set up fade-in animation
    final Animation<double> _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    // Listen to animation changes and update the observable opacity
    _opacityAnimation.addListener(() {
      opacity.value = _opacityAnimation.value;
    });
    
    // Start animation
    _animationController.forward();
    
    // Navigate to register screen after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      Get.offAllNamed('/register');
    });
  }
  
  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}
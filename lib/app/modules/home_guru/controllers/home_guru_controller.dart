import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeGuruController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var profileImage = ''.obs;
  var isMenuOpen = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  // Load initial data
  void loadData() async {
    try {
      isLoading(true);
      
      // Here you can add API calls or data loading logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Set profile image (replace with actual image URL from your API)
      profileImage.value = '';
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
  
  // Method for navigating to the tambah-kelas page
  void navigateToTambahKelas() {
    Get.toNamed('/tambah-kelas');
  }
  
  // Toggle menu burger
  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }
  
  // Close menu
  void closeMenu() {
    isMenuOpen.value = false;
  }
  
  // Menu action methods
  void navigateToTugas() {
    closeMenu();
    Get.toNamed('/tugas');
  }
  
  void navigateToMateri() {
    closeMenu();
    Get.toNamed('/materi');
  }

  
  void navigateToKalender() {
    closeMenu();
    Get.toNamed('/kalender');
  }
  
  void showBantuan() {
    closeMenu();
    Get.dialog(
      AlertDialog(
        title: const Text('Bantuan'),
        content: const Text('Untuk bantuan lebih lanjut, silakan hubungi:\n\nEmail: SevenConnect@gmail.com\nTelp: 0895-6119-99186'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
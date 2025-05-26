import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeGuruController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var profileImage = ''.obs;
  var isMenuOpen = false.obs;
  var isProfileSidebarOpen = false.obs; // New variable for profile sidebar
  
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
    // Close profile sidebar if open
    if (isProfileSidebarOpen.value) {
      isProfileSidebarOpen.value = false;
    }
  }
  
  // Close menu
  void closeMenu() {
    isMenuOpen.value = false;
  }
  
  // Toggle profile sidebar - New method
  void toggleProfileSidebar() {
    isProfileSidebarOpen.value = !isProfileSidebarOpen.value;
    // Close menu if open
    if (isMenuOpen.value) {
      isMenuOpen.value = false;
    }
  }
  
  // Close profile sidebar - New method
  void closeProfileSidebar() {
    isProfileSidebarOpen.value = false;
  }
  
  // Profile sidebar action methods - New methods
  void navigateToProfile() {
    closeProfileSidebar();
    Get.toNamed('/profil');
  }
  
  void navigateToSettings() {
    closeProfileSidebar();
    Get.toNamed('/settings');
  }
  
  void logout() {
    closeProfileSidebar();
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Add your logout logic here
              Get.offAllNamed('/login'); // Navigate to login page
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  // Menu action methods
  void navigateToNilai() {
    closeMenu();
    Get.toNamed('/nilai');
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
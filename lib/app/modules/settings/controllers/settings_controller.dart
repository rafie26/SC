import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var isNotificationEnabled = true.obs;
  var isAutoSyncEnabled = true.obs;
  var selectedLanguage = 'Bahasa Indonesia'.obs;
  var selectedFontSize = 'Sedang'.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    Get.snackbar(
      'Pengaturan',
      value ? 'Mode gelap diaktifkan' : 'Mode terang diaktifkan',
      backgroundColor: const Color(0xFF6C1FB4),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    Get.snackbar(
      'Notifikasi',
      value ? 'Notifikasi diaktifkan' : 'Notifikasi dinonaktifkan',
      backgroundColor: const Color(0xFF6C1FB4),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void toggleAutoSync(bool value) {
    isAutoSyncEnabled.value = value;
    Get.snackbar(
      'Sinkronisasi',
      value ? 'Sinkronisasi otomatis diaktifkan' : 'Sinkronisasi otomatis dinonaktifkan',
      backgroundColor: const Color(0xFF6C1FB4),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void changeFontSize(String fontSize) {
    selectedFontSize.value = fontSize;
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    Get.snackbar(
      'Bahasa',
      'Bahasa berhasil diubah ke $language',
      backgroundColor: const Color(0xFF6C1FB4),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void resetSettings() {
    isDarkMode.value = false;
    isNotificationEnabled.value = true;
    isAutoSyncEnabled.value = true;
    selectedLanguage.value = 'Bahasa Indonesia';
    selectedFontSize.value = 'Sedang';
    
    Get.snackbar(
      'Berhasil', 
      'Semua pengaturan telah direset ke default',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
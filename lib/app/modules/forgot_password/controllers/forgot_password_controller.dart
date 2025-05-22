import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  // Controller untuk field email
  final TextEditingController emailController = TextEditingController();
  
  // Status loading untuk tombol kirim
  final RxBool isLoading = false.obs;
  
  // Status berhasil kirim email
  final RxBool isEmailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Validasi email
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Fungsi kirim email reset password
  void sendResetEmail() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
      return;
    }

    if (!isValidEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
      return;
    }

    try {
      isLoading(true);
      
      // Simulasi proses kirim email dengan delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Di sini Anda bisa menambahkan logika kirim email yang sebenarnya
      // Contoh: await authService.sendPasswordResetEmail(email);
      
      // Berhasil kirim email
      isEmailSent(true);
      
      Get.snackbar(
        'Berhasil',
        'Link reset password telah dikirim ke email Anda',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim email: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isLoading(false);
    }
  }

  // Fungsi kembali ke halaman login
  void backToLogin() {
    Get.back();
  }

  // Fungsi kirim ulang email
  void resendEmail() {
    isEmailSent(false);
    sendResetEmail();
  }
}
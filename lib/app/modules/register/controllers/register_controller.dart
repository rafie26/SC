import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Text controllers untuk fields
  final usernameController = TextEditingController();
  final nomorIndukController = TextEditingController(); // NEW CONTROLLER
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Method untuk register
  void register() {
    // Validasi input - tambahkan nomor induk
    if (usernameController.text.isEmpty || 
        nomorIndukController.text.isEmpty || // NEW VALIDATION
        emailController.text.isEmpty || 
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi nomor induk - minimal 8 digit
    if (nomorIndukController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Nomor Induk minimal 8 digit',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi nomor induk - hanya angka
    if (!RegExp(r'^[0-9]+$').hasMatch(nomorIndukController.text)) {
      Get.snackbar(
        'Error',
        'Nomor Induk hanya boleh berisi angka',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi email
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi password minimal 6 karakter
    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Implementasi registrasi sesuai kebutuhan
    // Contoh data yang bisa dikirim ke API:
    Map<String, dynamic> registerData = {
      'username': usernameController.text,
      'nomor_induk': nomorIndukController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    // TODO: Kirim data ke backend/API
    print('Register Data: $registerData'); // Debug print

    // Contoh simulasi registrasi berhasil
    Get.snackbar(
      'Success',
      'Registration successful',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // Navigate to login screen
    Get.toNamed('/login');
  }

  // Method untuk validasi nomor induk secara realtime (optional)
  bool isValidNomorInduk(String nomorInduk) {
    // Cek apakah nomor induk valid
    if (nomorInduk.isEmpty) return false;
    if (nomorInduk.length < 8) return false;
    if (!RegExp(r'^[0-9]+$').hasMatch(nomorInduk)) return false;
    
    // TODO: Tambahkan validasi dengan database
    // Contoh: cek apakah nomor induk sudah terdaftar
    
    return true;
  }

  // Method untuk menentukan role berdasarkan nomor induk (optional)
  String getRoleFromNomorInduk(String nomorInduk) {
    // Contoh logika sederhana berdasarkan prefix nomor
    if (nomorInduk.startsWith('202')) {
      return 'Siswa'; // NIS dimulai dengan tahun masuk
    } else if (nomorInduk.startsWith('19')) {
      return 'Guru'; // NIP format lama
    } else if (nomorInduk.startsWith('20')) {
      return 'Guru'; // NIP format baru
    }
    return 'Unknown';
  }

  @override
  void onClose() {
    // Dispose controllers saat widget dihapus
    usernameController.dispose();
    nomorIndukController.dispose(); // NEW DISPOSE
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahKelasController extends GetxController {
  // Controller untuk halaman tambah kelas
  
  // Text controller untuk input field
  late TextEditingController namaKelasController;
  
  // Variabel yang bisa Anda gunakan untuk menyimpan data form
  final namaKelas = ''.obs;
  final deskripsiKelas = ''.obs;
  final kapasitasMaks = 0.obs;
  
  // Observable string untuk menyimpan tingkat kelas yang dipilih (single selection)
  final selectedTingkatKelas = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi text controller
    namaKelasController = TextEditingController();
    
    // Listen for changes pada text field
    namaKelasController.addListener(() {
      namaKelas.value = namaKelasController.text;
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Logic yang dijalankan saat halaman siap ditampilkan
  }

  @override
  void onClose() {
    // Dispose controller untuk mencegah memory leak
    namaKelasController.dispose();
    super.onClose();
  }
  
  // Method untuk set tingkat kelas (single selection)
  void setTingkatKelas(String tingkat) {
    selectedTingkatKelas.value = tingkat;
  }
  
  // Method untuk clear selection tingkat kelas
  void clearTingkatKelas() {
    selectedTingkatKelas.value = '';
  }
  
  // Method untuk membuat kelas baru
  void buatKelasBaru() {
    // Validasi input
    if (namaKelasController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama kelas tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (selectedTingkatKelas.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih tingkat kelas terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Implementasi logika pembuatan kelas baru
    // Contoh:
    // 1. Kirim request ke API
    print('Nama Kelas: ${namaKelasController.text}');
    print('Tingkat Kelas: ${selectedTingkatKelas.value}');
    
    // 2. Handle response
    Get.snackbar(
      'Berhasil',
      'Kelas berhasil dibuat',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // 3. Navigasi kembali ke halaman sebelumnya jika berhasil
    Get.back();
  }
}
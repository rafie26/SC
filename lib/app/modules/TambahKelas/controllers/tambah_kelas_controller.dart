import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahKelasController extends GetxController {
  // Text controller untuk nama kelas
  final TextEditingController namaKelasController = TextEditingController();
  
  // Observable untuk nama kelas (untuk reactive form validation)
  var namaKelas = ''.obs;
  
  // Observable untuk tingkat kelas yang dipilih
  var selectedTingkatKelas = ''.obs;
  
  // Observable untuk mata pelajaran yang dipilih
  var selectedMataPelajaran = ''.obs;
  
  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to text controller changes and update observable
    namaKelasController.addListener(() {
      namaKelas.value = namaKelasController.text;
    });
  }

  @override
  void onClose() {
    // Dispose text controller when controller is closed
    namaKelasController.dispose();
    super.onClose();
  }

  // Method untuk set tingkat kelas
  void setTingkatKelas(String tingkatKelas) {
    selectedTingkatKelas.value = tingkatKelas;
  }

  // Method untuk set mata pelajaran
  void setMataPelajaran(String mataPelajaran) {
    selectedMataPelajaran.value = mataPelajaran;
  }

  // Method untuk validasi form
  bool _validateForm() {
    if (namaKelasController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nama kelas tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    if (selectedTingkatKelas.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih tingkat kelas terlebih dahulu',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    if (selectedMataPelajaran.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih mata pelajaran terlebih dahulu',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }

  // Method untuk cek apakah form valid (now reactive)
  bool get isFormValid {
    return namaKelas.value.trim().isNotEmpty &&
           selectedTingkatKelas.value.isNotEmpty &&
           selectedMataPelajaran.value.isNotEmpty;
  }

  // Method untuk membuat kelas baru
  Future<void> buatKelasBaru() async {
    // Validasi form terlebih dahulu
    if (!_validateForm()) {
      return;
    }

    try {
      // Set loading state
      isLoading.value = true;

      // Simulasi API call atau database operation
      // Ganti dengan logic sesuai kebutuhan aplikasi Anda
      await _saveKelasToDatabase();

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Kelas "${namaKelasController.text}" berhasil dibuat',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Clear form
      _clearForm();

      // Navigate to home-guru page
      Get.offAllNamed('/home-guru');
      
    } catch (error) {
      // Handle error
      Get.snackbar(
        'Error',
        'Gagal membuat kelas: ${error.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Method untuk menyimpan kelas ke database
  Future<void> _saveKelasToDatabase() async {
    // Simulasi delay untuk API call
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Implement actual database/API logic here
    // Example:
    /*
    final kelasData = {
      'nama_kelas': namaKelasController.text.trim(),
      'tingkat_kelas': selectedTingkatKelas.value,
      'mata_pelajaran': selectedMataPelajaran.value,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    // Call your API or database service
    // await ApiService.createKelas(kelasData);
    // or
    // await DatabaseService.insertKelas(kelasData);
    */
    
    print('Kelas Data:');
    print('Nama Kelas: ${namaKelasController.text.trim()}');
    print('Tingkat Kelas: ${selectedTingkatKelas.value}');
    print('Mata Pelajaran: ${selectedMataPelajaran.value}');
  }

  // Method untuk membersihkan form
  void _clearForm() {
    namaKelasController.clear();
    namaKelas.value = '';
    selectedTingkatKelas.value = '';
    selectedMataPelajaran.value = '';
  }

  // Method untuk reset form (bisa dipanggil dari luar jika perlu)
  void resetForm() {
    _clearForm();
  }
}
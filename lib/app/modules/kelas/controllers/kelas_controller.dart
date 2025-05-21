import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KelasController extends GetxController {
  
  // Method to handle opening menu
  void openMenu() {
    // Show bottom sheet or dialog with menu options
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Kelas'),
              onTap: () {
                Get.back();
                // Add edit class logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt),
              title: const Text('Kelola Siswa'),
              onTap: () {
                Get.back();
                // Add manage students logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Lihat Presensi'),
              onTap: () {
                Get.back();
                // Add view attendance logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus Kelas', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                // Show delete confirmation dialog
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Show delete confirmation dialog
  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Kelas'),
        content: const Text('Apakah Anda yakin ingin menghapus kelas ini? Semua data akan terhapus permanen.'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Get.back();
              // Add delete logic here
              Get.back(); // Go back to previous screen after deletion
            },
          ),
        ],
      ),
    );
  }
}
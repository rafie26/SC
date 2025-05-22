import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  
  // Show student detail dialog
  void showStudentDetail(Map<String, String> student) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Student profile header
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.purple,
                child: Text(
                  student['name']!.substring(0, 1),
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Student name
              Text(
                student['name']!,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Student details - Changed NIM to NIS
              _buildDetailRow('NIS', student['nis']!),
              _buildDetailRow('Kelas', student['kelas']!),
              
              const SizedBox(height: 24),
              
              // Changed attendance action buttons to different options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttendanceButton('Nilai', Colors.blue, Icons.school_outlined),
                  _buildAttendanceButton('Profil', Colors.purple, Icons.person_outline),
                  _buildAttendanceButton('Laporan', Colors.green, Icons.assignment_outlined),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper widget for student detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for attendance action buttons (now repurposed for different actions)
  Widget _buildAttendanceButton(String label, Color color, IconData icon) {
    return InkWell(
      onTap: () {
        // Handle button tap and close dialog
        Get.back();
        Get.snackbar(
          'Aksi',
          'Menu $label berhasil dibuka',
          backgroundColor: color.withOpacity(0.2),
          colorText: color,
          duration: const Duration(seconds: 2),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
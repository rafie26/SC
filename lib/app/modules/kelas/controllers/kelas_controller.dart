import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class KelasController extends GetxController {
  
  // Observable for managing student selection mode
  var isManagingStudents = false.obs;
  var selectedStudents = <int>[].obs;
  
  // Observable for class code
  var classCode = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    generateClassCode();
  }
  
  // Generate random class code
  void generateClassCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(DateTime.now().millisecondsSinceEpoch + i) % chars.length];
    }
    classCode.value = code;
  }
  
  // Method to toggle student management mode
  void toggleStudentManagement() {
    isManagingStudents.value = !isManagingStudents.value;
    if (!isManagingStudents.value) {
      selectedStudents.clear();
    }
  }
  
  // Method to toggle student selection
  void toggleStudentSelection(int index) {
    if (selectedStudents.contains(index)) {
      selectedStudents.remove(index);
    } else {
      selectedStudents.add(index);
    }
  }
  
  // Method to delete selected students
  void deleteSelectedStudents() {
    if (selectedStudents.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Pilih siswa yang ingin dihapus terlebih dahulu',
        backgroundColor: Colors.orange.withOpacity(0.2),
        colorText: Colors.orange,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    _showDeleteStudentsConfirmation();
  }
  
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
            // Header
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.blue),
              title: const Text('Kode Kelas'),
              subtitle: const Text('Lihat atau bagikan kode kelas'),
              onTap: () {
                Get.back();
                showClassCode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt),
              title: const Text('Kelola Siswa'),
              subtitle: const Text('Pilih dan hapus siswa'),
              onTap: () {
                Get.back();
                toggleStudentManagement();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus Kelas', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Hapus kelas secara permanen', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Show class code dialog
  void showClassCode() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // QR Code icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Kode Kelas',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                'Bagikan kode ini kepada siswa untuk bergabung ke kelas',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Class code display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                      classCode.value,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.blue,
                      ),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: classCode.value));
                        Get.snackbar(
                          'Berhasil',
                          'Kode kelas berhasil disalin',
                          backgroundColor: Colors.green.withOpacity(0.2),
                          colorText: Colors.green,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: Text(
                        'Salin',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        generateClassCode();
                        Get.snackbar(
                          'Berhasil',
                          'Kode kelas baru telah dibuat',
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          colorText: Colors.blue,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(
                        'Buat Baru',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
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
  
  // Show join class dialog (for students)
  void showJoinClassDialog() {
    final TextEditingController codeController = TextEditingController();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Join icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_add,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Bergabung ke Kelas',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                'Masukkan kode kelas yang diberikan oleh guru',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Code input field
              TextField(
                controller: codeController,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan Kode Kelas',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[400],
                    letterSpacing: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        String code = codeController.text.trim();
                        if (code.length != 6) {
                          Get.snackbar(
                            'Error',
                            'Kode kelas harus 6 karakter',
                            backgroundColor: Colors.red.withOpacity(0.2),
                            colorText: Colors.red,
                            duration: const Duration(seconds: 2),
                          );
                          return;
                        }
                        
                        // Here you would validate the code with your backend
                        // For now, we'll just show success message
                        Get.back();
                        Get.snackbar(
                          'Berhasil',
                          'Berhasil bergabung ke kelas dengan kode: $code',
                          backgroundColor: Colors.green.withOpacity(0.2),
                          colorText: Colors.green,
                          duration: const Duration(seconds: 3),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Bergabung',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Show delete confirmation dialog
  void _showDeleteConfirmation() {
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
              // Warning icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Hapus Kelas',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                'Apakah Anda yakin ingin menghapus kelas ini? Semua data akan terhapus permanen.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Confirmation buttons
              Row(
                children: [
                  Expanded(
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
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        // Add delete logic here
                        Get.back(); // Go back to previous screen after deletion
                        Get.snackbar(
                          'Berhasil',
                          'Kelas berhasil dihapus',
                          backgroundColor: Colors.red.withOpacity(0.2),
                          colorText: Colors.red,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Hapus',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Show delete students confirmation dialog
  void _showDeleteStudentsConfirmation() {
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
              // Warning icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Hapus Siswa',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                'Apakah Anda yakin ingin menghapus ${selectedStudents.length} siswa yang dipilih? Data siswa akan terhapus permanen.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Confirmation buttons
              Row(
                children: [
                  Expanded(
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
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        // Add delete logic here
                        Get.snackbar(
                          'Berhasil',
                          '${selectedStudents.length} siswa berhasil dihapus',
                          backgroundColor: Colors.red.withOpacity(0.2),
                          colorText: Colors.red,
                          duration: const Duration(seconds: 2),
                        );
                        selectedStudents.clear();
                        isManagingStudents.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Hapus',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Show student detail dialog
  void showStudentDetail(Map<String, String> student) {
    // Use noAbsen as is (keeping it as number)
    String noAbsen = student['noAbsen'] ?? '1';
    
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
              
              // Student details
              _buildDetailRow('No. Absen', noAbsen),
              _buildDetailRow('NIS', student['nis']!),
              _buildDetailRow('Kelas', student['kelas']!),
              
              const SizedBox(height: 24),
              
              // Action buttons row
              Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
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
}
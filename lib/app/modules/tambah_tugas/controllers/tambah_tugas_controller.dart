import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahTugasController extends GetxController {
  // Form key untuk validasi
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  
  // Observable variables
  final selectedSubject = ''.obs;
  final selectedKelas = ''.obs;
  final selectedDeadline = Rx<DateTime?>(null);
  final isLoading = false.obs;
  
  // File attachment variables
  final attachedFiles = <Map<String, dynamic>>[].obs;
  final isUploadingFile = false.obs;
  
  // Data lists (simulasi data)
  final List<String> subjectList = [
    'Matematika',
    'Bahasa Indonesia',
    'Bahasa Inggris',
    'IPA',
    'IPS',
    'Seni Budaya',
    'Pendidikan Jasmani',
    'PKN',
    'Agama',
    'TIK'
  ];
  
  final List<String> kelasList = [
    '8B',
    '8D',
    '9D'

  ];
  
  // Simulasi file types yang diizinkan
  final List<String> allowedFileTypes = [
    'pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'zip', 'rar'
  ];
  
  // Simulasi file examples untuk random selection
  final List<Map<String, dynamic>> sampleFiles = [
    {
      'name': 'Panduan_Tugas_Matematika.pdf',
      'type': 'pdf',
      'size': '2.5 MB'
    },
    {
      'name': 'Template_Laporan.docx',
      'type': 'docx',
      'size': '1.2 MB'
    },
    {
      'name': 'Contoh_Soal.jpg',
      'type': 'jpg',
      'size': '850 KB'
    },
    {
      'name': 'Materi_Pembelajaran.zip',
      'type': 'zip',
      'size': '5.4 MB'
    },
    {
      'name': 'Rubrik_Penilaian.pdf',
      'type': 'pdf',
      'size': '1.8 MB'
    },
    {
      'name': 'Format_Presentasi.png',
      'type': 'png',
      'size': '1.1 MB'
    },
  ];
  
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data jika diperlukan
    debugPrint('TambahTugasController initialized');
  }
  
  @override
  void onClose() {
    // Dispose controllers untuk mencegah memory leak
    judulController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
  
  // Method untuk set mata pelajaran yang dipilih
  void setSelectedSubject(String subject) {
    selectedSubject.value = subject;
    debugPrint('Selected subject: $subject');
  }
  
  // Method untuk set kelas yang dipilih
  void setSelectedKelas(String kelas) {
    selectedKelas.value = kelas;
    debugPrint('Selected kelas: $kelas');
  }
  
  // Method untuk memilih tanggal deadline
  Future<void> pickDeadlineDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C1FB4),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      selectedDeadline.value = picked;
      debugPrint('Selected deadline: ${picked.toString()}');
    }
  }
  
  // Method untuk memilih file (simulasi)
  Future<void> pickFile() async {
    if (attachedFiles.length >= 5) {
      Get.snackbar(
        'Batas File',
        'Maksimal 5 file yang dapat dilampirkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
        icon: const Icon(Icons.warning, color: Colors.orange),
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    isUploadingFile.value = true;
    
    try {
      // Simulasi delay upload
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Random pilih sample file
      final randomFile = sampleFiles[DateTime.now().millisecond % sampleFiles.length];
      
      // Generate unique ID untuk file
      final String fileId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Buat file object
      final Map<String, dynamic> newFile = {
        'id': fileId,
        'name': randomFile['name'],
        'type': randomFile['type'],
        'size': randomFile['size'],
        'uploadedAt': DateTime.now().toIso8601String(),
      };
      
      // Tambahkan ke list
      attachedFiles.add(newFile);
      
      Get.snackbar(
        'Berhasil',
        'File ${newFile['name']} berhasil dilampirkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 2),
      );
      
      debugPrint('File attached: ${newFile.toString()}');
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal melampirkan file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: const Icon(Icons.error, color: Colors.red),
      );
      debugPrint('Error picking file: $e');
    } finally {
      isUploadingFile.value = false;
    }
  }
  
  // Method untuk menghapus file yang dipilih
  void removeFile(String fileId) {
    try {
      final fileIndex = attachedFiles.indexWhere((file) => file['id'] == fileId);
      if (fileIndex != -1) {
        final fileName = attachedFiles[fileIndex]['name'];
        attachedFiles.removeAt(fileIndex);
        
        Get.snackbar(
          'File Dihapus',
          'File $fileName telah dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[800],
          icon: const Icon(Icons.info, color: Colors.blue),
          duration: const Duration(seconds: 2),
        );
        
        debugPrint('File removed: $fileName');
      }
    } catch (e) {
      debugPrint('Error removing file: $e');
    }
  }
  
  // Method untuk validasi form
  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    
    if (selectedSubject.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Mata pelajaran harus dipilih',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return false;
    }
    
    if (selectedKelas.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Kelas harus dipilih',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return false;
    }
    
    if (selectedDeadline.value == null) {
      Get.snackbar(
        'Error',
        'Batas waktu harus dipilih',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return false;
    }
    
    return true;
  }
  
  // Method untuk submit tugas (simulasi)
  Future<void> submitTugas() async {
    if (!_validateForm()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Simulasi proses upload/submit (delay 2 detik)
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulasi data yang akan dikirim
      Map<String, dynamic> tugasData = {
        'judul': judulController.text.trim(),
        'mataPelajaran': selectedSubject.value,
        'kelas': selectedKelas.value,
        'deskripsi': deskripsiController.text.trim(),
        'deadline': selectedDeadline.value?.toIso8601String(),
        'attachedFiles': attachedFiles.map((file) => {
          'id': file['id'],
          'name': file['name'],
          'type': file['type'],
          'size': file['size'],
        }).toList(),
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      debugPrint('Tugas data: $tugasData');
      
      // Simulasi berhasil
      Get.snackbar(
        'Berhasil',
        'Tugas berhasil dibuat dengan ${attachedFiles.length} file lampiran!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 3),
      );
      
      // Reset form setelah berhasil
      _resetForm();
      
      // Kembali ke halaman sebelumnya setelah delay singkat
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
      
    } catch (e) {
      debugPrint('Error submitting tugas: $e');
      Get.snackbar(
        'Error',
        'Gagal membuat tugas: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: const Icon(Icons.error, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method untuk reset form
  void _resetForm() {
    judulController.clear();
    deskripsiController.clear();
    selectedSubject.value = '';
    selectedKelas.value = '';
    selectedDeadline.value = null;
    attachedFiles.clear();
    formKey.currentState?.reset();
    debugPrint('Form reset');
  }
  
  // Method untuk simulasi validasi real-time
  void onJudulChanged(String value) {
    debugPrint('Judul changed: $value');
  }
  
  void onDeskripsiChanged(String value) {
    debugPrint('Deskripsi changed: $value');
  }
  
  // Method untuk mendapatkan total ukuran file
  String getTotalFileSize() {
    if (attachedFiles.isEmpty) return '0 MB';
    
    // Simulasi perhitungan total size (dalam praktik nyata perlu parsing size string)
    final totalFiles = attachedFiles.length;
    return '${(totalFiles * 2.5).toStringAsFixed(1)} MB'; // Simulasi rata-rata 2.5MB per file
  }

}
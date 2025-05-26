import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../materi_model.dart';

// Simulasi model file
class SimulatedFile {
  final String name;
  final int size;
  final String path;

  SimulatedFile({
    required this.name,
    required this.size,
    required this.path,
  });
}

class TambahDetailController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Observable variables
  var selectedFile = Rxn<SimulatedFile>();
  var isLoading = false.obs;
  
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Pick file (simulasi)
  Future<void> pickFile() async {
    try {
      // Simulasi loading
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Daftar file simulasi yang lebih bervariasi
      final simulatedFiles = [
        SimulatedFile(name: 'Matematika_Kelas_7_Aljabar.pdf', size: 2048576, path: '/documents/math_7.pdf'),
        SimulatedFile(name: 'Video_Pembelajaran_IPA_Fisika.mp4', size: 15728640, path: '/videos/science_physics.mp4'),
        SimulatedFile(name: 'Presentasi_Bahasa_Indonesia_Puisi.pptx', size: 5242880, path: '/presentations/bahasa_puisi.pptx'),
        SimulatedFile(name: 'Soal_Latihan_Matematika_Geometri.docx', size: 1048576, path: '/documents/soal_geometri.docx'),
        SimulatedFile(name: 'Materi_PKN_Pancasila_dan_UUD.pdf', size: 3145728, path: '/documents/pkn_pancasila.pdf'),
        SimulatedFile(name: 'Video_Seni_Tari_Tradisional.mov', size: 25165824, path: '/videos/seni_tari.mov'),
        SimulatedFile(name: 'Modul_IPS_Sejarah_Indonesia.pdf', size: 4194304, path: '/documents/ips_sejarah.pdf'),
        SimulatedFile(name: 'Audio_Pembelajaran_Bahasa_Inggris.mp3', size: 8388608, path: '/audio/english_listening.mp3'),
      ];
      
      // Pilih file random
      final randomFile = simulatedFiles[DateTime.now().millisecond % simulatedFiles.length];
      selectedFile.value = randomFile;
      
      Get.snackbar(
        'File Dipilih',
        'File ${selectedFile.value!.name} berhasil dipilih',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Remove selected file
  void removeFile() {
    selectedFile.value = null;
  }

  // Get file type from extension (updated to handle more types)
  String getFileType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
      case 'wmv':
        return 'Video';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint';
      case 'doc':
      case 'docx':
        return 'Document';
      case 'mp3':
      case 'wav':
      case 'aac':
        return 'Audio';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'Image';
      default:
        return 'File';
    }
  }

  // Format file size
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // Validate form
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    
    if (selectedFile.value == null) {
      Get.snackbar(
        'Validasi Error',
        'Pilih file materi terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }

  // Save materi
  Future<void> saveMateri() async {
    if (!validateForm()) return;
    
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Create new materi model
      final newMateri = MateriModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        description: descriptionController.text,
        subject: 'General', // Default subject since form is removed
        kelas: 'All', // Default class since form is removed
        type: getFileType(selectedFile.value!.name),
        fileName: selectedFile.value!.name,
        fileSize: formatFileSize(selectedFile.value!.size),
        uploadDate: _formatDate(DateTime.now()),
        views: 0,
      );
      
      // Here you would typically save to your backend/database
      // For now, we'll just show success message
      
      Get.snackbar(
        'Berhasil',
        'Materi berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Clear form after successful save
      clearForm();
      
      // Navigate back and return the created material
      Get.back(result: newMateri);
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan materi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Format date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedFile.value = null;
  }
}
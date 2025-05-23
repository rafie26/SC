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
  var selectedSubject = 'Pilih Mata Pelajaran'.obs;
  var selectedClass = 'Pilih Kelas'.obs;
  var selectedFile = Rxn<SimulatedFile>();
  var isLoading = false.obs;
  
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Lists for dropdowns
  final subjectList = [
    'Pilih Mata Pelajaran',
    'Matematika',
    'Bahasa Indonesia',
    'Bahasa Inggris',
    'IPA',
    'IPS',
    'PKN',
    'Seni Budaya',
    'Penjas',
    'Agama',
  ].obs;
  
  final classList = [
    'Pilih Kelas',
    'Kelas 7',
    'Kelas 8',
    'Kelas 9',
  ].obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Set selected subject
  void setSelectedSubject(String subject) {
    selectedSubject.value = subject;
  }

  // Set selected class
  void setSelectedClass(String kelas) {
    selectedClass.value = kelas;
  }

  // Pick file (simulasi)
  Future<void> pickFile() async {
    try {
      // Simulasi loading
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Daftar file simulasi
      final simulatedFiles = [
        SimulatedFile(name: 'Matematika_Kelas_5.pdf', size: 2048576, path: '/documents/math.pdf'),
        SimulatedFile(name: 'Video_Pembelajaran_IPA.mp4', size: 15728640, path: '/videos/science.mp4'),
        SimulatedFile(name: 'Presentasi_Bahasa_Indonesia.pptx', size: 5242880, path: '/presentations/bahasa.pptx'),
        SimulatedFile(name: 'Soal_Latihan_Matematika.docx', size: 1048576, path: '/documents/soal.docx'),
        SimulatedFile(name: 'Materi_PKN_Pancasila.pdf', size: 3145728, path: '/documents/pkn.pdf'),
        SimulatedFile(name: 'Video_Seni_Tari.mov', size: 25165824, path: '/videos/seni.mov'),
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

  // Get file type from extension
  String getFileType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'Video';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint';
      case 'doc':
      case 'docx':
        return 'Document';
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
    
    if (selectedSubject.value == 'Pilih Mata Pelajaran') {
      Get.snackbar(
        'Validasi Error',
        'Pilih mata pelajaran terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (selectedClass.value == 'Pilih Kelas') {
      Get.snackbar(
        'Validasi Error',
        'Pilih kelas terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
        subject: selectedSubject.value,
        kelas: selectedClass.value,
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
        duration: const Duration(seconds: 2),
      );
      
      // Navigate back and refresh the previous page
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
    selectedSubject.value = 'Pilih Mata Pelajaran';
    selectedClass.value = 'Pilih Kelas';
    selectedFile.value = null;
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahKalenderController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Observable variables
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
  var selectedColor = const Color(0xFF6C1FB4).obs;
  var isAllDay = false.obs;
  
  // Available colors for events
  final List<Color> availableColors = [
    const Color(0xFF6C1FB4), // Purple (default)
    const Color(0xFF4CAF50), // Green
    const Color(0xFF2196F3), // Blue
    const Color(0xFFFF9800), // Orange
    const Color(0xFFF44336), // Red
    const Color(0xFF9C27B0), // Deep Purple
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFFFFEB3B), // Yellow
  ];
  
  @override
  void onInit() {
    super.onInit();
    // If there's a selected date from calendar, use it
    if (Get.arguments != null && Get.arguments['selectedDate'] != null) {
      selectedDate.value = Get.arguments['selectedDate'];
    }
  }
  
  @override
  void onClose() {
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
  
  // Date picker
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
      selectedDate.value = picked;
    }
  }
  
  // Time picker
  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedTime.value,
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
      selectedTime.value = picked;
    }
  }
  
  // Color selection
  void selectColor(Color color) {
    selectedColor.value = color;
  }
  
  // Toggle all day
  void toggleAllDay(bool value) {
    isAllDay.value = value;
  }
  
  // Format date
  String getFormattedDate() {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${selectedDate.value.day} ${months[selectedDate.value.month - 1]} ${selectedDate.value.year}';
  }
  
  // Format time
  String getFormattedTime() {
    final hour = selectedTime.value.hour.toString().padLeft(2, '0');
    final minute = selectedTime.value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  // Validation
  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Judul acara tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    
    if (locationController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Lokasi acara tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    
    return true;
  }
  
  // Save event
  void saveEvent() {
    if (!validateForm()) return;
    
    // Create event object
    final event = {
      'title': titleController.text.trim(),
      'location': locationController.text.trim(),
      'description': descriptionController.text.trim(),
      'date': selectedDate.value,
      'time': isAllDay.value ? 'Sepanjang hari' : getFormattedTime(),
      'color': selectedColor.value,
      'isAllDay': isAllDay.value,
    };
    
    // Show loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C1FB4),
        ),
      ),
      barrierDismissible: false,
    );
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); // Close loading dialog
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Acara berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
      // Navigate back with result
      Get.back(result: event);
    });
  }
  
  // Cancel and go back
  void cancelAndGoBack() {
    if (titleController.text.isNotEmpty || 
        locationController.text.isNotEmpty || 
        descriptionController.text.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin membatalkan? Data yang sudah diisi akan hilang.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Go back to calendar
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        ),
      );
    } else {
      Get.back();
    }
  }
}
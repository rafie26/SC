import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilController extends GetxController {
  // Observable profile data
  var profileData = <String, String>{
    'name': 'Rafi Guru',
    'role': 'Teacher',
    'fullName': 'Rafi Iqbal Firmansyah',
    'email': 'rafi.guru@sevenconnect.com',
    'phone': '+62 895-6119-99186',
    'subject': 'Matematika',
    'classes': 'X RPL B',
  }.obs;

  var profileImagePath = 'assets/Rafi.jpg'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize profile data if needed
    loadProfileData();
  }

  void loadProfileData() {
    // Here you can load profile data from API or local storage
    // For now, we're using default values
  }

  void showEditDialog(String title, String key) {
    final TextEditingController controller = TextEditingController(
      text: profileData[key] ?? '',
    );
    
    Get.dialog(
      AlertDialog(
        title: Text(
          'Edit $title',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6C1FB4)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              updateProfileData(key, controller.text);
              Get.back();
              showSuccessMessage('$title berhasil diubah');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C1FB4),
            ),
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void showDatePickerDialog() async {
    final DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(1985, 1, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (selectedDate != null) {
      String formattedDate = _formatDate(selectedDate);
      updateProfileData('birthDate', formattedDate);
      showSuccessMessage('Tanggal lahir berhasil diubah');
    }
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        height: 170,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Pilih Foto Profil',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => pickImageFromCamera(),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C1FB4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Color(0xFF6C1FB4),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kamera',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => pickImageFromGallery(),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C1FB4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Color(0xFF6C1FB4),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Galeri',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void pickImageFromCamera() {
    Get.back();
    // Here you would implement actual camera functionality
    // For now, we'll just show a message
    Get.snackbar(
      'Kamera',
      'Foto diambil dari kamera',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    
    // You can add image_picker package and implement:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.camera);
    // if (image != null) {
    //   profileImagePath.value = image.path;
    // }
  }

  void pickImageFromGallery() {
    Get.back();
    // Here you would implement actual gallery functionality
    // For now, we'll just show a message
    Get.snackbar(
      'Galeri',
      'Foto dipilih dari galeri',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    
    // You can add image_picker package and implement:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   profileImagePath.value = image.path;
    // }
  }

  void updateProfileData(String key, String value) {
    profileData[key] = value;
    profileData.refresh(); // Trigger UI update
  }

  void saveProfile() {
    // Here you would implement saving to API or local storage
    // For now, we'll just show a success message
    showSuccessMessage('Profil berhasil disimpan');
    
    // Example API call:
    // try {
    //   await ApiService.updateProfile(profileData);
    //   showSuccessMessage('Profil berhasil disimpan');
    // } catch (e) {
    //   showErrorMessage('Gagal menyimpan profil');
    // }
  }

  void showSuccessMessage(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
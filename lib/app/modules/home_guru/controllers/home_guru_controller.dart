
import 'package:get/get.dart';

class HomeGuruController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var profileImage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  // Load initial data
  void loadData() async {
    try {
      isLoading(true);
      
      // Here you can add API calls or data loading logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Set profile image (replace with actual image URL from your API)
      profileImage.value = '';
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
  
  // Method for navigating to the tambah-kelas page
  void navigateToTambahKelas() {
    // Using string constant for navigation to avoid import errors
    Get.toNamed('/tambah-kelas');
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;
  var isAnimating = false.obs;

  // List of page routes
  final List<String> routes = [
    '/kelas',
    '/cerita',
    '/tambah',
    '/obrolan',
    '/notifikasi',
  ];

  // List of pages to display (placeholder)
  final List<Widget> pages = [
    const Center(child: Text('Ruang Kelas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8A2BE2)))),
    const Center(child: Text('Cerita', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8A2BE2)))),
    const Center(child: Text('Tambah', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8A2BE2)))),
    const Center(child: Text('Obrolan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8A2BE2)))),
    const Center(child: Text('Notifikasi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8A2BE2)))),
  ];

  @override
  void onInit() {
    super.onInit();
    // Update selected index when controller initializes
    updateSelectedIndexFromRoute();
  }

  void changeIndex(int index) {
    // Add animation flag
    if (isAnimating.value || selectedIndex.value == index) return;
    
    isAnimating.value = true;
    selectedIndex.value = index;
    
    // Navigate using offAllNamed to replace current route and clear stack
    // This prevents navigation stack issues
    String route = routes[index];
    if (route.isNotEmpty) {
      Get.offAllNamed(route);
    }
    
    // Reset animation flag after delay
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating.value = false;
    });
  }

  // Simplified method without navigation stack issues
  void changeIndexSimple(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
  }

  // Alternative method: Use offNamed for single route replacement
  void changeIndexWithReplace(int index) {
    if (isAnimating.value || selectedIndex.value == index) return;
    
    isAnimating.value = true;
    selectedIndex.value = index;
    
    String route = routes[index];
    if (route.isNotEmpty) {
      Get.offNamed(route);
    }
    
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating.value = false;
    });
  }

  // Method to update selected index based on current route
  void updateSelectedIndexFromRoute() {
    String currentRoute = Get.currentRoute;
    int index = routes.indexOf(currentRoute);
    if (index != -1 && index != selectedIndex.value) {
      selectedIndex.value = index;
    }
  }

  // Method to handle back button specifically
  bool handleBackPress() {
    // If we're not on the first tab, go to first tab
    if (selectedIndex.value != 0) {
      changeIndex(0);
      return true; // Prevent default back behavior
    }
    return false; // Allow default back behavior (exit app)
  }
}
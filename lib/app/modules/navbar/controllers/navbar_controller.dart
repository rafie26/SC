import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;
  var isAnimating = false.obs;

  // List of page routes
  final List<String> routes = [
    '/kelas',
    '/cerita',
    '/tambah', // Updated to have a route
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

  void changeIndex(int index) {
    // Add animation flag
    if (isAnimating.value || selectedIndex.value == index) return;
    
    isAnimating.value = true;
    selectedIndex.value = index;
    
    // Navigate to the appropriate route
    String route = routes[index];
    if (route.isNotEmpty) {
      Get.toNamed(route);
    }
    
    // Reset animation flag after delay
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating.value = false;
    });
  }
}
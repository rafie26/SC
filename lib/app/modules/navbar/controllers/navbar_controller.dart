import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;

  // List of pages to display
  final List<Widget> pages = [
    const Center(child: Text('Ruang Kelas', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Cerita', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Tambah', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Obrolan', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Notifikasi', style: TextStyle(fontSize: 24))),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
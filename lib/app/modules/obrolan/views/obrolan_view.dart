import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/obrolan_controller.dart';
import '../../navbar/controllers/navbar_controller.dart';

class ObrolanView extends GetView<ObrolanController> {
  const ObrolanView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Make sure NavbarController is initialized
    if (!Get.isRegistered<NavbarController>()) {
      Get.put(NavbarController());
    }
    
    // Get the NavbarController
    final NavbarController navbarController = Get.find<NavbarController>();
    
    return WillPopScope(
      onWillPop: () async {
        // Reset navbar ke index 0 (Ruang Kelas) saat back button ditekan
        navbarController.selectedIndex.value = 0;
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Update navbar index to Ruang Kelas (0) before navigation
              navbarController.selectedIndex.value = 0;
              Get.toNamed('/home-guru');
            },
          ),
          title: Text(
            'Obrolan',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBoardCast(),
              const SizedBox(height: 20),
              _buildChatSection(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(navbarController),
      ),
    );
  }

  Widget _buildBoardCast() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Pengumuman Kelas 9B',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Ujian Tengah Semester',
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ujian akan dilaksanakan pada tanggal 15-20 Juli 2025. Harap persiapkan diri dengan baik.',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '2 jam yang lalu',
                  style: GoogleFonts.poppins(
                    fontSize: 10.0,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              // Action untuk membuat pengumuman baru
              _showNewAnnouncementDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Buat Pengumuman',
                    style: GoogleFonts.poppins(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grup Kelas',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildChatItem(),
      ],
    );
  }

  Widget _buildChatItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            Icons.group,
            color: Colors.purple.shade600,
            size: 28,
          ),
        ),
        title: Text(
          'Grup 9B',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Ahmad: Pak, tugas yang kemarin sudah harus dikumpulkan hari ini kan?',
              style: GoogleFonts.poppins(
                fontSize: 13.0,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '10:30 AM',
              style: GoogleFonts.poppins(
                fontSize: 11.0,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '3',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // Navigasi ke halaman grub
          Get.toNamed('/grub');
        },
      ),
    );
  }

  void _showNewAnnouncementDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text(
          'Buat Pengumuman Baru',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Pengumuman',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Isi Pengumuman',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
            ],
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
              if (titleController.text.isNotEmpty && 
                  contentController.text.isNotEmpty) {
                // Logic untuk menyimpan pengumuman
                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Pengumuman berhasil dibuat',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: Text(
              'Kirim',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(NavbarController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(controller, 0, 'Ruang Kelas', Icons.people, Colors.black),
            _buildNavItem(controller, 1, 'Cerita', Icons.image, Colors.black),
            _buildAddButton(controller),
            _buildNavItem(controller, 3, 'Obrolan', Icons.chat_bubble_outline, Colors.purple),
            _buildNavItem(controller, 4, 'Notifikasi', Icons.notifications_none, Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(NavbarController controller, int index, String label, IconData icon, Color defaultColor) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final color = isSelected ? Colors.purple : defaultColor;
      
      return InkWell(
        onTap: () {
          controller.changeIndex(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddButton(NavbarController controller) {
    return InkWell(
      onTap: () {
        controller.changeIndex(2);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
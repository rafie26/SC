import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notifikasi_controller.dart';
import '../../navbar/controllers/navbar_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});
  
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
        // Update navbar index to Ruang Kelas (0) before navigation
        navbarController.changeIndex(0);
        // Allow the pop to continue
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Update navbar index to Ruang Kelas (0) before navigation
              navbarController.changeIndex(0);
              Get.toNamed('/home-guru');
            },
          ),
          title: Text(
            'Notifikasi',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                _showNotificationOptions();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationList(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(navbarController),
      ),
    );
  }

  Widget _buildNotificationList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifikasi Terbaru',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                _markAllAsRead();
              },
              child: Text(
                'Tandai Semua Dibaca',
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Pengumuman Notifications
        _buildNotificationItem(
          type: 'announcement',
          title: 'Pengumuman Baru',
          subtitle: 'Jadwal Ujian Tengah Semester',
          content: 'Ujian akan dilaksanakan pada tanggal 15-20 Juli 2025...',
          time: '2 jam yang lalu',
          isRead: false,
          icon: Icons.campaign,
          iconColor: Colors.purple,
        ),
        
        // Group Chat Notifications
        _buildNotificationItem(
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Ahmad mengirim pesan',
          content: 'Pak, tugas yang kemarin sudah harus dikumpulkan hari ini kan?',
          time: '30 menit yang lalu',
          isRead: false,
          icon: Icons.group,
          iconColor: Colors.green,
        ),
        
        _buildNotificationItem(
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Siti mengirim pesan',
          content: 'Terima kasih pak atas penjelasannya tadi',
          time: '1 jam yang lalu',
          isRead: false,
          icon: Icons.group,
          iconColor: Colors.green,
        ),
        
        _buildNotificationItem(
          type: 'assignment',
          title: 'Tugas Baru',
          subtitle: 'Matematika - Kelas 9B',
          content: 'Tugas Aljabar Bab 3 telah diberikan',
          time: '3 jam yang lalu',
          isRead: true,
          icon: Icons.assignment,
          iconColor: Colors.orange,
        ),
        
        _buildNotificationItem(
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Budi mengirim pesan',
          content: 'Selamat pagi pak, izin bertanya tentang materi kemarin',
          time: '5 jam yang lalu',
          isRead: true,
          icon: Icons.group,
          iconColor: Colors.green,
        ),
        
        _buildNotificationItem(
          type: 'announcement',
          title: 'Pengumuman',
          subtitle: 'Perubahan Jadwal Pelajaran',
          content: 'Jadwal pelajaran hari Jumat mengalami perubahan...',
          time: '1 hari yang lalu',
          isRead: true,
          icon: Icons.campaign,
          iconColor: Colors.purple,
        ),
        
        _buildNotificationItem(
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Lisa mengirim pesan',
          content: 'Pak, kapan jadwal remedial matematika?',
          time: '1 hari yang lalu',
          isRead: true,
          icon: Icons.group,
          iconColor: Colors.green,
        )
      ],
    );
  }

  Widget _buildNotificationItem({
    required String type,
    required String title,
    required String subtitle,
    required String content,
    required String time,
    required bool isRead,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? Colors.grey.shade200 : Colors.blue.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _handleNotificationTap(type);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 10.0,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(String type) {
    switch (type) {
      case 'group_message':
        Get.toNamed('/grub');
        break;
      case 'announcement':
        Get.toNamed('/obrolan');
        break;
      case 'assignment':
        Get.toNamed('/tugas');
        break;
      default:
        // Handle other types or show detail
        _showNotificationDetail();
    }
  }

  void _showNotificationDetail() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Detail Notifikasi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Fitur detail notifikasi akan segera tersedia.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Tutup',
              style: GoogleFonts.poppins(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pengaturan Notifikasi',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.mark_email_read, color: Colors.green),
              title: Text(
                'Tandai Semua Dibaca',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.back();
                _markAllAsRead();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'Hapus Semua Notifikasi',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.back();
                _clearAllNotifications();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: Text(
                'Pengaturan',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.back();
                Get.toNamed('/pengaturan-notifikasi');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _markAllAsRead() {
    Get.snackbar(
      'Berhasil',
      'Semua notifikasi telah ditandai dibaca',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Hapus Semua Notifikasi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua notifikasi?',
          style: GoogleFonts.poppins(),
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
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Semua notifikasi telah dihapus',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Hapus',
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
            _buildNavItem(controller, 3, 'Obrolan', Icons.chat_bubble_outline, Colors.black),
            _buildNavItem(controller, 4, 'Notifikasi', Icons.notifications_none, Colors.purple),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/kelas_controller.dart';
import '../../navbar/controllers/navbar_controller.dart';

class KelasView extends GetView<KelasController> {
  const KelasView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Make sure NavbarController is initialized
    if (!Get.isRegistered<NavbarController>()) {
      Get.put(NavbarController());
    }
    // Get the NavbarController
    final NavbarController navbarController = Get.find<NavbarController>();
    
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Disable default back button
        title: Text(
          'X RPL B',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.toNamed('/home-guru'), // Changed to navigate to /home_guru
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Add your menu logic here
              controller.openMenu();
            },
          ),
        ],
      ),
      // Remove the padding around the body content
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0), // Add padding directly to GridView instead
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.8, // Adjusted ratio since we removed status
              ),
              itemCount: 15, // 3 horizontal x 5 vertical
              itemBuilder: (context, index) {
                // Dummy data for student names and details
                final students = [
                  {'name': 'Ahmad Rizki', 'nis': '0001', 'kelas': 'X RPL B'},
                  {'name': 'Budi Santoso', 'nis': '0002', 'kelas': 'X RPL B'},
                  {'name': 'Cindy Permata', 'nis': '0003', 'kelas': 'X RPL B'},
                  {'name': 'Deni Kurniawan', 'nis': '0004', 'kelas': 'X RPL B'},
                  {'name': 'Eva Sari', 'nis': '0005', 'kelas': 'X RPL B'},
                  {'name': 'Faisal Rahman', 'nis': '0006', 'kelas': 'X RPL B'},
                  {'name': 'Gita Puspita', 'nis': '0007', 'kelas': 'X RPL B'},
                  {'name': 'Hadi Wijaya', 'nis': '0008', 'kelas': 'X RPL B'},
                  {'name': 'Indah Pertiwi', 'nis': '0009', 'kelas': 'X RPL B'},
                  {'name': 'Joko Susilo', 'nis': '0010', 'kelas': 'X RPL B'},
                  {'name': 'Kartika Dewi', 'nis': '0011', 'kelas': 'X RPL B'},
                  {'name': 'Lukman Hakim', 'nis': '0012', 'kelas': 'X RPL B'},
                  {'name': 'Melly Goeslaw', 'nis': '0013', 'kelas': 'X RPL B'},
                  {'name': 'Nugroho Adi', 'nis': '0014', 'kelas': 'X RPL B'},
                  {'name': 'Olivia Putri', 'nis': '0015', 'kelas': 'X RPL B'},
                ];
                
                final student = students[index];
                final String avatarText = student['name']!.substring(0, 1);
                
                return InkWell(
                  onTap: () {
                    // Show student detail dialog when card is tapped
                    controller.showStudentDetail(student);
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar circle with first letter
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: getAvatarColor(index),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                avatarText,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Student name
                          Text(
                            student['name']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Student ID - Changed NIM to NIS
                          Text(
                            'NIS: ${student['nis']}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(navbarController),
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
            _buildNavItem(controller, 0, 'Ruang Kelas', Icons.people, Colors.purple),
            _buildNavItem(controller, 1, 'Cerita', Icons.image, Colors.black),
            _buildAddButton(controller),
            _buildNavItem(controller, 3, 'Obrolan', Icons.chat_bubble_outline, Colors.black),
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
  
  Color getAvatarColor(int index) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lightBlue,
      Colors.deepOrange,
      Colors.green,
      Colors.deepPurple,
    ];
    
    return colors[index % colors.length];
  }
}
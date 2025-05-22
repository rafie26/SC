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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show management toolbar when in student management mode
          Obx(() => controller.isManagingStudents.value 
            ? _buildManagementToolbar() 
            : const SizedBox.shrink()),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.85, // Adjusted for better consistency
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                return _buildStudentCard(index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(navbarController),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Obx(() => Text(
        controller.isManagingStudents.value 
          ? '${controller.selectedStudents.length} Dipilih'
          : 'X RPL B',
        style: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      )),
      centerTitle: true,
      leading: Obx(() => IconButton(
        icon: Icon(
          controller.isManagingStudents.value ? Icons.close : Icons.arrow_back, 
          color: Colors.black
        ),
        onPressed: () {
          if (controller.isManagingStudents.value) {
            controller.toggleStudentManagement();
          } else {
            Get.toNamed('/home-guru');
          }
        },
      )),
      actions: [
        Obx(() => controller.isManagingStudents.value
          ? IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => controller.deleteSelectedStudents(),
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => controller.openMenu(),
            )
        ),
      ],
    );
  }

  Widget _buildManagementToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.purple.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.purple,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Pilih siswa yang ingin dikelola',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(int index) {
    // Dummy data for student names and details
    final students = [
      {'name': 'Ahmad Rizki', 'nis': '0001', 'kelas': 'X RPL B', 'noAbsen': '1'},
      {'name': 'Budi Santoso', 'nis': '0002', 'kelas': 'X RPL B', 'noAbsen': '2'},
      {'name': 'Cindy Permata', 'nis': '0003', 'kelas': 'X RPL B', 'noAbsen': '3'},
      {'name': 'Deni Kurniawan', 'nis': '0004', 'kelas': 'X RPL B', 'noAbsen': '4'},
      {'name': 'Eva Sari', 'nis': '0005', 'kelas': 'X RPL B', 'noAbsen': '5'},
      {'name': 'Faisal Rahman', 'nis': '0006', 'kelas': 'X RPL B', 'noAbsen': '6'},
      {'name': 'Gita Puspita', 'nis': '0007', 'kelas': 'X RPL B', 'noAbsen': '7'},
      {'name': 'Hadi Wijaya', 'nis': '0008', 'kelas': 'X RPL B', 'noAbsen': '8'},
      {'name': 'Indah Pertiwi', 'nis': '0009', 'kelas': 'X RPL B', 'noAbsen': '9'},
      {'name': 'Joko Susilo', 'nis': '0010', 'kelas': 'X RPL B', 'noAbsen': '10'},
      {'name': 'Kartika Dewi', 'nis': '0011', 'kelas': 'X RPL B', 'noAbsen': '11'},
      {'name': 'Lukman Hakim', 'nis': '0012', 'kelas': 'X RPL B', 'noAbsen': '12'},
      {'name': 'Melly Goeslaw', 'nis': '0013', 'kelas': 'X RPL B', 'noAbsen': '13'},
      {'name': 'Nugroho Adi', 'nis': '0014', 'kelas': 'X RPL B', 'noAbsen': '14'},
      {'name': 'Olivia Putri', 'nis': '0015', 'kelas': 'X RPL B', 'noAbsen': '15'},
    ];
    
    final student = students[index];
    final String avatarText = student['name']!.substring(0, 1);
    
    return Obx(() {
      final isSelected = controller.selectedStudents.contains(index);
      final isManaging = controller.isManagingStudents.value;
      
      return InkWell(
        onTap: () {
          if (isManaging) {
            controller.toggleStudentSelection(index);
          } else {
            controller.showStudentDetail(student);
          }
        },
        child: Stack(
          children: [
            Container(
              // Fixed height and width for consistent card size
              height: double.infinity,
              width: double.infinity,
              child: Card(
                elevation: 2,
                margin: EdgeInsets.zero, // Remove default margin
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: isSelected 
                    ? const BorderSide(color: Colors.purple, width: 2)
                    : BorderSide.none,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isSelected 
                      ? Colors.purple.withOpacity(0.1) 
                      : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Consistent padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar circle with first letter
                        Container(
                          width: 50, // Fixed size for consistency
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? Colors.purple 
                              : getAvatarColor(index),
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
                        const SizedBox(height: 8), // Consistent spacing
                        // Student name with fixed height container
                        Container(
                          height: 32, // Fixed height for name area
                          child: Center(
                            child: Text(
                              student['name']!,
                              style: GoogleFonts.poppins(
                                fontSize: 13, // Slightly smaller for consistency
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.purple : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2, // Allow 2 lines for longer names
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Student ID with fixed styling
                        Text(
                          'NIS: ${student['nis']}',
                          style: GoogleFonts.poppins(
                            fontSize: 11, // Consistent small size
                            color: isSelected 
                              ? Colors.purple.withOpacity(0.8)
                              : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Selection indicator
            if (isManaging)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purple : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
                ),
              ),
          ],
        ),
      );
    });
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
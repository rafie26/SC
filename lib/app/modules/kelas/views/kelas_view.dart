import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/kelas_controller.dart';

class KelasView extends GetView<KelasController> {
  const KelasView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Disable default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            
            // Class name text
            Text(
              'X RPL B',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            // Menu button
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // Add your menu logic here
                controller.openMenu();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: 15, // 3 horizontal x 5 vertical
                itemBuilder: (context, index) {
                  // Dummy data for student names and details
                  final students = [
                    {'name': 'Ahmad Rizki', 'nim': '0001', 'status': 'Hadir'},
                    {'name': 'Budi Santoso', 'nim': '0002', 'status': 'Hadir'},
                    {'name': 'Cindy Permata', 'nim': '0003', 'status': 'Izin'},
                    {'name': 'Deni Kurniawan', 'nim': '0004', 'status': 'Hadir'},
                    {'name': 'Eva Sari', 'nim': '0005', 'status': 'Hadir'},
                    {'name': 'Faisal Rahman', 'nim': '0006', 'status': 'Alpha'},
                    {'name': 'Gita Puspita', 'nim': '0007', 'status': 'Hadir'},
                    {'name': 'Hadi Wijaya', 'nim': '0008', 'status': 'Hadir'},
                    {'name': 'Indah Pertiwi', 'nim': '0009', 'status': 'Hadir'},
                    {'name': 'Joko Susilo', 'nim': '0010', 'status': 'Izin'},
                    {'name': 'Kartika Dewi', 'nim': '0011', 'status': 'Hadir'},
                    {'name': 'Lukman Hakim', 'nim': '0012', 'status': 'Hadir'},
                    {'name': 'Melly Goeslaw', 'nim': '0013', 'status': 'Alpha'},
                    {'name': 'Nugroho Adi', 'nim': '0014', 'status': 'Hadir'},
                    {'name': 'Olivia Putri', 'nim': '0015', 'status': 'Hadir'},
                  ];
                  
                  final student = students[index];
                  final Color statusColor = getStatusColor(student['status']!);
                  final String avatarText = student['name']!.substring(0, 1);
                  
                  return Card(
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
                          // Student ID
                          Text(
                            'NIM: ${student['nim']}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              student['status']!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return Colors.green;
      case 'Izin':
        return Colors.orange;
      case 'Alpha':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
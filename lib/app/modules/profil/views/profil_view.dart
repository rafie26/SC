import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C1FB4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profil Saya',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF6C1FB4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    // Profile Picture
                    Obx(() => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: controller.profileImagePath.value.isNotEmpty
                            ? Image.asset(
                                controller.profileImagePath.value,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Color(0xFF6C1FB4),
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF6C1FB4),
                              ),
                      ),
                    )),
                    const SizedBox(height: 16),
                    // Name
                    Obx(() => Text(
                      controller.profileData['name'] ?? 'Nama Pengguna',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                    const SizedBox(height: 8),
                    // Role
                    Obx(() => Text(
                      controller.profileData['role'] ?? 'Role',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Statistics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() => StatisticItem(
                        icon: Icons.article_outlined,
                        count: controller.profileData['postsCount'] ?? 0,
                        label: 'Post',
                        color: const Color(0xFF6C1FB4),
                      )),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey[300],
                      ),
                      Obx(() => StatisticItem(
                        icon: Icons.favorite_outline,
                        count: controller.profileData['likesCount'] ?? 0,
                        label: 'Like',
                        color: Colors.red[400]!,
                      )),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey[300],
                      ),
                      Obx(() => StatisticItem(
                        icon: Icons.people_outline,
                        count: controller.profileData['friendsCount'] ?? 0,
                        label: 'Teman',
                        color: Colors.green[400]!,
                      )),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Profile Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Pribadi',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Profile Info Cards
                  Obx(() => ProfileInfoCard(
                    icon: Icons.person_outline,
                    title: 'Nama Lengkap',
                    value: controller.profileData['fullName'] ?? '',
                    onTap: () => controller.showEditDialog('Nama Lengkap', 'fullName'),
                  )),
                  
                  Obx(() => ProfileInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: controller.profileData['email'] ?? '',
                    onTap: () => controller.showEditDialog('Email', 'email'),
                  )),
                  
                  Obx(() => ProfileInfoCard(
                    icon: Icons.assignment_ind,
                    title: 'Nomer Induk',
                    value: controller.profileData['NI'] ?? '',
                    onTap: () => controller.showEditDialog('', 'NI'),
                  )),
                  
                  Obx(() => ProfileInfoCard(
                    icon: Icons.school_outlined,
                    title: 'Mata Pelajaran',
                    value: controller.profileData['subject'] ?? '',
                    onTap: () => controller.showEditDialog('Mata Pelajaran', 'subject'),
                  )),
                  
                  Obx(() => ProfileInfoCard(
                    icon: Icons.class_outlined,
                    title: 'Kelas yang Diampu',
                    value: controller.profileData['classes'] ?? '',
                    onTap: () => controller.showEditDialog('Kelas yang Diampu', 'classes'),
                  )),
                  

                  
                  const SizedBox(height: 30),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => controller.showImagePickerDialog(),
                          icon: const Icon(Icons.camera_alt, size: 20),
                          label: Text(
                            'Ubah Foto',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C1FB4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.saveProfile(),
                          icon: const Icon(Icons.save, size: 20),
                          label: Text(
                            'Simpan',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C1FB4),
                            side: const BorderSide(color: Color(0xFF6C1FB4)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Statistic Item Widget
class StatisticItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const StatisticItem({
    Key? key,
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Profile Info Card Widget
class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const ProfileInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C1FB4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF6C1FB4),
                  size: 22,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.edit_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
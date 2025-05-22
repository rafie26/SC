import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_guru_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeGuruView extends GetView<HomeGuruController> {
  const HomeGuruView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Custom AppBar with drop shadow that includes all icons
              CustomAppBar(controller: controller),
              
              // Main content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                      ),
                      const SizedBox(height: 20),
                      
                      // Class header section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Kelas',
                              style: GoogleFonts.poppins(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.navigateToTambahKelas,
                              child: Text(
                                '+ Tambahkan Kelas',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6C1FB4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // List of class items with navigable container
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            // Modified Class item with complete container
                            NavigableClassItem(
                              iconAsset: 'assets/icons/bumi.png',
                              className: 'X RPL B',
                              onTap: () {
                                // Navigate to Kelas page
                                Get.toNamed('/kelas');
                              },
                            ),
                            // Add more class items as needed
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          
          // Burger Menu Overlay
          Obx(() {
            if (controller.isMenuOpen.value) {
              return GestureDetector(
                onTap: controller.closeMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Stack(
                    children: [
                      // Menu Container
                      Positioned(
                        top: 120, // Position below the AppBar
                        right: 20,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Menu Header
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6C1FB4),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Menu Guru',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              
                              // Menu Items
                              MenuItemWidget(
                                icon: Icons.assignment,
                                title: 'Tugas',
                                onTap: controller.navigateToTugas,
                              ),
                              MenuItemWidget(
                                icon: Icons.book,
                                title: 'Materi',
                                onTap: controller.navigateToMateri,
                              ),
                              MenuItemWidget(
                                icon: Icons.calendar_today,
                                title: 'Kalender',
                                onTap: controller.navigateToKalender,
                              ),
                              MenuItemWidget(
                                icon: Icons.help_outline,
                                title: 'Bantuan',
                                onTap: controller.showBantuan,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

// Menu Item Widget
class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const MenuItemWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? Colors.red : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom AppBar Widget with profile, comment, and menu icons
class CustomAppBar extends StatelessWidget {
  final HomeGuruController controller;
  
  const CustomAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Increased height from 100 to 120
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50), // Adjusted padding for new height
        child: Row(
          children: [
            const SizedBox(width: 20),
            // Profile picture - now circular
            _buildProfilePic(controller),
            const SizedBox(width: 15),
            // Comments icon
            Image.asset(
              'assets/icons/vaadin_comments.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            // Menu burger icon - now with tap functionality
            GestureDetector(
              onTap: controller.toggleMenu,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.menu,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  // Profile picture widget - modified to be circular with Rafi.jpg
  Widget _buildProfilePic(HomeGuruController controller) {
    return Container(
      width: 50, // Slightly reduced width for better circular appearance
      height: 50, // Made it square for perfect circle
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle, // Changed to circle
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipOval( // Changed from ClipRRect to ClipOval for circular clipping
        child: Image.asset(
          'assets/Rafi.jpg', 
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image fails to load
            return const Icon(Icons.person, size: 24, color: Color.fromARGB(255, 255, 255, 255));
          },
        ),
      ),
    );
  }
}

// Class List Item Widget - Modified to be fully tappable
class NavigableClassItem extends StatelessWidget {
  final String iconAsset;
  final String className;
  final VoidCallback onTap;

  const NavigableClassItem({
    Key? key,
    required this.iconAsset,
    required this.className,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Row(
            children: [
              // Class icon (earth icon)
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Class name
              Expanded(
                child: Text(
                  className,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              // Forward arrow icon
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
      body: Column(
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
      height: 100,
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
        padding: const EdgeInsets.only(top: 40),
        child: Row(
          children: [
            const SizedBox(width: 20),
            // Profile picture
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
            // Menu burger icon
            const Icon(
              Icons.menu,
              size: 35,
              color: Colors.black,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  // Profile picture widget
  Widget _buildProfilePic(HomeGuruController controller) {
    return Container(
      width: 55,
      height: 49,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 112, 112, 112).withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: controller.profileImage.value.isEmpty
            ? const Icon(Icons.person, size: 24)
            : Image.network(
                controller.profileImage.value,
                fit: BoxFit.cover,
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cerita_controller.dart';
import '../../navbar/controllers/navbar_controller.dart';

class CeritaView extends GetView<CeritaController> {
  const CeritaView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Initialize controllers properly
    final ceritaController = Get.put(CeritaController());
    final navbarController = Get.put(NavbarController());
    
    // Make sure controller is ready
    return GetBuilder<CeritaController>(
      init: ceritaController,
      builder: (controller) {
        return _buildMainContent(navbarController);
      },
    );
  }
  
  Widget _buildMainContent(NavbarController navbarController) {
    
    return Scaffold(
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
          'X RPL B',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            // Header section with profile, text, and camera icon
          // Header section with profile, text, and camera icon - DYNAMIC HEIGHT
GetBuilder<CeritaController>(
  builder: (controller) {
    // Dynamic height: 150 normal, 270 when image selected
    final hasImage = controller.selectedImagePath.isNotEmpty;
    final containerHeight = hasImage ? 270.0 : 150.0;
    
    return Container(
      height: containerHeight,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // Profile picture - Changed to use asset
          Positioned(
            left: 20,
            top: 70,
            child: Container(
              width: 63,
              height: 63,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 31.5,
                backgroundImage: AssetImage('assets/Rafi.jpg'),
                backgroundColor: Colors.grey,
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback if asset image fails to load
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // "Apa Yang Terjadi ?" text - clickable
          Positioned(
            left: 100,
            top: 90,
            child: GestureDetector(
              onTap: () => _showPostDialog(Get.find<CeritaController>()),
              child: Text(
                'Apa Yang Terjadi ?',
                style: GoogleFonts.inter(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
          // Camera icon
          Positioned(
            left: 382,
            top: 90,
            child: GestureDetector(
              onTap: () {
                Get.find<CeritaController>().pickImage();
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.purple,
                size: 24,
              ),
            ),
          ),
          // Divider line - DYNAMIC POSITION
          Positioned(
            left: 25,
            top: hasImage ? 265 : 145, // Move down when image present
            child: Container(
              width: 395,
              height: 1,
              color: Colors.grey,
            ),
          ),
          // Show selected image preview if any - FULL SIZE BELOW PROFILE
          if (hasImage)
            Positioned(
              left: 20,
              top: 160,
              right: 20,
              child: Container(
                height: 100, // BIGGER HEIGHT for full view
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        controller.selectedImagePath,
                        width: double.infinity,
                        height: 100, // FULL HEIGHT
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => controller.clearSelectedImage(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  },
),
            // "Cerita" text
            Padding(
              padding: const EdgeInsets.only(left: 43, top: 16, bottom: 16),
              child: Text(
                'Cerita',
                style: GoogleFonts.inter(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Stories feed with new design - Changed to use assets
            Padding(
              padding: const EdgeInsets.all(0),
              child: GetBuilder<CeritaController>(
                builder: (controller) => Column(
                  children: [
                    _buildStoryItem(
                      storyId: 'story_1',
                      profileImage: 'assets/Rafi.jpg',
                      name: 'Rafi Iqbal',
                      className: 'Teacher',
                      timeAgo: '1 minutes ago',
                      storyImage: 'assets/ghibli/kucing.jpg',
                      caption: 'Saya melihat kucing di kolam',
                    ),
                    const SizedBox(height: 10),
                    _buildStoryItem(
                      storyId: 'story_2',
                      profileImage: 'assets/avatar/rafi1.jpg',
                      name: 'Ahmad Rizki',
                      className: '9B',
                      timeAgo: '15 minutes ago',
                      storyImage: 'assets/ghibli/gunung.jpg',
                      caption: 'Pemandangan indah di taman sekolah 🌸',
                    ),
                    const SizedBox(height: 30),
                    _buildStoryItem(
                      storyId: 'story_3',
                      profileImage: 'assets/avatar/rafi2.jpg',
                      name: 'Antok Simanjuntak',
                      className: '9B',
                      timeAgo: '32 minutes ago',
                      storyImage: 'assets/ghibli/rpl.jpg',
                      caption: 'Belajar coding hari ini sangat menyenangkan! 💻',
                    ),
                    const SizedBox(height: 30),
                    _buildStoryItem(
                      storyId: 'story_4',
                      profileImage: 'assets/avatar/rafi3.jpg',
                      name: 'Arip Kopling',
                      className: '9B',
                      timeAgo: '1 hour ago',
                      storyImage: 'assets/ghibli/ponyo.jpg',
                      caption: 'Saya lihat ikan dengan ponyo',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(navbarController),
    );
  }

  // Dialog untuk membuat post baru
  void _showPostDialog(CeritaController controller) {
    final TextEditingController textController = TextEditingController();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Buat Cerita Baru',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Profile section
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/Rafi.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rafi Iqbal',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'X RPL B',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Text input
              TextField(
                controller: textController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Apa yang terjadi?',
                  hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Image picker section
              GetBuilder<CeritaController>(
                builder: (controller) {
                  if (controller.selectedImagePath.isNotEmpty) {
                    return Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              controller.selectedImagePath,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => controller.clearSelectedImage(),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickImage(),
                      icon: const Icon(Icons.image, color: Colors.purple),
                      label: Text(
                        'Tambah Foto',
                        style: GoogleFonts.inter(color: Colors.purple),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty || controller.selectedImagePath.isNotEmpty) {
                          controller.createNewPost(textController.text);
                          Get.back();
                        } else {
                          Get.snackbar(
                            'Peringatan',
                            'Silakan tulis sesuatu atau pilih gambar',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Posting',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryItem({
    required String storyId,
    required String profileImage,
    required String name,
    required String className,
    required String timeAgo,
    required String storyImage,
    required String caption,
  }) {
    return Container(
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile, name, and more options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Row(
              children: [
                // Profile picture - Changed to use asset with tap functionality
                GestureDetector(
                  onTap: () => _showUserProfile(name, className, profileImage, storyId),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 27.5,
                      backgroundImage: AssetImage(profileImage),
                      backgroundColor: Colors.grey,
                      onBackgroundImageError: (exception, stackTrace) {
                        // Fallback if asset image fails to load
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                // Name and class info - also clickable
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showUserProfile(name, className, profileImage, storyId),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$className • $timeAgo',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // More options button
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {
                    _showMoreOptions();
                  },
                ),
              ],
            ),
          ),
          // Story image - Changed to use asset
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              width: 276,
              height: 154,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                  image: AssetImage(storyImage),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Fallback if asset image fails to load
                  },
                ),
                // Fallback color if image fails to load
                color: Colors.grey[300],
              ),
            ),
          ),
          // Caption text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Text(
              caption,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          // Action buttons (like and share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                GetBuilder<CeritaController>(
                  builder: (controller) {
                    final isLiked = controller.isStoryLiked(storyId);
                    final likeCount = controller.getStoryLikeCount(storyId);
                    
                    return Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            controller.toggleLike(storyId);
                          },
                        ),
                        Text(
                          '$likeCount',
                          style: TextStyle(
                            color: isLiked ? Colors.red : Colors.grey,
                            fontSize: 12,
                            fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.grey),
                  onPressed: () {
                    _handleShare(storyId, name, caption);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show user profile dialog - Modified for Ahmad Rizki to navigate to /ruang-chat
  void _showUserProfile(String name, String className, String profileImage, String storyId) {
    final controller = Get.find<CeritaController>();
    final userStats = controller.getUserStats(name);
    
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profileImage),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 16),
            
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            Text(
              className,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Online', '${userStats['Online']}'),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey[300],
                ),
                _buildStatItem('Likes', '${userStats['totalLikes']}'),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey[300],
                ),
                _buildStatItem('Teman', '${userStats['friends']}'),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Action Buttons - Hidden for Rafi Iqbal, special handling for Ahmad Rizki
            if (name != 'Rafi Iqbal')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          controller.followUser(name);
                        },
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Ikuti'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.back();
                          // Special navigation for Ahmad Rizki
                          if (name == 'Ahmad Rizki') {
                            Get.toNamed('/ruang-chat');
                          } else {
                            Get.snackbar(
                              'Pesan',
                              'Fitur pesan akan segera hadir!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(Icons.message, size: 18),
                        label: const Text('Pesan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Recent Posts Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Postingan Terbaru',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Mini posts grid
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userStats['recentPosts'].length,
                itemBuilder: (context, index) {
                  final post = userStats['recentPosts'][index];
                  return Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(post),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.red),
              title: const Text('Laporkan'),
              onTap: () {
                Get.back();
                // Handle report
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Blokir Pengguna'),
              onTap: () {
                Get.back();
                // Handle block user
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.blue),
              title: const Text('Salin Link'),
              onTap: () {
                Get.back();
                // Handle copy link
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _handleShare(String storyId, String authorName, String caption) {
  // Show share to group 9B dialog
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bagikan Cerita',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          // Share to group 9B section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.purple,
                  child: Text(
                    '9B',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  'Grup 9B',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Bagikan ke grup kelas',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Bagikan',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  // Handle share to group 9B
                  Get.back();
                  Get.snackbar(
                    'Berhasil',
                    'Cerita berhasil dibagikan ke Grup 9B',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.purple,
                    colorText: Colors.white,
                  );
                  
                  // You can add your logic here to actually share to group 9B
                  // Example: controller.shareToGroup9B(storyId, authorName, caption);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
    isScrollControlled: true,
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
          _buildNavItem(controller, 1, 'Cerita', Icons.image, Colors.purple),
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
}
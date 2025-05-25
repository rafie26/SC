import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/grub_controller.dart';

class GrubView extends GetView<GrubController> {
  const GrubView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from navigation
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final groupName = arguments['groupName'] ?? 'Grup 9B';

    return Scaffold(
      appBar: _buildAppBar(groupName),
      body: Column(
        children: [
          Expanded(
            child: _buildChatMessages(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String groupName) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          // Updated to use asset image instead of icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purple.shade200, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/group_avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika asset tidak ditemukan
                  return Container(
                    color: Colors.purple.shade100,
                    child: Icon(
                      Icons.group,
                      color: Colors.purple.shade600,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '25 anggota',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () => _showGroupOptions(),
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    return Obx(() {
      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final isMe = message['isMe'] as bool;
          
          return _buildMessageBubble(
            message['sender'] as String,
            message['content'] as String,
            message['time'] as String,
            isMe,
            message['type'] as String? ?? 'text',
          );
        },
      );
    });
  }

  Widget _buildMessageBubble(String sender, String content, String time, bool isMe, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            // Profile picture untuk murid dengan tap untuk mengubah profil
            GestureDetector(
              onLongPress: () => controller.changeStudentProfile(sender),
              child: Obx(() => _buildProfileAvatar(sender, isMe)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      sender,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.purple.shade600 : Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (type == 'announcement') ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.campaign,
                              size: 16,
                              color: isMe ? Colors.white : Colors.purple.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Pengumuman',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.white.withOpacity(0.9) : Colors.purple.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        content,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            // Profile picture untuk guru dengan tap untuk mengubah profil
            GestureDetector(
              onTap: () => controller.changeTeacherProfile(),
              child: Obx(() => _buildProfileAvatar(sender, isMe)),
            ),
          ],
        ],
      ),
    );
  }

  // Widget untuk membangun avatar profil yang dinamis
  Widget _buildProfileAvatar(String sender, bool isMe) {
    final profileImage = controller.getProfileImage(sender, isMe);
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? Colors.purple.shade400 : Colors.purple.shade200, 
          width: 1
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          profileImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback dengan initial nama
            return Container(
              color: isMe ? Colors.purple.shade600 : Colors.purple.shade100,
              child: Center(
                child: Text(
                  controller.getInitials(sender),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Colors.purple.shade600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => _showAttachmentOptions(),
            icon: Icon(
              Icons.attach_file,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 40,
                maxHeight: 120,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller.messageController,
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.poppins(),
                onSubmitted: (value) {
                  controller.sendMessage();
                },
                scrollPhysics: const BouncingScrollPhysics(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() {
            return controller.isTyping.value
                ? IconButton(
                    onPressed: () => controller.sendMessage(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () => controller.sendVoiceMessage(),
                    icon: Icon(
                      Icons.mic,
                      color: Colors.purple.shade600,
                    ),
                  );
          }),
        ],
      ),
    );
  }

  void _showGroupOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            const SizedBox(height: 20),
            _buildOptionItem(Icons.group, 'Info Grup', () {
              Get.back();
              // Navigate to group info
            }),
            _buildOptionItem(Icons.volume_off, 'Bisukan Notifikasi', () {
              Get.back();
              controller.muteNotifications();
            }),
            _buildOptionItem(Icons.search, 'Cari dalam Chat', () {
              Get.back();
              _showSearchDialog();
            }),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Cari Pesan'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Masukkan kata kunci...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                Get.back();
                controller.searchMessages(searchController.text);
              }
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(Icons.photo, 'Galeri', Colors.pink, () {
                  controller.sendImageMessage('sample_image.jpg');
                }),
                _buildAttachmentOption(Icons.camera_alt, 'Kamera', Colors.blue, () {
                  controller.sendImageMessage('camera_photo.jpg');
                }),
                _buildAttachmentOption(Icons.insert_drive_file, 'Dokumen', Colors.orange, () {
                  controller.sendDocumentMessage('dokumen.pdf');
                }),
                _buildAttachmentOption(Icons.location_on, 'Lokasi', Colors.green, () {
                  controller.sendLocationMessage('Jakarta, Indonesia');
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
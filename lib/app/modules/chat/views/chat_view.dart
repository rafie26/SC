import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C1FB4),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Pesan',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari berdasarkan nama atau nomor induk...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        suffixIcon: Obx(() {
                          return controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  onPressed: controller.clearSearch,
                                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                                )
                              : const SizedBox.shrink();
                        }),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == 0
                              ? const Color(0xFF6C1FB4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Percakapan',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: controller.selectedTab.value == 0
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == 1
                              ? const Color(0xFF6C1FB4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Semua Pengguna',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: controller.selectedTab.value == 1
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C1FB4)),
                  ),
                );
              }

              return controller.selectedTab.value == 0
                  ? _buildConversationsList()
                  : _buildUsersList();
            }),
          ),
        ],
      ),
    );
  }

  // Build conversations list
  Widget _buildConversationsList() {
    return Obx(() {
      if (controller.conversations.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada percakapan',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mulai percakapan baru dengan memilih\npengguna dari tab "Semua Pengguna"',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.conversations.length,
          itemBuilder: (context, index) {
            final conversation = controller.conversations[index];
            return _buildConversationItem(conversation);
          },
        ),
      );
    });
  }

  // Build users list
  Widget _buildUsersList() {
    return Obx(() {
      final users = controller.filteredUsers;
      
      if (users.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Pengguna tidak ditemukan',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba gunakan kata kunci pencarian yang berbeda',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserItem(user);
          },
        ),
      );
    });
  }

  // Build conversation item with conditional navigation
  Widget _buildConversationItem(ChatConversation conversation) {
    return InkWell(
      onTap: () {
        // Only navigate to chat detail if the user is "Ahmad Rizki"
        if (conversation.otherUser.name.toLowerCase() == 'ahmad rizki') {
          Get.toNamed('/ruang-chat', arguments: conversation.otherUser);
        } else {
          // Show a message or do nothing for other users
          Get.snackbar(
            'Info',
            'Chat hanya tersedia untuk Ahmad Rizki',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: ClipOval(
                    child: conversation.otherUser.avatar != null
                        ? Image.asset(
                            conversation.otherUser.avatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey[600],
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                  ),
                ),
                // Online indicator
                if (conversation.otherUser.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.otherUser.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (conversation.lastMessageTime != null)
                        Text(
                          controller.getMessageTimeText(conversation.lastMessageTime),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: conversation.otherUser.role == 'guru' 
                              ? Colors.blue[50] 
                              : Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${conversation.otherUser.role.toUpperCase()} • ${conversation.otherUser.nomorInduk}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: conversation.otherUser.role == 'guru' 
                                ? Colors.blue[700] 
                                : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (conversation.lastMessage != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      conversation.lastMessage!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Unread count
            if (conversation.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C1FB4),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build user item with conditional navigation
  Widget _buildUserItem(ChatUser user) {
    return InkWell(
      onTap: () {
        // Only allow starting conversation with "Ahmad Rizki"
        if (user.name.toLowerCase() == 'ahmad rizki') {
          Get.toNamed('/ruang-chat', arguments: user);
        } else {
          // Show a message for other users
          Get.snackbar(
            'Info',
            'Chat hanya tersedia untuk Ahmad Rizki',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: ClipOval(
                    child: user.avatar != null
                        ? Image.asset(
                            user.avatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey[600],
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                  ),
                ),
                // Online indicator
                if (user.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: user.role == 'guru' 
                              ? Colors.blue[50] 
                              : Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${user.role.toUpperCase()} • ${user.nomorInduk}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: user.role == 'guru' 
                                ? Colors.blue[700] 
                                : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.isOnline 
                        ? 'Online' 
                        : 'Terakhir dilihat ${controller.getLastSeenText(user.lastSeen)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: user.isOnline ? Colors.green : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Action button with conditional styling
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: user.name.toLowerCase() == 'ahmad rizki'
                    ? const Color(0xFF6C1FB4).withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: user.name.toLowerCase() == 'ahmad rizki'
                    ? const Color(0xFF6C1FB4)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
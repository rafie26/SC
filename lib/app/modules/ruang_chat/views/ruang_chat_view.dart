import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ruang_chat_controller.dart';

class RuangChatView extends StatelessWidget {
  const RuangChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RuangChatController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: _buildMessagesArea(controller),
          ),
          // Message input area
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  // App Bar
  PreferredSizeWidget _buildAppBar(RuangChatController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
      ),
      title: Row(
        children: [
          // Profile Avatar
CircleAvatar(
  radius: 20,
  backgroundColor: const Color(0xFF8B5CF6),
  backgroundImage: AssetImage('assets/avatar/rafi1.jpg'), // Ganti dengan nama file foto Anda
  child: null, // Hapus child karena sudah menggunakan backgroundImage
),
const SizedBox(width: 12),
// User Info
Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Ahmad Rizki',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      Obx(() => Text(
        controller.isUserBlocked.value 
          ? 'Diblokir' 
          : 'Online',
        style: TextStyle(
          fontSize: 12,
          color: controller.isUserBlocked.value 
            ? Colors.red[400] 
            : Colors.green[400],
        ),
      )),
    ],
  ),
),
        ],
      ),
      actions: [
        // Video Call Button
        IconButton(
          onPressed: () => controller.handleVideoCall(),
          icon: Icon(
            Icons.videocam,
            color: const Color(0xFF8B5CF6),
          ),
        ),
        // Menu Button
        PopupMenuButton<String>(
          onSelected: controller.handleMenuAction,
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) => [
            _buildPopupMenuItem('search', Icons.search, 'Cari Pesan'),
            _buildPopupMenuItem('media', Icons.photo_library, 'Media & File'),
            const PopupMenuDivider(),
            _buildPopupMenuItem('clear', Icons.delete_sweep, 'Hapus Chat'),
            _buildPopupMenuItem('export', Icons.download, 'Export Chat'),
            const PopupMenuDivider(),
            _buildPopupMenuItem('block', Icons.block, 'Blokir Pengguna'),
            _buildPopupMenuItem('report', Icons.report, 'Laporkan'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, IconData icon, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  // Messages Area
  Widget _buildMessagesArea(RuangChatController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 16),
              Text(
                'Memuat pesan...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.filteredMessages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada pesan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mulai percakapan dengan mengirim pesan',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshChat,
        color: const Color(0xFF8B5CF6),
        child: ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.filteredMessages.length,
          itemBuilder: (context, index) {
            final message = controller.filteredMessages[index];
            final isMyMessage = controller.isMyMessage(message);
            // Hanya tampilkan time header pada pesan pertama (index 0)
            final showTime = index == 0;

            return Column(
              children: [
                if (showTime) _buildTimeHeader(message.timestamp),
                _buildMessageBubble(message, isMyMessage, controller),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      );
    });
  }

  // Time Header
  Widget _buildTimeHeader(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatTimeHeader(timestamp),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatTimeHeader(DateTime timestamp) {
    return 'Hari ini';
  }

  // Message Bubble
  Widget _buildMessageBubble(
    ChatMessage message,
    bool isMyMessage,
    RuangChatController controller,
  ) {
    return GestureDetector(
  onLongPress: () => controller.handleMessageLongPress(message),
  child: Container(
    margin: const EdgeInsets.symmetric(vertical: 2),
    padding: EdgeInsets.only(left: isMyMessage ? 0 : 24), // tambahkan padding kiri
    child: Row(
      mainAxisAlignment: isMyMessage 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,

          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMyMessage) ...[
              CircleAvatar(
                  radius: 12,
                   backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage('assets/avatar/rafi1.jpg'), 
                  child: null, 
                 ),
            ],
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isMyMessage 
                      ? const Color(0xFF8B5CF6)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMyMessage ? 18 : 4),
                    bottomRight: Radius.circular(isMyMessage ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message Type Indicator
                    if (message.messageType != null)
                      _buildMessageTypeIndicator(message.messageType!, isMyMessage),
                    
                    // Message Text
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 15,
                        color: isMyMessage ? Colors.white : Colors.grey[800],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Time and Status
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.getTimeText(message.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: isMyMessage 
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[500],
                          ),
                        ),
                        if (isMyMessage) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.isRead 
                                ? Icons.done_all 
                                : Icons.done,
                            size: 14,
                            color: message.isRead 
                                ? Colors.blue[300]
                                : Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isMyMessage) const SizedBox(width: 20),
            if (!isMyMessage) const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTypeIndicator(String messageType, bool isMyMessage) {
    IconData icon;
    String label;
    
    switch (messageType) {
      case 'image':
        icon = Icons.image;
        label = 'Foto';
        break;
      case 'document':
        icon = Icons.description;
        label = 'Dokumen';
        break;
      case 'location':
        icon = Icons.location_on;
        label = 'Lokasi';
        break;
      case 'audio':
        icon = Icons.mic;
        label = 'Audio';
        break;
      case 'contact':
        icon = Icons.contact_phone;
        label = 'Kontak';
        break;
      case 'poll':
        icon = Icons.poll;
        label = 'Poll';
        break;
      case 'forwarded':
        icon = Icons.forward;
        label = 'Diteruskan';
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isMyMessage ? Colors.white : const Color(0xFF8B5CF6))
            .withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isMyMessage 
                ? Colors.white.withOpacity(0.8)
                : const Color(0xFF8B5CF6),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isMyMessage 
                  ? Colors.white.withOpacity(0.8)
                  : const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }

  // Message Input Area
  Widget _buildMessageInput(RuangChatController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isUserBlocked.value) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.block, color: Colors.red[400], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pengguna ini telah diblokir',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: Row(
            children: [
              // Attachment Button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: controller.handleAttachment,
                  icon: Icon(
                    Icons.attach_file,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Text Input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Flexible(
  child: TextField(
    controller: controller.messageController,
    decoration: const InputDecoration(
      hintText: 'Ketik pesan...',
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
    ),
    minLines: 1,
    maxLines: 5, // Maksimal tinggi teks area (bisa diubah sesuai keinginan)
    keyboardType: TextInputType.multiline,
    textCapitalization: TextCapitalization.sentences,
    onChanged: controller.updateMessage,
  ),
),
                      
                      // Emoji Button
                      IconButton(
                        onPressed: () {
                          // Add emoji picker functionality
                        },
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Send Button
              Container(
                decoration: BoxDecoration(
                  color: controller.messageText.value.trim().isEmpty
                      ? Colors.grey[300]
                      : const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: controller.messageText.value.trim().isEmpty
                      ? null
                      : controller.sendMessage,
                  icon: controller.isSending.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: controller.messageText.value.trim().isEmpty
                              ? Colors.grey[600]
                              : Colors.white,
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
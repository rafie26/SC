import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

// Model class for ChatMessage only
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? messageType;
  final String? attachment;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.messageType,
    this.attachment,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? messageType,
    String? attachment,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      messageType: messageType ?? this.messageType,
      attachment: attachment ?? this.attachment,
    );
  }
}

class RuangChatController extends GetxController {
  // Text Controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Observables
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<ChatMessage> filteredMessages = <ChatMessage>[].obs;
  final RxString messageText = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isUserBlocked = false.obs;

  // Current user ID (you should get this from your auth service)
  final String currentUserId = '1'; // Replace with actual current user ID
  final String otherUserId = '3'; // ID for the other user

  @override
  void onInit() {
    super.onInit();
    
    // Initialize chat
    _initializeChat();
    
    // Listen to message changes
    messageController.addListener(() {
      messageText.value = messageController.text;
    });

    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterMessages();
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Initialize chat
  void _initializeChat() {
    loadMessages();
    markMessagesAsRead();
  }

  // Load messages
  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      
      // Simulate API call - replace with actual API
      await Future.delayed(const Duration(seconds: 1));
      
      // Sample messages
      final sampleMessages = [
        ChatMessage(
          id: '1',
          senderId: otherUserId,
          receiverId: currentUserId,
          message: 'Assalamualaikum pak',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: '2',
          senderId: currentUserId,
          receiverId: otherUserId,
          message: 'Waalaikumsalam Nak.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          senderId: otherUserId,
          receiverId: currentUserId,
          message: 'Saya ingin bertanya pak, apakah boleh?.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          isRead: true,
        ),
      ];
      
      messages.assignAll(sampleMessages);
      filteredMessages.assignAll(sampleMessages);
      
      // Auto scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
      
    } catch (e) {
      _showErrorSnackbar('Gagal memuat pesan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Menu Actions
  void handleMenuAction(String action) {
    switch (action) {
      case 'search':
        _showSearchDialog();
        break;
      case 'media':
        _showMediaGallery();
        break;
      case 'clear':
        _showClearChatDialog();
        break;
      case 'export':
        _exportChat();
        break;
      case 'block':
        _showBlockUserDialog();
        break;
      case 'report':
        _showReportDialog();
        break;
    }
  }

  // Search Messages Dialog
  void _showSearchDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: const Color(0xFF8B5CF6),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Cari Pesan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kata kunci...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                ),
                onChanged: (value) => _filterMessages(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (searchQuery.value.isEmpty) {
                    return Center(
                      child: Text(
                        'Ketik untuk mencari pesan',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  
                  if (filteredMessages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada pesan ditemukan',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: message.senderId == currentUserId
                              ? const Color(0xFF8B5CF6)
                              : Colors.grey[300],
                          child: Icon(
                            Icons.message,
                            color: message.senderId == currentUserId
                                ? Colors.white
                                : Colors.grey[600],
                            size: 16,
                          ),
                        ),
                        title: Text(
                          message.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          getDetailedTimeText(message.timestamp),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                          _scrollToMessage(message.id);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show Media Gallery
  void _showMediaGallery() {
    Get.bottomSheet(
      Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.photo_library, color: const Color(0xFF8B5CF6)),
                const SizedBox(width: 12),
                Text(
                  'Media & File',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildMediaItem('Foto 1', Icons.image, Colors.blue),
                  _buildMediaItem('Foto 2', Icons.image, Colors.green),
                  _buildMediaItem('Video 1', Icons.video_library, Colors.red),
                  _buildMediaItem('File 1', Icons.description, Colors.orange),
                  _buildMediaItem('File 2', Icons.description, Colors.purple),
                  _buildMediaItem('Audio', Icons.audio_file, Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaItem(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Get.back();
        _showSuccessSnackbar('Membuka $name');
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Clear Chat Dialog
  void _showClearChatDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.red[400]),
            const SizedBox(width: 12),
            const Text('Hapus Chat'),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua pesan? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _clearAllMessages();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Export Chat
  void _exportChat() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.download, color: const Color(0xFF10B981)),
            const SizedBox(width: 12),
            const Text('Export Chat'),
          ],
        ),
        content: const Text(
          'Pilih format untuk mengexport chat:',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _exportAsText();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('TXT', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _exportAsPDF();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('PDF', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Block User Dialog
  void _showBlockUserDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.block, color: Colors.orange[400]),
            const SizedBox(width: 12),
            Text(isUserBlocked.value ? 'Buka Blokir' : 'Blokir Pengguna'),
          ],
        ),
        content: Text(
          isUserBlocked.value 
              ? 'Apakah Anda yakin ingin membuka blokir pengguna ini?'
              : 'Apakah Anda yakin ingin memblokir pengguna ini? Anda tidak akan menerima pesan dari mereka.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _toggleBlockUser();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isUserBlocked.value ? Colors.green[400] : Colors.orange[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isUserBlocked.value ? 'Buka Blokir' : 'Blokir',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Report Dialog
  void _showReportDialog() {
    final reportReasons = [
      'Spam atau pesan berulang',
      'Pelecehan atau bullying',
      'Konten tidak pantas',
      'Penipuan atau scam',
      'Kekerasan atau ancaman',
      'Lainnya',
    ];

    String selectedReason = reportReasons[0];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.report, color: Colors.red[400]),
            const SizedBox(width: 12),
            const Text('Laporkan Pengguna'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih alasan pelaporan:'),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: reportReasons.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    title: Text(
                      reportReasons[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: reportReasons[index],
                    groupValue: selectedReason,
                    onChanged: (value) {
                      selectedReason = value!;
                    },
                    activeColor: const Color(0xFF8B5CF6),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _submitReport(selectedReason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Laporkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Video Call Handler
  void handleVideoCall() {
    if (isUserBlocked.value) {
      _showErrorSnackbar('Tidak dapat melakukan panggilan video dengan pengguna yang diblokir');
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.videocam, color: const Color(0xFF8B5CF6)),
            const SizedBox(width: 12),
            const Text('Video Call'),
          ],
        ),
        content: const Text('Memulai panggilan video?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _startVideoCall();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Mulai', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Implementation Methods
  void _filterMessages() {
    if (searchQuery.value.isEmpty) {
      filteredMessages.assignAll(messages);
    } else {
      filteredMessages.assignAll(
        messages.where((message) =>
            message.message.toLowerCase().contains(searchQuery.value.toLowerCase())),
      );
    }
  }

  void _scrollToMessage(String messageId) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1 && scrollController.hasClients) {
      scrollController.animateTo(
        index * 100.0, // Approximate height per message
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _clearAllMessages() {
    messages.clear();
    filteredMessages.clear();
    _showSuccessSnackbar('Semua pesan telah dihapus');
  }

  void _exportAsText() async {
    try {
      String chatContent = '';
      for (var message in messages) {
        final sender = message.senderId == currentUserId ? 'Saya' : 'Lawan Chat';
        final time = getDetailedTimeText(message.timestamp);
        chatContent += '[$time] $sender: ${message.message}\n';
      }
      
      // Simulate file save
      await Future.delayed(const Duration(seconds: 1));
      Clipboard.setData(ClipboardData(text: chatContent));
      _showSuccessSnackbar('Chat berhasil di-export ke clipboard');
    } catch (e) {
      _showErrorSnackbar('Gagal export: ${e.toString()}');
    }
  }

  void _exportAsPDF() async {
    try {
      // Simulate PDF generation
      await Future.delayed(const Duration(seconds: 2));
      _showSuccessSnackbar('Chat berhasil di-export sebagai PDF');
    } catch (e) {
      _showErrorSnackbar('Gagal export PDF: ${e.toString()}');
    }
  }

  void _toggleBlockUser() {
    isUserBlocked.value = !isUserBlocked.value;
    if (isUserBlocked.value) {
      _showWarningSnackbar('Pengguna telah diblokir');
    } else {
      _showSuccessSnackbar('Pengguna telah dibuka blokirnya');
    }
  }

  void _submitReport(String reason) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _showSuccessSnackbar('Laporan berhasil dikirim. Terima kasih atas laporannya.');
    } catch (e) {
      _showErrorSnackbar('Gagal mengirim laporan: ${e.toString()}');
    }
  }

  void _startVideoCall() async {
    try {
      // Simulate starting video call
      await Future.delayed(const Duration(seconds: 1));
      _showSuccessSnackbar('Memulai panggilan video...');
      // Here you would typically navigate to video call screen
    } catch (e) {
      _showErrorSnackbar('Gagal memulai panggilan: ${e.toString()}');
    }
  }

  // Handle Attachment - Complete implementation
  void handleAttachment() {
    if (isUserBlocked.value) {
      _showErrorSnackbar('Tidak dapat mengirim attachment ke pengguna yang diblokir');
      return;
    }

    Get.bottomSheet(
      Container(
        height: 320,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Kirim File',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            
            // Attachment options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo_camera,
                  label: 'Kamera',
                  color: Colors.blue,
                  onTap: () => _handleCamera(),
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Galeri',
                  color: Colors.green,
                  onTap: () => _handleGallery(),
                ),
                _buildAttachmentOption(
                  icon: Icons.description,
                  label: 'Dokumen',
                  color: Colors.orange,
                  onTap: () => _handleDocument(),
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Lokasi',
                  color: Colors.red,
                  onTap: () => _handleLocation(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Additional options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(
                  icon: Icons.mic,
                  label: 'Audio',
                  color: Colors.purple,
                  onTap: () => _handleAudio(),
                ),
                _buildAttachmentOption(
                  icon: Icons.contact_phone,
                  label: 'Kontak',
                  color: Colors.teal,
                  onTap: () => _handleContact(),
                ),
                _buildAttachmentOption(
                  icon: Icons.poll,
                  label: 'Poll',
                  color: Colors.indigo,
                  onTap: () => _handlePoll(),
                ),
                _buildAttachmentOption(
                  icon: Icons.more_horiz,
                  label: 'Lainnya',
                  color: Colors.grey,
                  onTap: () => _handleOther(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Attachment handlers
  void _handleCamera() {
    Get.back();
    _sendAttachmentMessage('📷 Foto dari kamera', 'image');
  }

  void _handleGallery() {
    Get.back();
    _sendAttachmentMessage('🖼️ Foto dari galeri', 'image');
  }

  void _handleDocument() {
    Get.back();
    _sendAttachmentMessage('📄 Dokumen', 'document');
  }

  void _handleLocation() {
    Get.back();
    _sendAttachmentMessage('📍 Lokasi: Jakarta, Indonesia', 'location');
  }

  void _handleAudio() {
    Get.back();
    _sendAttachmentMessage('🎵 Rekaman suara (00:15)', 'audio');
  }

  void _handleContact() {
    Get.back();
    _sendAttachmentMessage('👤 Kontak: Ahmad Rahman', 'contact');
  }

  void _handlePoll() {
    Get.back();
    _sendAttachmentMessage('📊 Poll: Kapan waktu terbaik untuk meeting?', 'poll');
  }

  void _handleOther() {
    Get.back();
    _showSuccessSnackbar('Fitur lainnya akan segera hadir');
  }

  // Send attachment message
  Future<void> _sendAttachmentMessage(String message, String type) async {
    try {
      isSending.value = true;
      
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUserId,
        receiverId: otherUserId,
        message: message,
        timestamp: DateTime.now(),
        isRead: false,
        messageType: type,
      );

      // Add message to list
      messages.add(newMessage);
      filteredMessages.add(newMessage);
      
      // Scroll to bottom
      scrollToBottom();
      
      // Simulate sending to server
      await Future.delayed(const Duration(milliseconds: 500));
      
      _showSuccessSnackbar('$message berhasil dikirim');
      
      // Simulate auto-reply after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        _simulateReply();
      });
      
    } catch (e) {
      _showErrorSnackbar('Gagal mengirim attachment: ${e.toString()}');
    } finally {
      isSending.value = false;
    }
  }

  // Snackbar helpers
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showWarningSnackbar(String message) {
    Get.snackbar(
      'Peringatan',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange[400],
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  // Send Message
  Future<void> sendMessage() async {
    if (messageText.value.trim().isEmpty || isSending.value) return;
    
    if (isUserBlocked.value) {
      _showErrorSnackbar('Tidak dapat mengirim pesan ke pengguna yang diblokir');
      return;
    }

    try {
      isSending.value = true;
      
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUserId,
        receiverId: otherUserId,
        message: messageText.value.trim(),
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Add message to list
      messages.add(newMessage);
      filteredMessages.add(newMessage);
      
      // Clear input
      messageController.clear();
      messageText.value = '';
      
      // Scroll to bottom
      scrollToBottom();
      
      // Simulate sending to server
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update message as sent (simulate server response)
      final index = messages.indexWhere((msg) => msg.id == newMessage.id);
      if (index != -1) {
        messages[index] = messages[index].copyWith(isRead: false);
        
        // Simulate auto-reply after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          _simulateReply();
        });
      }
      
    } catch (e) {
      _showErrorSnackbar('Gagal mengirim pesan: ${e.toString()}');
    } finally {
      isSending.value = false;
    }
  }

  // Simulate Reply from Other User
  void _simulateReply() {
    final replyMessages = [
      'Terima kasih ya Pak Rafi',
      'Baik, saya pak mengerti.',
      'Okey pak, akan saya coba.',
      'Terima kasih infonya.',
      'Insyallah.',
      'Wah menarik sekali!',
      'Mantap Pak Rafi.',
      'Saya setuju Pak.',
    ];
    
    final randomReply = replyMessages[DateTime.now().millisecond % replyMessages.length];
    
    final replyMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: otherUserId,
      receiverId: currentUserId,
      message: randomReply,
      timestamp: DateTime.now(),
      isRead: false,
    );

    messages.add(replyMessage);
    filteredMessages.add(replyMessage);
    scrollToBottom();
    
    // Mark as read after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      markMessagesAsRead();
    });
  }

  // Update Message Text
  void updateMessage(String value) {
    messageText.value = value;
  }

  // Scroll to bottom
  void scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // Mark messages as read
  void markMessagesAsRead() {
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].receiverId == currentUserId && !messages[i].isRead) {
        messages[i] = messages[i].copyWith(isRead: true);
      }
    }
    // Update filtered messages as well
    for (int i = 0; i < filteredMessages.length; i++) {
      if (filteredMessages[i].receiverId == currentUserId && !filteredMessages[i].isRead) {
        filteredMessages[i] = filteredMessages[i].copyWith(isRead: true);
      }
    }
  }

  // Delete message
  void deleteMessage(String messageId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.delete, color: Colors.red[400]),
            const SizedBox(width: 12),
            const Text('Hapus Pesan'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin menghapus pesan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performDeleteMessage(messageId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _performDeleteMessage(String messageId) {
    messages.removeWhere((msg) => msg.id == messageId);
    filteredMessages.removeWhere((msg) => msg.id == messageId);
    _showSuccessSnackbar('Pesan berhasil dihapus');
  }

  // Edit message
  void editMessage(String messageId, String currentMessage) {
    final editController = TextEditingController(text: currentMessage);
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.edit, color: const Color(0xFF8B5CF6)),
            const SizedBox(width: 12),
            const Text('Edit Pesan'),
          ],
        ),
        content: TextField(
          controller: editController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Masukkan pesan baru...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              editController.dispose();
              Get.back();
            },
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                _performEditMessage(messageId, editController.text.trim());
              }
              editController.dispose();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _performEditMessage(String messageId, String newMessage) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(message: newMessage);
    }
    
    final filteredIndex = filteredMessages.indexWhere((msg) => msg.id == messageId);
    if (filteredIndex != -1) {
      filteredMessages[filteredIndex] = filteredMessages[filteredIndex].copyWith(message: newMessage);
    }
    
    _showSuccessSnackbar('Pesan berhasil diubah');
  }

  // Reply to message
  void replyToMessage(ChatMessage message) {
    final replyText = message.senderId == currentUserId ? 'Anda' : 'Lawan Chat';
    messageController.text = 'Membalas $replyText: "${message.message}"\n\n';
    messageText.value = messageController.text;
    
    // Focus on text field - you might want to implement this in your UI
    _showSuccessSnackbar('Membalas pesan');
  }

  // Forward message
  void forwardMessage(ChatMessage message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.forward, color: const Color(0xFF8B5CF6)),
            const SizedBox(width: 12),
            const Text('Teruskan Pesan'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pesan yang akan diteruskan:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.message,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performForwardMessage(message);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Teruskan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _performForwardMessage(ChatMessage originalMessage) {
    final forwardedMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      receiverId: otherUserId,
      message: '📩 Pesan Diteruskan:\n${originalMessage.message}',
      timestamp: DateTime.now(),
      isRead: false,
      messageType: 'forwarded',
    );

    messages.add(forwardedMessage);
    filteredMessages.add(forwardedMessage);
    scrollToBottom();
    
    _showSuccessSnackbar('Pesan berhasil diteruskan');
    
    // Simulate auto-reply
    Future.delayed(const Duration(seconds: 2), () {
      _simulateReply();
    });
  }

  // Copy message
  void copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    _showSuccessSnackbar('Pesan berhasil disalin');
  }

  // Get time text for messages
  String getTimeText(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}h yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}j yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  // Get detailed time text for messages
  String getDetailedTimeText(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays > 0) {
      final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
      return '${days[timestamp.weekday % 7]} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  // Check if message is from current user
  bool isMyMessage(ChatMessage message) {
    return message.senderId == currentUserId;
  }

  // Get unread message count
  int getUnreadCount() {
    return messages.where((msg) => 
      msg.receiverId == currentUserId && !msg.isRead
    ).length;
  }

  // Search in messages
  void searchMessages(String query) {
    searchQuery.value = query;
    _filterMessages();
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredMessages.assignAll(messages);
  }

  // Refresh chat
  Future<void> refreshChat() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      await loadMessages();
      _showSuccessSnackbar('Chat berhasil diperbarui');
    } catch (e) {
      _showErrorSnackbar('Gagal memperbarui chat: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle long press on message
  void handleMessageLongPress(ChatMessage message) {
    final isMyMsg = isMyMessage(message);
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
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
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // Message preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildActionButton(
                  icon: Icons.copy,
                  label: 'Salin',
                  onTap: () {
                    Get.back();
                    copyMessage(message.message);
                  },
                ),
                _buildActionButton(
                  icon: Icons.reply,
                  label: 'Balas',
                  onTap: () {
                    Get.back();
                    replyToMessage(message);
                  },
                ),
                _buildActionButton(
                  icon: Icons.forward,
                  label: 'Teruskan',
                  onTap: () {
                    Get.back();
                    forwardMessage(message);
                  },
                ),
                if (isMyMsg) ...[
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    onTap: () {
                      Get.back();
                      editMessage(message.id, message.message);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    label: 'Hapus',
                    color: Colors.red,
                    onTap: () {
                      Get.back();
                      deleteMessage(message.id);
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? const Color(0xFF8B5CF6);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: buttonColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: buttonColor, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle emoji reaction
  void addReaction(String messageId, String emoji) {
    // Implementation for adding emoji reactions
    _showSuccessSnackbar('Reaksi $emoji ditambahkan');
  }

  // Handle message status update
  void updateMessageStatus(String messageId, bool isRead) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(isRead: isRead);
    }
    
    final filteredIndex = filteredMessages.indexWhere((msg) => msg.id == messageId);
    if (filteredIndex != -1) {
      filteredMessages[filteredIndex] = filteredMessages[filteredIndex].copyWith(isRead: isRead);
    }
  }
}
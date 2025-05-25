import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrubController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  // Observable list untuk menyimpan pesan-pesan chat
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  
  // Observable untuk status typing
  final RxBool isTyping = false.obs;
  
  // Observable untuk status mute notifications
  final RxBool isMuted = false.obs;

  // Observable untuk foto profil guru
  final RxString teacherProfileImage = 'assets/Rafi.jpg'.obs;

  // Map untuk menyimpan foto profil setiap murid
  final RxMap<String, String> studentProfileImages = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize student profile images
    _initializeStudentProfiles();
    
    // Load initial messages
    _loadInitialMessages();
    
    // Listen to message controller changes
    messageController.addListener(() {
      isTyping.value = messageController.text.isNotEmpty;
    });

    // Auto scroll to bottom after loading initial messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _initializeStudentProfiles() {
    // Inisialisasi foto profil default untuk setiap murid
    studentProfileImages.addAll({
      'Ahmad': 'assets/avatar/rafi1.jpg',
      'Antok': 'assets/avatar/rafi2.jpg',
      'Arip': 'assets/avatar/rafi3.jpg',
      'Dewi': 'assets/avatar/meow.jpg',
      'Rina': 'assets/images/students/rina.png',
      'Dian': 'assets/images/students/dian.png',
      'Eko': 'assets/images/students/eko.png',
      'Fitri': 'assets/images/students/fitri.png',
      'Andi': 'assets/images/students/andi.png',
      'Lina': 'assets/images/students/lina.png',
    });
  }

  void _loadInitialMessages() {
    // Sample initial messages
    messages.addAll([
      {
        'sender': 'Pak Guru',
        'content': 'Ujian akan dilaksanakan pada tanggal 15-20 Juli 2025. Harap persiapkan diri dengan baik.',
        'time': '08:30',
        'isMe': true,
        'type': 'announcement',
      },
      {
        'sender': 'Ahmad',
        'content': 'Pak, tugas yang kemarin sudah harus dikumpulkan hari ini kan?',
        'time': '08:45',
        'isMe': false,
        'type': 'text',
      },
      {
        'sender': 'Antok',
        'content': 'Iya pak, saya sudah selesai mengerjakan.',
        'time': '08:47',
        'isMe': false,
        'type': 'text',
      },
      {
        'sender': 'Arip',
        'content': 'Pak, kalau yang nomor 5 masih belum paham.',
        'time': '09:15',
        'isMe': false,
        'type': 'text',
      },
      {
        'sender': 'Pak Guru',
        'content': 'Baik Arip, nanti kita bahas bersama di kelas ya. Yang lain juga boleh bertanya jika ada yang belum dipahami.',
        'time': '09:20',
        'isMe': true,
        'type': 'text',
      },
      {
        'sender': 'Dewi',
        'content': 'Terima kasih pak!',
        'time': '09:22',
        'isMe': false,
        'type': 'text',
      },
    ]);
  }

  // Method untuk mengubah foto profil guru
  void changeTeacherProfile() {
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
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                _buildProfileOption('assets/images/teachers/teacher1.png', 'Profil 1'),
                _buildProfileOption('assets/images/teachers/teacher2.png', 'Profil 2'),
                _buildProfileOption('assets/images/teachers/teacher3.png', 'Profil 3'),
                _buildProfileOption('assets/images/teachers/teacher4.png', 'Profil 4'),
                _buildProfileOption('assets/images/teachers/teacher5.png', 'Profil 5'),
                _buildProfileOption('assets/images/teachers/teacher6.png', 'Profil 6'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _selectImageFromGallery();
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Dari Galeri'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _selectImageFromCamera();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Dari Kamera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        teacherProfileImage.value = imagePath;
        Get.back();
        Get.snackbar(
          'Profil Diubah',
          'Foto profil berhasil diubah',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: teacherProfileImage.value == imagePath 
                    ? Colors.purple 
                    : Colors.grey.shade300,
                width: teacherProfileImage.value == imagePath ? 3 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.purple.shade100,
                    child: Icon(
                      Icons.person,
                      color: Colors.purple.shade600,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _selectImageFromGallery() {
    // Simulasi pemilihan dari galeri
    Get.snackbar(
      'Galeri',
      'Memilih foto dari galeri... (Fitur ini memerlukan image_picker plugin)',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _selectImageFromCamera() {
    // Simulasi pengambilan dari kamera
    Get.snackbar(
      'Kamera',
      'Mengambil foto dari kamera... (Fitur ini memerlukan image_picker plugin)',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Method untuk mendapatkan foto profil berdasarkan nama pengirim
  String getProfileImage(String sender, bool isMe) {
    if (isMe) {
      return teacherProfileImage.value;
    } else {
      return studentProfileImages[sender] ?? 'assets/images/students/default.png';
    }
  }

  // Method untuk mengubah foto profil murid (untuk admin/guru)
  void changeStudentProfile(String studentName) {
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
            Text(
              'Ubah Foto Profil $studentName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                _buildStudentProfileOption(studentName, 'assets/images/students/student1.png', 'Avatar 1'),
                _buildStudentProfileOption(studentName, 'assets/images/students/student2.png', 'Avatar 2'),
                _buildStudentProfileOption(studentName, 'assets/images/students/student3.png', 'Avatar 3'),
                _buildStudentProfileOption(studentName, 'assets/images/students/student4.png', 'Avatar 4'),
                _buildStudentProfileOption(studentName, 'assets/images/students/student5.png', 'Avatar 5'),
                _buildStudentProfileOption(studentName, 'assets/images/students/student6.png', 'Avatar 6'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentProfileOption(String studentName, String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        studentProfileImages[studentName] = imagePath;
        Get.back();
        Get.snackbar(
          'Profil Diubah',
          'Foto profil $studentName berhasil diubah',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: studentProfileImages[studentName] == imagePath 
                    ? Colors.purple 
                    : Colors.grey.shade300,
                width: studentProfileImages[studentName] == imagePath ? 3 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.purple.shade100,
                    child: Text(
                      studentName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Method untuk mendapatkan initial dari nama (fallback)
  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name[0].toUpperCase();
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Add new message to the list
    final newMessage = {
      'sender': 'Pak Guru',
      'content': text,
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'text',
    };

    messages.add(newMessage);
    
    // Clear the input field
    messageController.clear();
    
    // Auto-scroll to bottom after sending message
    _scrollToBottom();
  }

  void sendVoiceMessage() {
    // Simulate sending voice message
    final newMessage = {
      'sender': 'Pak Guru',
      'content': '🎵 Pesan Suara (0:15)',
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'voice',
    };

    messages.add(newMessage);
    
    // Auto-scroll to bottom after sending voice message
    _scrollToBottom();
    
    Get.snackbar(
      'Terkirim',
      'Pesan suara berhasil dikirim',
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
    );
  }

  void sendAnnouncement(String title, String content) {
    final announcementText = '$title\n\n$content';
    
    final newMessage = {
      'sender': 'Pak Guru',
      'content': announcementText,
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'announcement',
    };

    messages.add(newMessage);
    
    // Auto-scroll to bottom after sending announcement
    _scrollToBottom();
    
    Get.snackbar(
      'Pengumuman Terkirim',
      'Pengumuman berhasil dikirim ke grup',
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.purple,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
    );
  }

  void muteNotifications() {
    isMuted.value = !isMuted.value;
    
    Get.snackbar(
      isMuted.value ? 'Notifikasi Dibisukan' : 'Notifikasi Diaktifkan',
      isMuted.value 
          ? 'Anda tidak akan menerima notifikasi dari grup ini'
          : 'Anda akan menerima notifikasi dari grup ini',
      duration: const Duration(seconds: 2),
      backgroundColor: isMuted.value ? Colors.orange : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
    );
  }

  void deleteMessage(int index) {
    if (index >= 0 && index < messages.length) {
      messages.removeAt(index);
      
      Get.snackbar(
        'Pesan Dihapus',
        'Pesan berhasil dihapus',
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(8),
      );
    }
  }

  void replyToMessage(String originalMessage, String sender) {
    // Add reply functionality
    final replyText = 'Membalas $sender: "$originalMessage"\n\n${messageController.text}';
    
    final newMessage = {
      'sender': 'Pak Guru',
      'content': replyText,
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'reply',
    };

    messages.add(newMessage);
    messageController.clear();
    
    // Auto-scroll to bottom after replying
    _scrollToBottom();
  }

  void searchMessages(String query) {
    // Implement search functionality
    if (query.isEmpty) return;
    
    final filteredMessages = messages.where((message) {
      final content = message['content'].toString().toLowerCase();
      final sender = message['sender'].toString().toLowerCase();
      return content.contains(query.toLowerCase()) || 
             sender.contains(query.toLowerCase());
    }).toList();

    // Show search results in a dialog or new screen
    Get.dialog(
      AlertDialog(
        title: Text('Hasil Pencarian: "$query"'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: filteredMessages.length,
            itemBuilder: (context, index) {
              final message = filteredMessages[index];
              return ListTile(
                title: Text(message['sender']),
                subtitle: Text(
                  message['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(message['time']),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void sendImageMessage(String imagePath) {
    final newMessage = {
      'sender': 'Pak Guru',
      'content': '📷 Gambar',
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'image',
      'imagePath': imagePath,
    };

    messages.add(newMessage);
    
    // Auto-scroll to bottom after sending image
    _scrollToBottom();
    
    Get.snackbar(
      'Gambar Terkirim',
      'Gambar berhasil dikirim',
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
    );
  }

  void sendDocumentMessage(String fileName) {
    final newMessage = {
      'sender': 'Pak Guru',
      'content': '📄 $fileName',
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'document',
      'fileName': fileName,
    };

    messages.add(newMessage);
    
    // Auto-scroll to bottom after sending document
    _scrollToBottom();
    
    Get.snackbar(
      'Dokumen Terkirim',
      'Dokumen berhasil dikirim',
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
    );
  }

  void sendLocationMessage(String location) {
    final newMessage = {
      'sender': 'Pak Guru',
      'content': '📍 $location',
      'time': _getCurrentTime(),
      'isMe': true,
      'type': 'location',
      'location': location,
    };

    messages.add(newMessage);
    
    // Auto-scroll to bottom after sending location
    _scrollToBottom();
    
    Get.snackbar(
      'Lokasi Terkirim',
      'Lokasi berhasil dikirim',
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    // Enhanced scroll to bottom with smooth animation
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // Method to simulate receiving new messages
  void simulateIncomingMessage() {
    final sampleSenders = ['Ahmad', 'Siti', 'Budi', 'Maya', 'Rina'];
    final sampleMessages = [
      'Terima kasih pak!',
      'Baik pak, understood.',
      'Pak, kapan ujian berikutnya?',
      'Saya sudah mengerjakan tugas pak.',
      'Pak, bisa dijelaskan lagi?',
    ];

    final randomSender = sampleSenders[DateTime.now().millisecond % sampleSenders.length];
    final randomMessage = sampleMessages[DateTime.now().millisecond % sampleMessages.length];

    final newMessage = {
      'sender': randomSender,
      'content': randomMessage,
      'time': _getCurrentTime(),
      'isMe': false,
      'type': 'text',
    };

    messages.add(newMessage);
    
    // Auto-scroll to bottom when receiving new message
    _scrollToBottom();
  }

  // Method to get unread message count
  int getUnreadCount() {
    // In a real app, this would track actual unread messages
    return 0;
  }

  // Method to mark all messages as read
  void markAllAsRead() {
    // Implementation for marking messages as read
  }

  // Method to scroll to a specific message (useful for search results)
  void scrollToMessage(int index) {
    if (scrollController.hasClients && index >= 0 && index < messages.length) {
      // Calculate approximate position based on message index
      final position = index * 80.0; // Approximate height per message
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
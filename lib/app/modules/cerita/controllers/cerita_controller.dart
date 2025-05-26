import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CeritaController extends GetxController {
  // Map untuk menyimpan status like setiap story
  final Map<String, bool> _likedStories = {};
  
  // Map untuk menyimpan jumlah like setiap story  
  final Map<String, int> _likeCounts = {};
  
  // Untuk input post baru
  String _selectedImagePath = '';
  String get selectedImagePath => _selectedImagePath;
  
  // List post yang dibuat user (simulasi)
  final List<Map<String, dynamic>> _userPosts = [];
  
  // List teman-teman untuk share
  final List<Map<String, String>> _friendsList = [
    {
      'name': 'Siti Nurhaliza',
      'className': 'Teacher', 
      'avatar': 'assets/avatar/siti.jpg',
    },
    {
      'name': 'Budi Santoso',
      'className': 'Teacher',
      'avatar': 'assets/avatar/budi.jpg',
    },
    {
      'name': 'Dewi Sartika',
      'className': '9B',
      'avatar': 'assets/avatar/dewi.jpg',
    },
    {
      'name': 'Ahmad Fauzi',
      'className': '9B',
      'avatar': 'assets/avatar/ahmad.jpg',
    },
    {
      'name': 'Maya Putri',
      'className': '9B',
      'avatar': 'assets/avatar/maya.jpg',
    },
    {
      'name': 'Rio Pratama',
      'className': '9B',
      'avatar': 'assets/avatar/rio.jpg',
    },
    {
      'name': 'Lestari Wulan',
      'className': '9B',
      'avatar': 'assets/avatar/lestari.jpg',
    },
    {
      'name': 'Fahmi Ramadhan',
      'className': '9B',
      'avatar': 'assets/avatar/fahmi.jpg',
    },
  ];

  // Data simulasi untuk profil user
  final Map<String, Map<String, dynamic>> _userProfileData = {
    'Rafi Iqbal': {
      'Online': 1,
      'totalLikes': 156,
      'friends': 23,
      'recentPosts': [
        'assets/ghibli/kucing.jpg',
        'assets/ghibli/gunung.jpg',
        'assets/ghibli/rpl.jpg',
      ],
    },
    'Antok Simanjuntak': {
      'Online': 2,
      'totalLikes': 89,
      'friends': 18,
      'recentPosts': [
        'assets/ghibli/gunung.jpg',
        'assets/ghibli/ponyo.jpg',
        'assets/ghibli/rpl.jpg',
      ],
    },
    'Ahmad Rizki': {
      'Online': 1,
      'totalLikes': 234,
      'friends': 31,
      'recentPosts': [
        'assets/ghibli/rpl.jpg',
        'assets/ghibli/kucing.jpg',
        'assets/ghibli/gunung.jpg',
      ],
    },
    'Arip Kopling': {
      'Online': 3,
      'totalLikes': 67,
      'friends': 14,
      'recentPosts': [
        'assets/ghibli/ponyo.jpg',
        'assets/ghibli/kucing.jpg',
        'assets/ghibli/gunung.jpg',
      ],
    },
  };

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultLikes();
  }

  // Inisialisasi default like count untuk setiap story
  void _initializeDefaultLikes() {
    _likeCounts['story_1'] = 24;
    _likeCounts['story_2'] = 18;
    _likeCounts['story_3'] = 32;
    _likeCounts['story_4'] = 15;
    
    // Set default liked status to false for all stories
    _likedStories['story_1'] = false;
    _likedStories['story_2'] = false;
    _likedStories['story_3'] = false;
    _likedStories['story_4'] = false;
  }

  // Getter untuk friends list
  List<Map<String, String>> get friendsList => _friendsList;

  // Check apakah story sudah di-like
  bool isStoryLiked(String storyId) {
    return _likedStories[storyId] ?? false;
  }

  // Get jumlah like untuk story tertentu
  int getStoryLikeCount(String storyId) {
    return _likeCounts[storyId] ?? 0;
  }

  // Toggle like status
  void toggleLike(String storyId) {
    final currentStatus = _likedStories[storyId] ?? false;
    final currentCount = _likeCounts[storyId] ?? 0;
    
    if (currentStatus) {
      // Unlike - kurangi count
      _likedStories[storyId] = false;
      _likeCounts[storyId] = currentCount - 1;
      
    } else {
      // Like - tambah count
      _likedStories[storyId] = true;
      _likeCounts[storyId] = currentCount + 1;
      
    }
    
    // Update UI
    update();
  }

  // Simulasi pick image
  void pickImage() {
    // Simulasi memilih gambar dari galeri
    final List<String> availableImages = [
      'assets/ghibli/kucing.jpg',
      'assets/ghibli/gunung.jpg',
      'assets/ghibli/rpl.jpg',
      'assets/ghibli/ponyo.jpg',
    ];
    
    // Pilih gambar secara random untuk simulasi
    _selectedImagePath = (availableImages..shuffle()).first;
    
    Get.snackbar(
      '📷 Gambar Dipilih',
      'Gambar berhasil dipilih dari galeri',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
    
    update();
  }

  // Clear selected image
  void clearSelectedImage() {
    _selectedImagePath = '';
    update();
  }

  // Create new post
  void createNewPost(String caption) {
    if (caption.isEmpty && _selectedImagePath.isEmpty) {
      Get.snackbar(
        '⚠️ Peringatan',
        'Silakan tulis caption atau pilih gambar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return;
    }

    // Simulasi membuat post baru
    final newPost = {
      'id': 'user_post_${DateTime.now().millisecondsSinceEpoch}',
      'caption': caption,
      'image': _selectedImagePath,
      'timestamp': DateTime.now(),
      'likes': 0,
      'isLiked': false,
    };

    _userPosts.insert(0, newPost); // Insert di awal list
    
    // Clear input
    _selectedImagePath = '';
    
    // Tutup pop-up/dialog terlebih dahulu
    Get.back();
    
    // Tampilkan snackbar sukses
    Get.snackbar(
      '✅ Berhasil',
      'Post berhasil dibuat!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
    
    update();
  }

  // Get user posts
  List<Map<String, dynamic>> get userPosts => _userPosts;

  // Get user stats untuk profile
  Map<String, dynamic> getUserStats(String userName) {
    return _userProfileData[userName] ?? {
      'Online': 0,
      'totalLikes': 0,
      'friends': 0,
      'recentPosts': <String>[],
    };
  }

  // Follow user
  void followUser(String userName) {
    Get.snackbar(
      '👥 Mengikuti',
      'Anda sekarang mengikuti $userName',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.purple.shade100,
      colorText: Colors.purple.shade800,
    );
  }

  // Share story ke teman
  void shareToFriend(String storyId, String friendName, String authorName, String caption) {
    Get.snackbar(
      '📤 Berhasil Dibagikan!',
      'Cerita dari $authorName telah dikirim ke $friendName',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.purple.shade100,
      colorText: Colors.purple.shade800,
    );
    
    // Simulasi notifikasi ke teman (bisa ditambahkan ke sistem notifikasi)
    _simulateNotificationToFriend(friendName, authorName, caption);
  }

  // Simulasi notifikasi ke teman
  void _simulateNotificationToFriend(String friendName, String authorName, String caption) {
    // Di implementasi nyata, ini akan mengirim notifikasi ke database/server
    print('Notification sent to $friendName: $authorName shared a story - "$caption"');
    
    // Bisa tambahkan logic untuk menyimpan notifikasi ke local storage atau server
    // Contoh: _notificationService.sendShareNotification(friendName, authorName, caption);
  }

  // Tambah teman baru (optional)
  void addFriend(String name, String className, String avatar) {
    _friendsList.add({
      'name': name,
      'className': className,
      'avatar': avatar,
    });
    
    update(); // Update UI
    
    Get.snackbar(
      '👥 Teman Ditambahkan!',
      '$name telah ditambahkan ke daftar teman',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Hapus teman (optional)
  void removeFriend(String name) {
    _friendsList.removeWhere((friend) => friend['name'] == name);
    
    update(); // Update UI
    
    Get.snackbar(
      'Teman Dihapus',
      '$name telah dihapus dari daftar teman',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Search friends (optional untuk fitur pencarian)
  List<Map<String, String>> searchFriends(String query) {
    if (query.isEmpty) return _friendsList;
    
    return _friendsList.where((friend) {
      final name = friend['name']!.toLowerCase();
      final className = friend['className']!.toLowerCase();
      final searchQuery = query.toLowerCase();
      
      return name.contains(searchQuery) || className.contains(searchQuery);
    }).toList();
  }

  // Get statistics (optional untuk dashboard admin)
  Map<String, dynamic> getStoryStatistics(String storyId) {
    return {
      'likes': _likeCounts[storyId] ?? 0,
      'isLiked': _likedStories[storyId] ?? false,
      'shareCount': 0, // Bisa ditambahkan tracking share count
    };
  }

  // Reset all likes (untuk testing atau admin)
  void resetAllLikes() {
    _likedStories.clear();
    _initializeDefaultLikes();
    
    Get.snackbar(
      'Reset Selesai',
      'Semua like telah direset',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Simulasi upload gambar ke server
  Future<void> uploadImageToServer(String imagePath) async {
    // Simulasi delay upload
    await Future.delayed(const Duration(seconds: 2));
    
    Get.snackbar(
      '☁️ Upload Berhasil',
      'Gambar berhasil diupload ke server',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
    );
  }

  // Get trending hashtags (simulasi)
  List<String> getTrendingHashtags() {
    return [
      '#SekolahKita',
      '#RPLKeren',
      '#BelajarCoding',
      '#TmanSekolah',
      '#ProjectSekolah',
      '#KelasXRPL',
      '#ProgrammerMuda',
      '#SemangatBelajar',
    ];
  }

  // Add hashtag to post
  void addHashtagToPost(String postId, String hashtag) {
    // Logic untuk menambah hashtag ke post
    Get.snackbar(
      '🏷️ Hashtag Ditambahkan',
      'Hashtag $hashtag berhasil ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Save post as draft
  void saveAsDraft(String caption, String imagePath) {
    Get.snackbar(
      '💾 Disimpan sebagai Draft',
      'Post berhasil disimpan sebagai draft',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.grey.shade100,
      colorText: Colors.grey.shade800,
    );
  }

  // Report user
  void reportUser(String userName, String reason) {
    Get.snackbar(
      '🚨 Laporan Terkirim',
      'Laporan tentang $userName berhasil dikirim',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
    );
  }

  // Block user
  void blockUser(String userName) {
    Get.snackbar(
      '🚫 User Diblokir',
      '$userName telah diblokir',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
    );
  }
}
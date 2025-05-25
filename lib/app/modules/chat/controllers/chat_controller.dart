import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model untuk Chat User
class ChatUser {
  final String id;
  final String name;
  final String nomorInduk; // Nomor induk siswa/guru
  final String role; // 'guru' atau 'murid'
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  ChatUser({
    required this.id,
    required this.name,
    required this.nomorInduk,
    required this.role,
    this.avatar,
    this.isOnline = false,
    this.lastSeen,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      nomorInduk: json['nomorInduk'],
      role: json['role'],
      avatar: json['avatar'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nomorInduk': nomorInduk,
      'role': role,
      'avatar': avatar,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }
}

// Model untuk Chat Conversation
class ChatConversation {
  final String id;
  final ChatUser otherUser;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isTyping;

  ChatConversation({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.isTyping = false,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'],
      otherUser: ChatUser.fromJson(json['otherUser']),
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null ? DateTime.parse(json['lastMessageTime']) : null,
      unreadCount: json['unreadCount'] ?? 0,
      isTyping: json['isTyping'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUser': otherUser.toJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'isTyping': isTyping,
    };
  }
}

class ChatController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var searchController = TextEditingController();
  var searchQuery = ''.obs;
  var chatUsers = <ChatUser>[].obs;
  var filteredUsers = <ChatUser>[].obs;
  var conversations = <ChatConversation>[].obs;
  var selectedTab = 0.obs; // 0 = Conversations, 1 = All Users

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterUsers();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load initial data (mock data for now)
  void loadInitialData() {
    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      // Mock data - replace with actual API calls
      loadMockUsers();
      loadMockConversations();
      isLoading.value = false;
    });
  }

  // Load mock users data
  void loadMockUsers() {
    chatUsers.value = [
      // Guru
      ChatUser(
        id: '1',
        name: 'Bambang',
        nomorInduk: 'GR001',
        role: 'guru',
        avatar: 'assets/avatar/guru.jpg',
        isOnline: true,
      ),
      ChatUser(
        id: '2',
        name: 'Sari Wijaya',
        nomorInduk: 'GR002',
        role: 'guru',
        avatar: 'assets/avatar/guru2.jpg',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      // Murid
      ChatUser(
        id: '3',
        name: 'Ahmad Rizki',
        nomorInduk: '2024001',
        role: 'murid',
        avatar: 'assets/avatar/rafi1.jpg',
        isOnline: true,
      ),
      ChatUser(
        id: '4',
        name: 'Dewi Putri',
        nomorInduk: '2024002',
        role: 'murid',
        avatar: 'assets/avatar/meow.jpg',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatUser(
        id: '5',
        name: 'Arip Kopling',
        nomorInduk: '2024003',
        role: 'murid',
        avatar: 'assets/avatar/rafi3.jpg',
        isOnline: true,
      ),
      ChatUser(
        id: '6',
        name: 'Antok Simanjuntak',
        nomorInduk: '2024004',
        role: 'murid',
        avatar: 'assets/avatar/rafi2.jpg',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
    filteredUsers.value = chatUsers;
  }

  // Load mock conversations
  void loadMockConversations() {
    conversations.value = [
      ChatConversation(
        id: 'conv_1',
        otherUser: chatUsers.firstWhere((user) => user.id == '3'),
        lastMessage: 'Saya ingin bertanya pak, apakah boleh?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 1,
      ),
      ChatConversation(
        id: 'conv_2',
        otherUser: chatUsers.firstWhere((user) => user.id == '4'),
        lastMessage: 'Terima kasih atas penjelasannya pak',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
      ),
      ChatConversation(
        id: 'conv_3',
        otherUser: chatUsers.firstWhere((user) => user.id == '1'),
        lastMessage: 'Pak sampeyan dimana?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 1,
      ),
    ];
  }

  // Filter users based on search query
  void filterUsers() {
    if (searchQuery.value.isEmpty) {
      filteredUsers.value = chatUsers;
    } else {
      filteredUsers.value = chatUsers.where((user) {
        return user.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               user.nomorInduk.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredUsers.value = chatUsers;
  }

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Navigate to chat detail
  void openChatDetail(ChatUser user) {
    // Navigate to individual chat screen
    Get.toNamed('/chat-detail', arguments: user);
  }

  // Start new conversation
  void startNewConversation(ChatUser user) {
    // Check if conversation already exists
    int existingIndex = conversations.indexWhere(
      (conv) => conv.otherUser.id == user.id
    );

    if (existingIndex != -1) {
      // If conversation exists, open it
      openChatDetail(user);
    } else {
      // Create new conversation
      ChatConversation newConversation = ChatConversation(
        id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
        otherUser: user,
        lastMessage: null,
        lastMessageTime: null,
        unreadCount: 0,
      );
      
      conversations.insert(0, newConversation);
      openChatDetail(user);
    }
  }

  // Get formatted last seen time
  String getLastSeenText(DateTime? lastSeen) {
    if (lastSeen == null) return 'Tidak diketahui';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return 'Lebih dari seminggu';
    }
  }

  // Get formatted message time
  String getMessageTimeText(DateTime? messageTime) {
    if (messageTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(messageTime);
    
    if (difference.inMinutes < 1) {
      return 'Sekarang';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}j';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}h';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }

  // Refresh data
  void refreshData() {
    loadInitialData();
  }
}
import 'package:get/get.dart';

class NotifikasiController extends GetxController {
  // Observable variables for notifications
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;
    
    // Simulate loading notifications
    Future.delayed(const Duration(seconds: 1), () {
      notifications.value = [
        NotificationModel(
          id: '1',
          type: 'announcement',
          title: 'Pengumuman Baru',
          subtitle: 'Jadwal Ujian Tengah Semester',
          content: 'Ujian akan dilaksanakan pada tanggal 15-20 Juli 2025. Harap persiapkan diri dengan baik.',
          time: '2 jam yang lalu',
          isRead: false,
          icon: 'campaign',
          iconColor: 'purple',
        ),
        NotificationModel(
          id: '2',
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Ahmad mengirim pesan',
          content: 'Pak, tugas yang kemarin sudah harus dikumpulkan hari ini kan?',
          time: '30 menit yang lalu',
          isRead: false,
          icon: 'group',
          iconColor: 'green',
        ),
        NotificationModel(
          id: '3',
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Siti mengirim pesan',
          content: 'Terima kasih pak atas penjelasannya tadi',
          time: '1 jam yang lalu',
          isRead: false,
          icon: 'group',
          iconColor: 'green',
        ),
        NotificationModel(
          id: '4',
          type: 'assignment',
          title: 'Tugas Baru',
          subtitle: 'Matematika - Kelas 9B',
          content: 'Tugas Aljabar Bab 3 telah diberikan',
          time: '3 jam yang lalu',
          isRead: true,
          icon: 'assignment',
          iconColor: 'orange',
        ),
        NotificationModel(
          id: '5',
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Budi mengirim pesan',
          content: 'Selamat pagi pak, izin bertanya tentang materi kemarin',
          time: '5 jam yang lalu',
          isRead: true,
          icon: 'group',
          iconColor: 'green',
        ),
        NotificationModel(
          id: '6',
          type: 'announcement',
          title: 'Pengumuman',
          subtitle: 'Perubahan Jadwal Pelajaran',
          content: 'Jadwal pelajaran hari Jumat mengalami perubahan. Silakan cek jadwal terbaru di aplikasi.',
          time: '1 hari yang lalu',
          isRead: true,
          icon: 'campaign',
          iconColor: 'purple',
        ),
        NotificationModel(
          id: '7',
          type: 'group_message',
          title: 'Grup 9B',
          subtitle: 'Lisa mengirim pesan',
          content: 'Pak, kapan jadwal remedial matematika?',
          time: '1 hari yang lalu',
          isRead: true,
          icon: 'group',
          iconColor: 'green',
        ),
        NotificationModel(
          id: '8',
          type: 'system',
          title: 'Sistem',
          subtitle: 'Backup data berhasil',
          content: 'Data kelas 9B telah berhasil di-backup ke server',
          time: '2 hari yang lalu',
          isRead: true,
          icon: 'cloud_done',
          iconColor: 'blue',
        ),
      ];
      
      updateUnreadCount();
      isLoading.value = false;
    });
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    updateUnreadCount();
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    updateUnreadCount();
  }

  void clearAllNotifications() {
    notifications.clear();
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void addNewNotification(NotificationModel notification) {
    notifications.insert(0, notification);
    updateUnreadCount();
  }

  List<NotificationModel> getNotificationsByType(String type) {
    return notifications.where((n) => n.type == type).toList();
  }

  List<NotificationModel> getUnreadNotifications() {
    return notifications.where((n) => !n.isRead).toList();
  }

  void refreshNotifications() {
    loadNotifications();
  }
}

class NotificationModel {
  String id;
  String type;
  String title;
  String subtitle;
  String content;
  String time;
  bool isRead;
  String icon;
  String iconColor;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.iconColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'time': time,
      'isRead': isRead,
      'icon': icon,
      'iconColor': iconColor,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      time: json['time'],
      isRead: json['isRead'],
      icon: json['icon'],
      iconColor: json['iconColor'],
    );
  }
}
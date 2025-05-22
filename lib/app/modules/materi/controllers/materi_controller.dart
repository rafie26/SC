import 'package:get/get.dart';

class MateriController extends GetxController {
  // Observable variables
  var searchQuery = ''.obs;
  var selectedSubject = 'Semua'.obs;
  var materiList = <MateriModel>[].obs;
  var filteredMateriList = <MateriModel>[].obs;
  var isLoading = false.obs;
  var subjectList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMateriData();
    loadSubjectList();
    
    // Listen to search and filter changes
    ever(searchQuery, (_) => filterMateri());
    ever(selectedSubject, (_) => filterMateri());
  }

  void loadMateriData() {
    isLoading.value = true;
    
    // Simulate loading data - replace with actual API call
    materiList.value = [
      MateriModel(
        id: '1',
        title: 'Pengenalan Integral',
        subject: 'Matematika',
        kelas: 'X RPL B',
        description: 'Materi dasar tentang konsep integral dan aplikasinya dalam matematika',
        type: 'PDF',
        uploadDate: '20 Mei 2025',
        fileSize: '2.3 MB',
        views: 28,
      ),
      MateriModel(
        id: '2',
        title: 'Video Tutorial Database',
        subject: 'Basis Data',
        kelas: 'X RPL A, X RPL B',
        description: 'Tutorial lengkap membuat database dengan MySQL',
        type: 'Video',
        uploadDate: '18 Mei 2025',
        fileSize: '45.2 MB',
        views: 35,
      ),
      MateriModel(
        id: '3',
        title: 'Struktur Teks Eksposisi',
        subject: 'Bahasa Indonesia',
        kelas: 'X RPL A',
        description: 'Memahami struktur dan ciri-ciri teks eksposisi',
        type: 'PowerPoint',
        uploadDate: '15 Mei 2025',
        fileSize: '5.8 MB',
        views: 24,
      ),
      MateriModel(
        id: '4',
        title: 'Algoritma Sorting',
        subject: 'Pemrograman',
        kelas: 'X RPL B',
        description: 'Penjelasan berbagai algoritma sorting: bubble sort, selection sort, insertion sort',
        type: 'PDF',
        uploadDate: '12 Mei 2025',
        fileSize: '3.1 MB',
        views: 31,
      ),
    ];
    
    filterMateri();
    isLoading.value = false;
  }

  void loadSubjectList() {
    subjectList.value = [
      'Semua',
      'Matematika',
      'Bahasa Indonesia',
      'Basis Data',
      'Pemrograman',
    ];
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSelectedSubject(String subject) {
    selectedSubject.value = subject;
  }

  void filterMateri() {
    var filtered = materiList.toList();
    
    // Filter by subject
    if (selectedSubject.value != 'Semua') {
      filtered = filtered.where((materi) => 
        materi.subject == selectedSubject.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((materi) =>
        materi.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        materi.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        materi.subject.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    filteredMateriList.value = filtered;
  }

  void navigateToAddMateri() {
    Get.toNamed('/tambah-materi');
  }

  void navigateToDetailMateri(String materiId) {
    Get.toNamed('/detail-materi', arguments: {'materiId': materiId});
  }

  void editMateri(String materiId) {
    Get.toNamed('/edit-materi', arguments: {'materiId': materiId});
  }

  void deleteMateri(String materiId) {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah Anda yakin ingin menghapus materi ini?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        materiList.removeWhere((materi) => materi.id == materiId);
        filterMateri();
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Materi berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void refreshData() {
    loadMateriData();
  }

  void incrementViews(String materiId) {
    final materiIndex = materiList.indexWhere((materi) => materi.id == materiId);
    if (materiIndex != -1) {
      materiList[materiIndex] = materiList[materiIndex].copyWith(
        views: materiList[materiIndex].views + 1,
      );
      filterMateri();
    }
  }
}

// Model class for Materi
class MateriModel {
  final String id;
  final String title;
  final String subject;
  final String kelas;
  final String description;
  final String type;
  final String uploadDate;
  final String fileSize;
  final int views;

  MateriModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.kelas,
    required this.description,
    required this.type,
    required this.uploadDate,
    required this.fileSize,
    required this.views,
  });

  // Copy with method for immutable updates
  MateriModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? kelas,
    String? description,
    String? type,
    String? uploadDate,
    String? fileSize,
    int? views,
  }) {
    return MateriModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      kelas: kelas ?? this.kelas,
      description: description ?? this.description,
      type: type ?? this.type,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSize: fileSize ?? this.fileSize,
      views: views ?? this.views,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'kelas': kelas,
      'description': description,
      'type': type,
      'uploadDate': uploadDate,
      'fileSize': fileSize,
      'views': views,
    };
  }

  // Create from JSON
  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      kelas: json['kelas'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
      fileSize: json['fileSize'] ?? '',
      views: json['views'] ?? 0,
    );
  }
}
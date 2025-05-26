import 'package:get/get.dart';

class TugasController extends GetxController {
  // Observable variables
  var selectedFilter = 'Semua'.obs;
  var tugasList = <TugasModel>[].obs;
  var filteredTugasList = <TugasModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTugasData();
    // Listen to filter changes
    ever(selectedFilter, (_) => filterTugas());
  }

  void loadTugasData() {
    isLoading.value = true;
    
    // Simulate loading data - replace with actual API call
    tugasList.value = [
      TugasModel(
        id: '1',
        title: 'Tugas Matematika - Integral',
        subject: 'Matematika',
        kelas: '9B',
        deadline: '25 Mei 2025',
        status: 'Aktif',
        submittedCount: 15,
        totalStudents: 30,
      ),
      TugasModel(
        id: '2',
        title: 'Tugas Matematika - Bilangan Akar',
        subject: 'Matematika',
        kelas: '9B',
        deadline: '28 Mei 2025',
        status: 'Aktif',
        submittedCount: 22,
        totalStudents: 28,
      ),
      TugasModel(
        id: '3',
        title: 'Tugas Matematika - SPLDV',
        subject: 'Matematika',
        kelas: '9B',
        deadline: '20 Mei 2025',
        status: 'Selesai',
        submittedCount: 30,
        totalStudents: 30,
      ),
    ];
    
    filterTugas();
    isLoading.value = false;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void filterTugas() {
    switch (selectedFilter.value) {
      case 'Aktif':
        filteredTugasList.value = tugasList.where((tugas) => tugas.status == 'Aktif').toList();
        break;
      case 'Selesai':
        filteredTugasList.value = tugasList.where((tugas) => tugas.status == 'Selesai').toList();
        break;
      case 'Semua':
      default:
        filteredTugasList.value = tugasList.toList();
        break;
    }
  }

  void navigateToAddTugas() {
    Get.toNamed('/tambah-tugas');
  }

  void navigateToDetailTugas(String tugasId) {
    // Navigate to /tugas-detail with tugasId as argument
    Get.toNamed('/tugas-detail', arguments: {'tugasId': tugasId});
  }

  void refreshData() {
    loadTugasData();
  }
}

// Model class for Tugas
class TugasModel {
  final String id;
  final String title;
  final String subject;
  final String kelas;
  final String deadline;
  final String status;
  final int submittedCount;
  final int totalStudents;

  TugasModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.kelas,
    required this.deadline,
    required this.status,
    required this.submittedCount,
    required this.totalStudents,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'kelas': kelas,
      'deadline': deadline,
      'status': status,
      'submittedCount': submittedCount,
      'totalStudents': totalStudents,
    };
  }

  // Create from JSON
  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      kelas: json['kelas'] ?? '',
      deadline: json['deadline'] ?? '',
      status: json['status'] ?? '',
      submittedCount: json['submittedCount'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
    );
  }
}
import 'package:get/get.dart';

class TugasDetailController extends GetxController {
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
        kelas: 'X RPL B',
        deadline: '25 Mei 2025',
        status: 'Aktif',
        submittedCount: 15,
        totalStudents: 30,
        description: 'Kerjakan soal-soal integral pada buku paket halaman 145-150. Tuliskan langkah-langkah penyelesaian dengan jelas dan rapi.',
        attachments: ['soal_integral.pdf', 'contoh_penyelesaian.pdf'],
        createdDate: '20 Mei 2025',
        dueTime: '23:59',
      ),
      TugasModel(
        id: '2',
        title: 'Essay Bahasa Indonesia',
        subject: 'Bahasa Indonesia',
        kelas: 'X RPL A',
        deadline: '28 Mei 2025',
        status: 'Aktif',
        submittedCount: 22,
        totalStudents: 28,
        description: 'Buatlah essay dengan tema "Teknologi dalam Pendidikan" minimal 500 kata. Gunakan bahasa yang baik dan benar.',
        attachments: ['panduan_essay.pdf'],
        createdDate: '21 Mei 2025',
        dueTime: '23:59',
      ),
      TugasModel(
        id: '3',
        title: 'Praktikum Database',
        subject: 'Basis Data',
        kelas: 'X RPL B',
        deadline: '20 Mei 2025',
        status: 'Selesai',
        submittedCount: 30,
        totalStudents: 30,
        description: 'Implementasikan database sekolah dengan minimal 5 tabel yang saling berelasi. Sertakan query untuk CRUD operations.',
        attachments: ['erd_template.pdf', 'sample_data.sql'],
        createdDate: '15 Mei 2025',
        dueTime: '23:59',
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
    Get.toNamed('/detail-tugas', arguments: {'tugasId': tugasId});
  }

  void refreshData() {
    loadTugasData();
  }

  // Method to get tugas by ID (used by detail controller)
  TugasModel? getTugasById(String id) {
    try {
      return tugasList.firstWhere((tugas) => tugas.id == id);
    } catch (e) {
      return null;
    }
  }

  // Method to update tugas status
  void updateTugasStatus(String id, String newStatus) {
    final index = tugasList.indexWhere((tugas) => tugas.id == id);
    if (index != -1) {
      // Create updated tugas with new status
      final updatedTugas = TugasModel(
        id: tugasList[index].id,
        title: tugasList[index].title,
        subject: tugasList[index].subject,
        kelas: tugasList[index].kelas,
        deadline: tugasList[index].deadline,
        status: newStatus,
        submittedCount: tugasList[index].submittedCount,
        totalStudents: tugasList[index].totalStudents,
        description: tugasList[index].description,
        attachments: tugasList[index].attachments,
        createdDate: tugasList[index].createdDate,
        dueTime: tugasList[index].dueTime,
      );
      
      tugasList[index] = updatedTugas;
      filterTugas(); // Refresh filtered list
    }
  }

  // Method to delete tugas
  void deleteTugas(String id) {
    tugasList.removeWhere((tugas) => tugas.id == id);
    filterTugas(); // Refresh filtered list
  }
}

// Enhanced TugasModel with additional fields for detail view
class TugasModel {
  final String id;
  final String title;
  final String subject;
  final String kelas;
  final String deadline;
  final String status;
  final int submittedCount;
  final int totalStudents;
  final String? description;
  final List<String>? attachments;
  final String? createdDate;
  final String? dueTime;

  TugasModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.kelas,
    required this.deadline,
    required this.status,
    required this.submittedCount,
    required this.totalStudents,
    this.description,
    this.attachments,
    this.createdDate,
    this.dueTime,
  });

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
      'description': description,
      'attachments': attachments,
      'createdDate': createdDate,
      'dueTime': dueTime,
    };
  }

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
      description: json['description'],
      attachments: json['attachments']?.cast<String>(),
      createdDate: json['createdDate'],
      dueTime: json['dueTime'],
    );
  }
}
import 'package:get/get.dart';

class NilaiController extends GetxController {
  // Observable variables
  var selectedKelas = ''.obs;
  var allSiswa = <Map<String, dynamic>>[].obs;
  var filteredSiswa = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data
    _initializeDummyData();
    // Set default selected class
    selectedKelas.value = '9B';
    _filterSiswaByKelas();
  }

  // Initialize with some dummy data for demonstration
  void _initializeDummyData() {
    allSiswa.value = [
      {
        'nama': 'Ahmad Fauzi',
        'nis': '2024001',
        'kelas': '9B',
        'nilaiUH': 85,
        'nilaiUTS': 78,
        'nilaiUAS': 82,
        'nilaiAkhir': 82,
        'tugasBelumSelesai': 0,
        'status': 'lengkap',
      },
      {
        'nama': 'Siti Aminah',
        'nis': '2024002',
        'kelas': '9B',
        'nilaiUH': 90,
        'nilaiUTS': 88,
        'nilaiUAS': 92,
        'nilaiAkhir': 90,
        'tugasBelumSelesai': 0,
        'status': 'lengkap',
      },
      {
        'nama': 'Budi Santoso',
        'nis': '2024003',
        'kelas': '9B',
        'nilaiUH': 65,
        'nilaiUTS': 70,
        'nilaiUAS': 68,
        'nilaiAkhir': 68,
        'tugasBelumSelesai': 0,
        'status': 'lengkap',
      },
      {
        'nama': 'Dewi Lestari',
        'nis': '2024004',
        'kelas': '9C',
        'nilaiUH': 88,
        'nilaiUTS': 85,
        'nilaiUAS': 90,
        'nilaiAkhir': 88,
        'tugasBelumSelesai': 0,
        'status': 'lengkap',
      },
      {
        'nama': 'Rizki Pratama',
        'nis': '2024005',
        'kelas': '9C',
        'nilaiUH': 75,
        'nilaiUTS': 80,
        'nilaiUAS': 78,
        'nilaiAkhir': 78,
        'tugasBelumSelesai': 2,
        'status': 'kurang',
      },
      {
        'nama': 'Maya Sari',
        'nis': '2024006',
        'kelas': '9D',
        'nilaiUH': 92,
        'nilaiUTS': 89,
        'nilaiUAS': 94,
        'nilaiAkhir': 92,
        'tugasBelumSelesai': 0,
        'status': 'lengkap',
      },
      {
        'nama': 'Andi Wijaya',
        'nis': '2024007',
        'kelas': '9D',
        'nilaiUH': 60,
        'nilaiUTS': 65,
        'nilaiUAS': 62,
        'nilaiAkhir': 62,
        'tugasBelumSelesai': 4,
        'status': 'tidak_lengkap',
      },
    ];
  }

  // Select class and filter students
  void selectKelas(String kelas) {
    selectedKelas.value = kelas;
    _filterSiswaByKelas();
  }

  // Filter students by selected class
  void _filterSiswaByKelas() {
    if (selectedKelas.value.isEmpty) {
      filteredSiswa.clear();
    } else {
      filteredSiswa.value = allSiswa
          .where((siswa) => siswa['kelas'] == selectedKelas.value)
          .toList();
    }
  }

  // Calculate final grade based on UH, UTS, UAS and incomplete tasks
  int _calculateNilaiAkhir(int nilaiUH, int nilaiUTS, int nilaiUAS, int tugasBelumSelesai) {
    // Formula: (UH * 30% + UTS * 35% + UAS * 35%) - (incomplete tasks * 5)
    double nilaiAkhir = (nilaiUH * 0.3) + (nilaiUTS * 0.35) + (nilaiUAS * 0.35);
    
    // Reduce score for incomplete tasks
    nilaiAkhir -= (tugasBelumSelesai * 5);
    
    // Ensure minimum score is 0
    if (nilaiAkhir < 0) nilaiAkhir = 0;
    
    return nilaiAkhir.round();
  }

  // Determine student status based on grades and tasks
  String _getStatus(int nilaiAkhir, int tugasBelumSelesai) {
    if (tugasBelumSelesai == 0 && nilaiAkhir >= 75) {
      return 'lengkap';
    } else if (tugasBelumSelesai <= 2 && nilaiAkhir >= 65) {
      return 'kurang';
    } else {
      return 'tidak_lengkap';
    }
  }

  // Update student grades
  void updateNilai(String nis, int nilaiUH, int nilaiUTS, int nilaiUAS, int tugasBelumSelesai) {
    try {
      // Find student index
      int index = allSiswa.indexWhere((siswa) => siswa['nis'] == nis);
      
      if (index != -1) {
        // Calculate final grade
        int nilaiAkhir = _calculateNilaiAkhir(nilaiUH, nilaiUTS, nilaiUAS, tugasBelumSelesai);
        
        // Determine status
        String status = _getStatus(nilaiAkhir, tugasBelumSelesai);
        
        // Update student data
        allSiswa[index] = {
          ...allSiswa[index],
          'nilaiUH': nilaiUH,
          'nilaiUTS': nilaiUTS,  
          'nilaiUAS': nilaiUAS,
          'nilaiAkhir': nilaiAkhir,
          'tugasBelumSelesai': tugasBelumSelesai,
          'status': status,
        };
        
        // Refresh filtered list
        _filterSiswaByKelas();
        
        // Show success message
        Get.snackbar(
          'Berhasil',
          'Nilai siswa berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        throw Exception('Siswa tidak ditemukan');
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal memperbarui nilai: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Get statistics for selected class
  Map<String, dynamic> getStatistikKelas() {
    if (filteredSiswa.isEmpty) {
      return {
        'totalSiswa': 0,
        'rataRata': 0.0,
        'nilaiTertinggi': 0,
        'nilaiTerendah': 0,
        'siswaLengkap': 0,
        'siswaKurang': 0,
        'siswaTidakLengkap': 0,
      };
    }

    List<int> nilaiAkhir = filteredSiswa.map((s) => s['nilaiAkhir'] as int).toList();
    
    return {
      'totalSiswa': filteredSiswa.length,
      'rataRata': nilaiAkhir.reduce((a, b) => a + b) / nilaiAkhir.length,
      'nilaiTertinggi': nilaiAkhir.reduce((a, b) => a > b ? a : b),
      'nilaiTerendah': nilaiAkhir.reduce((a, b) => a < b ? a : b),
      'siswaLengkap': filteredSiswa.where((s) => s['status'] == 'lengkap').length,
      'siswaKurang': filteredSiswa.where((s) => s['status'] == 'kurang').length,
      'siswaTidakLengkap': filteredSiswa.where((s) => s['status'] == 'tidak_lengkap').length,
    };
  }

  // Search students by name
  void cariSiswa(String query) {
    if (query.isEmpty) {
      _filterSiswaByKelas();
    } else {
      filteredSiswa.value = allSiswa
          .where((siswa) => 
              siswa['kelas'] == selectedKelas.value &&
              siswa['nama'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMateriController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<MateriModel?> materi = Rx<MateriModel?>(null);
  
  String? materiId;

  @override
  void onInit() {
    super.onInit();
    materiId = Get.arguments as String?;
    if (materiId != null) {
      loadMateriDetail();
    }
  }

  void loadMateriDetail() async {
    try {
      isLoading.value = true;
      
      // Simulasi loading data dari API atau database
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Replace dengan actual data loading
      // final result = await apiService.getMateriById(materiId);
      // materi.value = result;
      
      // Contoh data dummy - ganti dengan data actual
      materi.value = MateriModel(
        id: materiId!,
        title: 'Pengenalan Integral',
        description: 'Ini adalah contoh deskripsi materi yang akan ditampilkan di halaman detail.',
        subject: 'Matematika',
        kelas: 'Kelas 10',
        type: 'PDF',
        fileSize: '2.5 MB',
        uploadDate: '15 Nov 2024',
        views: 125,
        fileUrl: 'https://example.com/file.pdf',
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat detail materi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openMateri() async {
    if (materi.value?.fileUrl != null) {
      final url = Uri.parse(materi.value!.fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka file',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void downloadMateri() async {
    // Implementasi download file
    Get.snackbar(
      'Download',
      'Memulai download...',
      snackPosition: SnackPosition.BOTTOM,
    );
    
    // Add actual download logic here
    // You might want to use dio package for file downloads
  }

  void shareMateri() async {
    if (materi.value != null) {
      final materiData = materi.value!;
      await Share.share(
        'Lihat materi "${materiData.title}" - ${materiData.subject}\n\n${materiData.description}',
        subject: 'Materi Pembelajaran: ${materiData.title}',
      );
    }
  }
}

// Binding class
class DetailMateriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMateriController>(() => DetailMateriController());
  }
}

// Model class (jika belum ada)
class MateriModel {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String kelas;
  final String type;
  final String fileSize;
  final String uploadDate;
  int views;
  final String fileUrl;

  MateriModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.kelas,
    required this.type,
    required this.fileSize,
    required this.uploadDate,
    required this.views,
    required this.fileUrl,
  });
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tugas_detail_controller.dart';

class TugasDetailView extends GetView<TugasDetailController> {
  const TugasDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get tugasId from arguments
    final String? tugasId = Get.arguments?['tugasId'];
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C1FB4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Detail Tugas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  // Navigate to edit page
                  Get.toNamed('/edit-tugas', arguments: {'tugasId': tugasId});
                  break;
                case 'delete':
                  _showDeleteDialog(tugasId);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit Tugas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus Tugas', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6C1FB4),
            ),
          );
        }

        // Get tugas data by ID
        final tugas = tugasId != null ? controller.getTugasById(tugasId) : null;

        if (tugas == null) {
          return const Center(
            child: Text('Tugas tidak ditemukan'),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                tugas.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: tugas.status == 'Aktif' ? Colors.green[100] : Colors.blue[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tugas.status,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: tugas.status == 'Aktif' ? Colors.green[700] : Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.book, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              '${tugas.subject} • ${tugas.kelas}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              'Deadline: ${tugas.deadline} ${tugas.dueTime ?? ''}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (tugas.createdDate != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Dibuat: ${tugas.createdDate}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Statistics Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistik Pengumpulan',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                'Dikumpulkan',
                                tugas.submittedCount.toString(),
                                Colors.green,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Belum Dikumpulkan',
                                (tugas.totalStudents - tugas.submittedCount).toString(),
                                Colors.orange,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Total Siswa',
                                tugas.totalStudents.toString(),
                                const Color(0xFF6C1FB4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: tugas.submittedCount / tugas.totalStudents,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C1FB4)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${((tugas.submittedCount / tugas.totalStudents) * 100).toInt()}% siswa telah mengumpulkan',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description Card
                if (tugas.description != null && tugas.description!.isNotEmpty) ...[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deskripsi Tugas',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tugas.description!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Attachments Card
                if (tugas.attachments != null && tugas.attachments!.isNotEmpty) ...[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File Lampiran',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...tugas.attachments!.map((attachment) => 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.attach_file, size: 20, color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      attachment,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color(0xFF6C1FB4),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download, size: 20),
                                    onPressed: () {
                                      // Implement download functionality
                                      Get.snackbar(
                                        'Download',
                                        'Mengunduh file $attachment...',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (tugas.status == 'Aktif') {
                            controller.updateTugasStatus(tugasId!, 'Selesai');
                            Get.snackbar(
                              'Status Diubah',
                              'Tugas telah ditandai sebagai selesai',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            controller.updateTugasStatus(tugasId!, 'Aktif');
                            Get.snackbar(
                              'Status Diubah',
                              'Tugas telah diaktifkan kembali',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          }
                        },
                        icon: Icon(
                          tugas.status == 'Aktif' ? Icons.check_circle : Icons.replay,
                          color: Colors.white,
                        ),
                        label: Text(
                          tugas.status == 'Aktif' ? 'Tandai Selesai' : 'Aktifkan Kembali',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tugas.status == 'Aktif' ? Colors.green : Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.toNamed('/tambah-tugas', arguments: {'editMode': true, 'tugasId': tugasId});
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFF6C1FB4)),
                        label: Text(
                          'Edit Tugas',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6C1FB4),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6C1FB4)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showDeleteDialog(String? tugasId) {
    if (tugasId == null) return;
    
    Get.dialog(
      AlertDialog(
        title: Text(
          'Hapus Tugas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas ini? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteTugas(tugasId);
              Get.back(); // Close dialog
              Get.back(); // Go back to previous page
              Get.snackbar(
                'Berhasil',
                'Tugas telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
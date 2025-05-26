import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nilai_controller.dart';

class NilaiView extends GetView<NilaiController> {
  const NilaiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilai'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Obx(() {
        return Column(
          children: [
            // Header dengan filter kelas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.purple),
                      const SizedBox(width: 8),
                      const Text(
                        'Pilih Kelas:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['9B', '9C', '9D'].map((kelas) {
                              final isSelected = controller.selectedKelas.value == kelas;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(kelas),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.selectKelas(kelas);
                                  },
                                  backgroundColor: Colors.white,
                                  selectedColor: Colors.purple.shade100,
                                  checkmarkColor: Colors.purple.shade700,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Siswa dengan tugas belum selesai akan mempengaruhi nilai akhir',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // List siswa
            Expanded(
              child: controller.filteredSiswa.isEmpty
                  ? const Center(
                      child: Text(
                        'Pilih kelas untuk melihat daftar siswa',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredSiswa.length,
                      itemBuilder: (context, index) {
                        final siswa = controller.filteredSiswa[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _showDetailNilai(context, siswa),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: _getStatusColor(siswa['status']),
                                        child: Text(
                                          siswa['nama'].toString().substring(0, 1).toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              siswa['nama'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Kelas ${siswa['kelas']} • NIS: ${siswa['nis']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getNilaiColor(siswa['nilaiAkhir']),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              siswa['nilaiAkhir'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _getGrade(siswa['nilaiAkhir']),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildScoreItem('UH', siswa['nilaiUH']),
                                      const SizedBox(width: 16),
                                      _buildScoreItem('UTS', siswa['nilaiUTS']),
                                      const SizedBox(width: 16),
                                      _buildScoreItem('UAS', siswa['nilaiUAS']),
                                      const Spacer(),
                                      if (siswa['tugasBelumSelesai'] > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.warning,
                                                size: 14,
                                                color: Colors.red.shade700,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${siswa['tugasBelumSelesai']} tugas',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildScoreItem(String label, int nilai) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          nilai.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'lengkap':
        return Colors.green;
      case 'kurang':
        return Colors.orange;
      case 'tidak_lengkap':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getNilaiColor(int nilai) {
    if (nilai >= 85) return Colors.green;
    if (nilai >= 75) return Colors.purple;
    if (nilai >= 65) return Colors.orange;
    return Colors.red;
  }

  String _getGrade(int nilai) {
    if (nilai >= 90) return 'A';
    if (nilai >= 80) return 'B';
    if (nilai >= 70) return 'C';
    if (nilai >= 60) return 'D';
    return 'E';
  }

  void _showDetailNilai(BuildContext context, Map<String, dynamic> siswa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getStatusColor(siswa['status']),
                    child: Text(
                      siswa['nama'].toString().substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          siswa['nama'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Kelas ${siswa['kelas']} • NIS: ${siswa['nis']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showEditNilai(context, siswa),
                    icon: const Icon(Icons.edit),
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailCard('Nilai Ulangan Harian', siswa['nilaiUH'], Icons.quiz),
                    _buildDetailCard('Nilai UTS', siswa['nilaiUTS'], Icons.school),
                    _buildDetailCard('Nilai UAS', siswa['nilaiUAS'], Icons.assignment),
                    _buildDetailCard('Nilai Akhir', siswa['nilaiAkhir'], Icons.star, isMain: true),
                    if (siswa['tugasBelumSelesai'] > 0)
                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tugas Belum Selesai',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                    Text(
                                      '${siswa['tugasBelumSelesai']} tugas belum dikumpulkan',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, int nilai, IconData icon, {bool isMain = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isMain ? Colors.purple.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: isMain ? Colors.purple.shade700 : Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isMain ? FontWeight.bold : FontWeight.w500,
                  color: isMain ? Colors.purple.shade700 : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getNilaiColor(nilai),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                nilai.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMain ? 18 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNilai(BuildContext context, Map<String, dynamic> siswa) {
    final uhController = TextEditingController(text: siswa['nilaiUH'].toString());
    final utsController = TextEditingController(text: siswa['nilaiUTS'].toString());
    final uasController = TextEditingController(text: siswa['nilaiUAS'].toString());
    final tugasController = TextEditingController(text: siswa['tugasBelumSelesai'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Nilai - ${siswa['nama']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uhController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nilai Ulangan Harian',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: utsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nilai UTS',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: uasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nilai UAS',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tugasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tugas Belum Selesai',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateNilai(
                siswa['nis'],
                int.parse(uhController.text),
                int.parse(utsController.text),
                int.parse(uasController.text),
                int.parse(tugasController.text),
              );
              Navigator.pop(context);
              Navigator.pop(context); // Close detail sheet too
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
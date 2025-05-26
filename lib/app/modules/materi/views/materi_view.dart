import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/materi_controller.dart';

class MateriView extends GetView<MateriController> {
  const MateriView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C1FB4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Materi Pembelajaran',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () => Get.toNamed('/tambah-detail'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar - fixed at top
          _buildSearchBar(),
          
          // Materi list - expands to fill remaining space
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6C1FB4),
                  ),
                );
              }
              
              if (controller.filteredMateriList.isEmpty) {
                return _buildEmptyState();
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  controller.refreshData();
                },
                child: ListView.builder(
                  // Remove top padding to make it closer to search bar
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: controller.filteredMateriList.length,
                  itemBuilder: (context, index) {
                    final materi = controller.filteredMateriList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MateriCard(
                        materi: materi,
                        onTap: () {
                          controller.incrementViews(materi.id);
                          // Navigate to detail-materi route with materi ID as parameter
                          Get.toNamed('/detail-materi', arguments: materi.id);
                        },
                        onEdit: () => controller.editMateri(materi.id),
                        onDelete: () => controller.deleteMateri(materi.id),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Add small bottom padding
      child: TextField(
        onChanged: controller.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari materi...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }



  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.value.isNotEmpty || controller.selectedSubject.value != 'Semua'
                ? 'Materi tidak ditemukan'
                : 'Belum ada materi',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchQuery.value.isNotEmpty || controller.selectedSubject.value != 'Semua'
                ? 'Coba ubah kata kunci atau filter pencarian'
                : 'Tambahkan materi baru dengan menekan tombol +',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SubjectChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SubjectChip({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C1FB4) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C1FB4).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class MateriCard extends StatelessWidget {
  final MateriModel materi;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MateriCard({
    Key? key,
    required this.materi,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData typeIcon;
    Color typeColor;
    
    switch (materi.type.toLowerCase()) {
      case 'pdf':
        typeIcon = Icons.picture_as_pdf;
        typeColor = Colors.red;
        break;
      case 'video':
        typeIcon = Icons.play_circle_filled;
        typeColor = Colors.blue;
        break;
      case 'powerpoint':
        typeIcon = Icons.slideshow;
        typeColor = Colors.orange;
        break;
      default:
        typeIcon = Icons.description;
        typeColor = Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    typeIcon,
                    size: 24,
                    color: typeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        materi.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${materi.subject} • ${materi.kelas}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: const [
                          Icon(Icons.edit, size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              materi.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      materi.uploadDate,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.folder, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      materi.fileSize,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.visibility, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${materi.views} views',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6C1FB4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
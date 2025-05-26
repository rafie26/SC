import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tambah_tugas_controller.dart';

class TambahTugasView extends GetView<TambahTugasController> {
  const TambahTugasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Tambah Tugas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Tugas
                      _buildSectionTitle('Judul Tugas'),
                      const SizedBox(height: 8),
                      _buildTextFormField(
                        controller: controller.judulController,
                        hintText: 'Masukkan judul tugas',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tugas tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Deskripsi
                      _buildSectionTitle('Deskripsi Tugas'),
                      const SizedBox(height: 8),
                      _buildTextFormField(
                        controller: controller.deskripsiController,
                        hintText: 'Masukkan deskripsi tugas',
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tugas tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // File Lampiran
                      _buildSectionTitle('File Lampiran'),
                      const SizedBox(height: 8),
                      _buildFileAttachmentSection(),
                      
                      const SizedBox(height: 20),
                      
                      // Deadline
                      _buildSectionTitle('Batas Waktu'),
                      const SizedBox(height: 8),
                      Obx(() => _buildDateField(
                        selectedDate: controller.selectedDeadline.value,
                        onTap: () => controller.pickDeadlineDate(context),
                      )),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value 
                      ? null 
                      : () => controller.submitTugas(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C1FB4),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Buat Tugas',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[500],
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C1FB4), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate == null
                  ? 'Pilih tanggal deadline'
                  : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: selectedDate == null ? Colors.grey[500] : Colors.black87,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File Upload Button
        GestureDetector(
          onTap: () => controller.pickFile(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 32,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih File untuk Dilampirkan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Format: PDF, DOC, DOCX, JPG, PNG (Max 10MB)',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // File List
        Obx(() => controller.attachedFiles.isNotEmpty 
            ? Column(
                children: controller.attachedFiles.map((file) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getFileIcon(file['type']),
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                file['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                file['size'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller.removeFile(file['id']),
                          icon: Icon(
                            Icons.close,
                            color: Colors.red[600],
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            : const SizedBox.shrink()
        ),
      ],
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }
}
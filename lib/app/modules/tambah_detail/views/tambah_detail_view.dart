import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tambah_detail_controller.dart';

class TambahDetailView extends GetView<TambahDetailController> {
  const TambahDetailView({Key? key}) : super(key: key);

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
          'Tambah Materi',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.clearForm,
            child: Text(
              'Reset',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    _buildSectionTitle('Judul Materi'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: controller.titleController,
                      hintText: 'Masukkan judul materi...',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul materi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Subject dropdown
                    _buildSectionTitle('Mata Pelajaran'),
                    const SizedBox(height: 8),
                    _buildSubjectDropdown(),
                    
                    const SizedBox(height: 24),
                    
                    // Class selection dropdown (Multi-select)
                    _buildSectionTitle('Kelas'),
                    const SizedBox(height: 8),
                    _buildClassMultiSelectDropdown(),
                    
                    const SizedBox(height: 24),
                    
                    // Description field
                    _buildSectionTitle('Deskripsi'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: controller.descriptionController,
                      hintText: 'Masukkan deskripsi materi...',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // File upload section
                    _buildSectionTitle('File Materi'),
                    const SizedBox(height: 8),
                    _buildFileUploadSection(),
                    
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
            
            // Bottom action button
            _buildBottomActionButton(),
          ],
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
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[500],
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C1FB4), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSubjectDropdown() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: controller.selectedSubject.value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        dropdownColor: Colors.white,
        items: controller.subjectList.map((String subject) {
          return DropdownMenuItem<String>(
            value: subject,
            child: Text(
              subject,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: subject == 'Pilih Mata Pelajaran' ? Colors.grey[500] : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.setSelectedSubject(newValue);
          }
        },
      ),
    ));
  }

  // NEW: Multi-select dropdown for classes
  Widget _buildClassMultiSelectDropdown() {
    return Obx(() => GestureDetector(
      onTap: _showClassSelectionBottomSheet,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 56), // Fixed: Using constraints instead of min-height
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.selectedClasses.isEmpty 
                        ? 'Pilih kelas' 
                        : '${controller.selectedClasses.length} kelas dipilih',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: controller.selectedClasses.isEmpty 
                          ? Colors.grey[500] 
                          : Colors.black,
                    ),
                  ),
                  if (controller.selectedClasses.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSelectedClassesTags(),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    ));
  }

  // Show bottom sheet with class selection
  void _showClassSelectionBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih Kelas',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearSelectedClasses();
                      Get.back();
                    },
                    child: Text(
                      'Reset',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Class options with scrollable container
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: _buildClassSelectionOptions(),
                ),
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6C1FB4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6C1FB4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C1FB4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'Selesai',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Build class selection options grouped by grade
  List<Widget> _buildClassSelectionOptions() {
    final Map<String, List<String>> groupedClasses = controller.groupedClasses;
    
    List<Widget> widgets = [];
    
    groupedClasses.forEach((grade, classes) {
      // Grade header with select all option
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                grade,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Obx(() {
                bool allSelected = controller.isGradeFullySelected(classes);
                return GestureDetector(
                  onTap: () {
                    controller.toggleGradeSelection(classes);
                  },
                  child: Text(
                    allSelected ? 'Batalkan Semua' : 'Pilih Semua',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6C1FB4),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
      
      // Class checkboxes
      for (String className in classes) {
        widgets.add(
          Obx(() => CheckboxListTile(
            title: Text(
              className,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: controller.selectedClasses.contains(className),
            onChanged: (bool? value) {
              controller.toggleClassSelection(className);
            },
            activeColor: const Color(0xFF6C1FB4),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          )),
        );
      }
    });
    
    return widgets;
  }

  // Display selected classes as tags
  Widget _buildSelectedClassesTags() {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: controller.selectedClasses.take(6).map((kelas) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF6C1FB4).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF6C1FB4).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          kelas,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6C1FB4),
          ),
        ),
      )).toList()
        ..addAll(controller.selectedClasses.length > 6 
            ? [Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${controller.selectedClasses.length - 6}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              )]
            : []),
    );
  }

  Widget _buildFileUploadSection() {
    return Obx(() {
      if (controller.selectedFile.value == null) {
        return _buildFilePickerButton();
      } else {
        return _buildSelectedFileCard();
      }
    });
  }

  Widget _buildFilePickerButton() {
    return GestureDetector(
      onTap: controller.pickFile,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 40,
              color: Colors.grey[500],
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih File Materi',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PDF, Video, PowerPoint, atau Dokumen',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFileCard() {
    final file = controller.selectedFile.value!;
    final fileType = controller.getFileType(file.name);
    
    IconData typeIcon;
    Color typeColor;
    
    switch (fileType.toLowerCase()) {
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
      case 'audio':
        typeIcon = Icons.audiotrack;
        typeColor = Colors.purple;
        break;
      case 'image':
        typeIcon = Icons.image;
        typeColor = Colors.green;
        break;
      default:
        typeIcon = Icons.description;
        typeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6C1FB4), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
                  file.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${fileType} • ${controller.formatFileSize(file.size)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: controller.removeFile,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.saveMateri,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C1FB4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
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
                  'Simpan Materi',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      )),
    );
  }
}
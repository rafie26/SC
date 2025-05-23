import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tambah_kalender_controller.dart';

class TambahKalenderView extends GetView<TambahKalenderController> {
  const TambahKalenderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C1FB4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => controller.cancelAndGoBack(),
        ),
        title: Text(
          'Tambah Acara',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.saveEvent(),
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            _buildSectionTitle('Judul Acara'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.titleController,
              hint: 'Masukkan judul acara',
              icon: Icons.event_note,
            ),
            const SizedBox(height: 24),
            
            // Location field
            _buildSectionTitle('Lokasi'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.locationController,
              hint: 'Masukkan lokasi acara',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),
            
            // Date and Time section
            _buildSectionTitle('Tanggal & Waktu'),
            const SizedBox(height: 8),
            
            // Date picker
            Obx(() => _buildSelectableField(
              icon: Icons.calendar_today,
              title: 'Tanggal',
              value: controller.getFormattedDate(),
              onTap: () => controller.pickDate(),
            )),
            const SizedBox(height: 12),
            
            // All day toggle
            Obx(() => Row(
              children: [
                Switch(
                  value: controller.isAllDay.value,
                  onChanged: (value) => controller.toggleAllDay(value),
                  activeColor: const Color(0xFF6C1FB4),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sepanjang hari',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            )),
            
            // Time picker (hidden if all day is selected)
            Obx(() => !controller.isAllDay.value
                ? Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildSelectableField(
                        icon: Icons.access_time,
                        title: 'Waktu',
                        value: controller.getFormattedTime(),
                        onTap: () => controller.pickTime(),
                      ),
                    ],
                  )
                : const SizedBox()),
            
            const SizedBox(height: 24),
            
            // Color selection
            _buildSectionTitle('Warna Acara'),
            const SizedBox(height: 12),
            Obx(() => _buildColorPicker()),
            const SizedBox(height: 24),
            
            // Description field
            _buildSectionTitle('Deskripsi (Opsional)'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.descriptionController,
              hint: 'Tambahkan deskripsi acara',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.saveEvent(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C1FB4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Simpan Acara',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
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
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSelectableField({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildColorPicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih warna untuk acara ini',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.availableColors.map((color) {
              final isSelected = controller.selectedColor.value == color;
              return GestureDetector(
                onTap: () => controller.selectColor(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: isSelected ? 8 : 4,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
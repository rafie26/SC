import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tambah_kelas_controller.dart';

class TambahKelasView extends GetView<TambahKelasController> {
  const TambahKelasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan judul dan tombol back (X)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        weight: 700,
                      ),
                    ),
                  ),
                  Text(
                    'Buat Kelas Baru',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Nama Kelas
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Nama kelas',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.namaKelasController,
                          onChanged: (value) {
                            // Trigger reactive update untuk button
                            controller.update();
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukan nama kelas',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Form Tingkat Kelas - Dropdown
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Tingkat Kelas',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Obx(() => DropdownButtonFormField<String>(
                          value: controller.selectedTingkatKelas.value.isEmpty 
                              ? null 
                              : controller.selectedTingkatKelas.value,
                          decoration: InputDecoration(
                            hintText: 'Pilih tingkat kelas',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          dropdownColor: Colors.white,
                          menuMaxHeight: 200,
                          items: _buildTingkatKelasDropdownItems(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setTingkatKelas(newValue);
                            }
                          },
                        )),
                      ),

                      const SizedBox(height: 20),

                      // Form Mata Pelajaran - Dropdown
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Mata Pelajaran',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Obx(() => DropdownButtonFormField<String>(
                          value: controller.selectedMataPelajaran.value.isEmpty 
                              ? null 
                              : controller.selectedMataPelajaran.value,
                          decoration: InputDecoration(
                            hintText: 'Pilih mata pelajaran',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          dropdownColor: Colors.white,
                          menuMaxHeight: 200,
                          items: _buildMataPelajaranDropdownItems(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setMataPelajaran(newValue);
                            }
                          },
                        )),
                      ),

                      const SizedBox(height: 30),

                      // Button Buat Kelas (Responsif)
                      Container(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value 
                              ? null 
                              : (controller.isFormValid 
                                  ? () => controller.buatKelasBaru()
                                  : null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isFormValid && !controller.isLoading.value
                                ? const Color(0xFF87CEEB) // Light blue color when active
                                : Colors.grey.shade300, // Grey when inactive
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Colors.black54),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Membuat kelas...',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Buat kelas',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: controller.isFormValid 
                                        ? Colors.black 
                                        : Colors.black54,
                                  ),
                                ),
                        )),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildTingkatKelasDropdownItems() {
    List<String> kelasOptions = [
      '7A', '7B', '7C', '7D',
      '8A', '8B', '8C', '8D',
      '9A', '9B', '9C', '9D',
    ];

    return kelasOptions.map((String kelas) {
      return DropdownMenuItem<String>(
        value: kelas,
        child: Text(
          kelas,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildMataPelajaranDropdownItems() {
    List<String> mataPelajaranOptions = [
      'Matematika',
      'Bahasa Indonesia',
      'Bahasa Inggris',
      'IPA',
      'IPS',
      'PPKN',
      'Seni Budaya',
      'Prakarya',
      'Pendidikan Jasmani',
      'Bahasa Daerah',
      'Agama Islam',
    ];

    return mataPelajaranOptions.map((String mataPelajaran) {
      return DropdownMenuItem<String>(
        value: mataPelajaran,
        child: Text(
          mataPelajaran,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }
}
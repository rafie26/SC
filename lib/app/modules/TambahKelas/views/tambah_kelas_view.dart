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
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Nama Kelas
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
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

                      const SizedBox(height: 30),

                      // Form Tingkat Kelas - Dropdown
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
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
                          menuMaxHeight: 200, // Batasi tinggi dropdown menu
                          items: _buildDropdownItems(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setTingkatKelas(newValue);
                            }
                          },
                        )),
                      ),

                      const Spacer(),

                      // Button Buat Kelas
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.buatKelasBaru();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87CEEB), // Light blue color
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Buat kelas',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
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
}
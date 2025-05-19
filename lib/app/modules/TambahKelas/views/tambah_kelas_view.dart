
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

                      // Form Tingkat Kelas
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
                        child: Obx(() => ExpansionTile(
                          title: Text(
                            controller.selectedTingkatKelas.value.isNotEmpty
                                ? controller.selectedTingkatKelas.value
                                : 'Pilih Tingkat Kelas',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: controller.selectedTingkatKelas.value.isNotEmpty
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  RadioListTile<String>(
                                    title: Text(
                                      'Kelas 7',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    value: 'Kelas 7',
                                    groupValue: controller.selectedTingkatKelas.value,
                                    onChanged: (String? value) {
                                      controller.setTingkatKelas(value ?? '');
                                    },
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  RadioListTile<String>(
                                    title: Text(
                                      'Kelas 8',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    value: 'Kelas 8',
                                    groupValue: controller.selectedTingkatKelas.value,
                                    onChanged: (String? value) {
                                      controller.setTingkatKelas(value ?? '');
                                    },
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  RadioListTile<String>(
                                    title: Text(
                                      'Kelas 9',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    value: 'Kelas 9',
                                    groupValue: controller.selectedTingkatKelas.value,
                                    onChanged: (String? value) {
                                      controller.setTingkatKelas(value ?? '');
                                    },
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
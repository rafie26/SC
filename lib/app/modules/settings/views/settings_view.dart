import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

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
          'Pengaturan',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Section
              _buildSectionTitle('Tampilan'),
              const SizedBox(height: 15),
              
              Obx(() => SettingsToggleCard(
                icon: Icons.dark_mode_outlined,
                title: 'Mode Gelap',
                subtitle: 'Aktifkan tema gelap untuk mata',
                value: controller.isDarkMode.value,
                onChanged: controller.toggleDarkMode,
              )),
              
              SettingsCard(
                icon: Icons.text_fields_outlined,
                title: 'Ukuran Font',
                subtitle: 'Atur ukuran teks aplikasi',
                value: controller.selectedFontSize.value,
                onTap: () => _showFontSizeDialog(context),
              ),
              
              SettingsCard(
                icon: Icons.language_outlined,
                title: 'Bahasa',
                subtitle: 'Pilih bahasa aplikasi',
                value: controller.selectedLanguage.value,
                onTap: () => _showLanguageDialog(context),
              ),
              
              const SizedBox(height: 30),
              
              // Notifications Section
              _buildSectionTitle('Notifikasi'),
              const SizedBox(height: 15),
              
              Obx(() => SettingsToggleCard(
                icon: Icons.notifications_outlined,
                title: 'Notifikasi Push',
                subtitle: 'Terima notifikasi untuk update penting',
                value: controller.isNotificationEnabled.value,
                onChanged: controller.toggleNotification,
              )),
              
              const SizedBox(height: 30),
              
              // Data & Storage Section
              _buildSectionTitle('Data & Penyimpanan'),
              const SizedBox(height: 15),
              
              Obx(() => SettingsToggleCard(
                icon: Icons.sync_outlined,
                title: 'Sinkronisasi Otomatis',
                subtitle: 'Sinkronkan data secara otomatis',
                value: controller.isAutoSyncEnabled.value,
                onChanged: controller.toggleAutoSync,
              )),
              
              SettingsCard(
                icon: Icons.storage_outlined,
                title: 'Kelola Penyimpanan',
                subtitle: 'Lihat dan kelola data tersimpan',
                onTap: () => _showStorageDialog(context),
              ),
              
              SettingsCard(
                icon: Icons.backup_outlined,
                title: 'Backup Data',
                subtitle: 'Cadangkan data ke cloud',
                onTap: () => _showBackupDialog(context),
              ),
              
              const SizedBox(height: 30),
              
              // Security Section
              _buildSectionTitle('Keamanan'),
              const SizedBox(height: 15),
              
              SettingsCard(
                icon: Icons.lock_outline,
                title: 'Ubah Password',
                subtitle: 'Ganti password akun Anda',
                onTap: () => _showChangePasswordDialog(context),
              ),
              
              SettingsCard(
                icon: Icons.security_outlined,
                title: 'Keamanan Akun',
                subtitle: 'Atur keamanan tambahan',
                onTap: () => _showSecurityDialog(context),
              ),
              
              const SizedBox(height: 30),
              
              // About Section
              _buildSectionTitle('Tentang'),
              const SizedBox(height: 15),
              
              SettingsCard(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                subtitle: 'Versi 1.0.0',
                onTap: () => _showAboutDialog(context),
              ),
              
              SettingsCard(
                icon: Icons.help_outline,
                title: 'Bantuan & Dukungan',
                subtitle: 'Dapatkan bantuan penggunaan aplikasi',
                onTap: () => _showHelpDialog(context),
              ),
              
              SettingsCard(
                icon: Icons.privacy_tip_outlined,
                title: 'Kebijakan Privasi',
                subtitle: 'Baca kebijakan privasi kami',
                onTap: () => _showPrivacyDialog(context),
              ),
              
              const SizedBox(height: 40),
              
              // Reset Settings Button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _showResetDialog(context),
                  icon: const Icon(Icons.restore, color: Colors.red),
                  label: Text(
                    'Reset Pengaturan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
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
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    final options = ['Kecil', 'Sedang', 'Besar'];
    Get.dialog(
      AlertDialog(
        title: Text(
          'Pilih Ukuran Font',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return Obx(() => RadioListTile<String>(
              title: Text(option, style: GoogleFonts.poppins()),
              value: option,
              groupValue: controller.selectedFontSize.value,
              onChanged: (value) {
                controller.changeFontSize(value!);
                Get.back();
              },
              activeColor: const Color(0xFF6C1FB4),
            ));
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final options = ['Bahasa Indonesia', 'English'];
    Get.dialog(
      AlertDialog(
        title: Text(
          'Pilih Bahasa',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return Obx(() => RadioListTile<String>(
              title: Text(option, style: GoogleFonts.poppins()),
              value: option,
              groupValue: controller.selectedLanguage.value,
              onChanged: (value) {
                controller.changeLanguage(value!);
                Get.back();
              },
              activeColor: const Color(0xFF6C1FB4),
            ));
          }).toList(),
        ),
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Kelola Penyimpanan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data Tersimpan:', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text('• Cache: 2.5 MB', style: GoogleFonts.poppins()),
            Text('• Data Offline: 15.2 MB', style: GoogleFonts.poppins()),
            Text('• Total: 17.7 MB', style: GoogleFonts.poppins()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Berhasil', 'Cache berhasil dihapus', backgroundColor: Colors.green, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C1FB4)),
            child: Text('Hapus Cache', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Backup Data', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Apakah Anda ingin mencadangkan data ke cloud?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Backup', 'Data sedang dicadangkan...', backgroundColor: Colors.blue, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C1FB4)),
            child: Text('Backup', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Ubah Password', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Berhasil', 'Password berhasil diubah', backgroundColor: Colors.green, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C1FB4)),
            child: Text('Ubah', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Keamanan Akun', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengaturan Keamanan:', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text('• Autentikasi Dua Faktor: Tidak Aktif', style: GoogleFonts.poppins()),
            Text('• Login Terakhir: Hari ini, 10:30', style: GoogleFonts.poppins()),
            Text('• Perangkat Terdaftar: 2 perangkat', style: GoogleFonts.poppins()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Keamanan', 'Pengaturan keamanan diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C1FB4)),
            child: Text('Kelola', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Tentang Aplikasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SevenConnect Teacher App', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Versi: 1.0.0', style: GoogleFonts.poppins()),
            Text('Build: 100', style: GoogleFonts.poppins()),
            const SizedBox(height: 15),
            Text('Aplikasi manajemen kelas untuk guru yang memudahkan pengelolaan siswa, tugas, dan materi pembelajaran.', 
                 style: GoogleFonts.poppins(fontSize: 12)),
            const SizedBox(height: 15),
            Text('© 2024 SevenConnect', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Bantuan & Dukungan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Butuh bantuan? Hubungi kami:', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.email, color: Color(0xFF6C1FB4), size: 20),
                const SizedBox(width: 10),
                Text('SevenConnect@gmail.com', style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: Color(0xFF6C1FB4), size: 20),
                const SizedBox(width: 10),
                Text('0895-6119-99186', style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFF6C1FB4), size: 20),
                const SizedBox(width: 10),
                Text('Senin - Jumat: 08:00 - 17:00', style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Bantuan', 'Menghubungi tim dukungan...', backgroundColor: Colors.blue, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C1FB4)),
            child: Text('Hubungi', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Kebijakan Privasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: SizedBox(
          height: 300,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              '''Kebijakan Privasi SevenConnect Teacher App

1. Informasi yang Kami Kumpulkan
Kami mengumpulkan informasi yang Anda berikan secara langsung, seperti nama, email, dan data profil.

2. Penggunaan Informasi
Informasi digunakan untuk menyediakan layanan, meningkatkan pengalaman pengguna, dan komunikasi.

3. Perlindungan Data
Kami menerapkan langkah-langkah keamanan untuk melindungi informasi pribadi Anda.

4. Berbagi Informasi
Kami tidak menjual atau membagikan informasi pribadi kepada pihak ketiga tanpa persetujuan.

5. Hak Pengguna
Anda memiliki hak untuk mengakses, memperbarui, atau menghapus informasi pribadi.

6. Perubahan Kebijakan
Kebijakan ini dapat diperbarui sewaktu-waktu. Perubahan akan diberitahukan melalui aplikasi.

Terakhir diperbarui: 1 Januari 2024''',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Reset Pengaturan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'Apakah Anda yakin ingin mereset semua pengaturan ke default? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetSettings();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Reset', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Settings Card Widget
class SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? value;
  final VoidCallback onTap;

  const SettingsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C1FB4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF6C1FB4),
                  size: 22,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        value!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6C1FB4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Settings Toggle Card Widget
class SettingsToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF6C1FB4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF6C1FB4),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF6C1FB4),
              activeTrackColor: const Color(0xFF6C1FB4).withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
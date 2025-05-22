import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleDiameter = screenWidth * 1.5;

    return Scaffold(
      backgroundColor: const Color(0xFF590D82),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: SafeArea(
              child: IconButton(
                onPressed: () => controller.backToLogin(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Lingkaran gradasi bagian atas
          Positioned(
            top: -circleDiameter / 1.7,
            left: -(circleDiameter - screenWidth) / 2,
            child: Container(
              width: circleDiameter,
              height: circleDiameter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF9816DF),
                    Color(0xFF590D82),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: circleDiameter / 1.8),
                  child: Text(
                    'Lupa Password',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Form konten
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: circleDiameter / 3),

                    Obx(() => !controller.isEmailSent.value
                        ? _buildEmailForm()
                        : _buildSuccessMessage()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        // Deskripsi
        Text(
          'Masukkan email Anda untuk menerima link reset password',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // Email Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF9816DF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              border: InputBorder.none,
              hintText: 'Email',
              hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8)),
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Tombol Kirim
        Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value ? null : () => controller.sendResetEmail(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF590D82),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF590D82)),
                  ),
                )
              : Text(
                  'Kirim Link Reset',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        )),

        const SizedBox(height: 30),

        // Link kembali ke login
        TextButton(
          onPressed: () => controller.backToLogin(),
          child: Text(
            'Kembali ke Login',
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        // Icon success
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 50,
          ),
        ),

        const SizedBox(height: 30),

        // Pesan berhasil
        Text(
          'Email Terkirim!',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          'Link reset password telah dikirim ke ${controller.emailController.text}. Silakan cek email Anda.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // Tombol kirim ulang
        OutlinedButton(
          onPressed: () => controller.resendEmail(),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Kirim Ulang',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Tombol kembali ke login
        TextButton(
          onPressed: () => controller.backToLogin(),
          child: Text(
            'Kembali ke Login',
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
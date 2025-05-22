import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleDiameter = screenWidth * 1.5; // Lingkaran dikecilkan

    return Scaffold(
      backgroundColor: const Color(0xFF590D82),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Lingkaran gradasi bagian atas
          Positioned(
            top: -circleDiameter / 1.7, // Geser ke atas agar terlihat setengah lingkaran
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
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Form isi login
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: circleDiameter / 2.7), // Jarak dari Login
                    
                    // Username
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9816DF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: controller.usernameController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8)),
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9816DF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: controller.passwordController,
                        obscureText: true,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8)),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Link Lupa Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed('/forgot-password');
                        },
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Tombol Login
                    Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.login(),
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
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    )),

                    const SizedBox(height: 30),

                    // Link Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have account?',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
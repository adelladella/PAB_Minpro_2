import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = AuthService();

  bool isLoading = false;

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) {
      showMessage("Nama wajib diisi");
      return;
    }

    if (email.isEmpty) {
      showMessage("Email wajib diisi");
      return;
    }

    if (!email.contains("@")) {
      showMessage("Format email tidak valid");
      return;
    }

    if (password.isEmpty) {
      showMessage("Password wajib diisi");
      return;
    }

    if (password.length < 6) {
      showMessage("Password minimal 6 karakter");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await authService.register(email, password);

      if (!mounted) return;

      showMessage("Registrasi berhasil");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      showMessage("Register gagal");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/onboarding.png",
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                    child: Container(
                      width: 380,
                      padding: const EdgeInsets.all(30),

                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Create Account",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5C4033),
                            ),
                          ),

                          const SizedBox(height: 25),

                          buildField(
                            controller: nameController,
                            label: "Name",
                            icon: Icons.person,
                          ),

                          const SizedBox(height: 15),

                          buildField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email,
                          ),

                          const SizedBox(height: 15),

                          buildField(
                            controller: passwordController,
                            label: "Password",
                            icon: Icons.lock,
                            obscure: true,
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            height: 50,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B6B4F),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),

                              onPressed: isLoading ? null : register,

                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    )
                                  : Text(
                                      "Register",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },

                            child: Text(
                              "Already have an account? Login",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF5C4033),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: Color(0xFF5C4033)),

        filled: true,
        fillColor: const Color(0xFFF7F3EE),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

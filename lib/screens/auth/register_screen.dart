import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/model/auth/login_request_model.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';

import '../../model/auth/register_response_model.dart';
import '../../provider/user_provider.dart';
import '../../styles/color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isApiCallProcess = false;
  bool isLoading = false;

  // Define the green colors
  final Color primaryGreen = const Color(0xFF7FBC8C);
  final Color lightGreen = const Color(0x8C7FBC8C); // rgba(127, 188, 140, 0.55)

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (isApiCallProcess)
            const Center(child: CircularProgressIndicator()),

          // Main scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.people_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Already have account row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun?',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Full Name field label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nama Lengkap",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Full Name field
                    TextFormField(
                      controller: _fullNameController,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan nama lengkap",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[600],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan nama lengkap';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email field label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Alamat Email",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan email anda",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey[600],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Phone number field label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nomor HP",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Phone number field
                    TextFormField(
                      controller: _noHpController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan nomor HP anda",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: Colors.grey[600],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan no hp';
                        } else if (!RegExp(
                          r'^08[0-9]{9,11}$',
                        ).hasMatch(value)) {
                          return 'Format nomor telepon tidak valid. Harus diawali dengan 08 dan 11-13 digit angka.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kata Sandi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan kata sandi",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password field label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Konfirmasi Kata Sandi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Konfirmasi kata sandi anda",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan konfirmasi password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Register button
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: submitRegister,
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryGreen,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: primaryGreen),
                                ),
                              ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
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
    );
  }

  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> submitRegister() async {
    if (!validateAndSave()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Harap isi semua data yang diperlukan."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    showLoadingAnimated(context);

    String fullName = _fullNameController.text;
    String noTelp = _noHpController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      if (mounted) {
        closeLoadingDialog(context);
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Kata sandi tidak sesuai"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      RegisterResponseModel user = await APIService().register(
        email,
        password,
        fullName,
        noTelp,
        await NotificationService.instance.getStoredFcmToken() ?? "empty_token",
      );

      if (user.success == 200) {
        if (mounted) {
          closeLoadingDialog(context);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        }
      } else {
        throw Exception(
          'Gagal melakukan registrasi, server memberikan respon: ${user.success}',
        );
      }
    } catch (e) {
      if (mounted) {
        closeLoadingDialog(context);
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Gagal melakukan registrasi: $e"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}

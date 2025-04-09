import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/beranda/admin_dashboard.dart';
import 'package:pa2_kelompok07/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pa2_kelompok07/navigationBar/bottom_bar.dart';

import 'package:pa2_kelompok07/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initRedirect();
  }

  Future<void> _initRedirect() async {
    await Future.delayed(const Duration(seconds: 2));

    final sp = await SharedPreferences.getInstance();
    final onBoardingViewed = sp.getBool('onBoard') ?? false;

    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isAuthenticated = userProvider.isLoggedIn;

    if (!onBoardingViewed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    if (!isAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    } else {
      final userRole = userProvider.user?.role;
      if (userRole == "admin") {
        Navigator.of(context).pushReplacementNamed('/admin-layout');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNavigationWidget()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/splash_image.png'),
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

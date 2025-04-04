import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/navigationBar/bottom_bar.dart';
import 'package:pa2_kelompok07/provider/appointment_provider.dart';
import 'package:pa2_kelompok07/provider/location_provider.dart';
import 'package:pa2_kelompok07/provider/report_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/provider/internet_provider.dart';
import 'package:pa2_kelompok07/provider/sign_in_provider.dart';
import 'package:pa2_kelompok07/screens/appointment/appointment_procedure.dart';
import 'package:pa2_kelompok07/screens/appointment/appointment_screen.dart';
import 'package:pa2_kelompok07/screens/appointment/edit_appointment_screen.dart';
import 'package:pa2_kelompok07/screens/appointment/form_appointment_screen.dart';
import 'package:pa2_kelompok07/screens/auth/forgot_password.dart';
import 'package:pa2_kelompok07/screens/auth/login_screen.dart';
import 'package:pa2_kelompok07/screens/auth/register_screen.dart';
import 'package:pa2_kelompok07/screens/beranda_screen.dart';
import 'package:pa2_kelompok07/screens/dpmdppa/form_report.dart';
import 'package:pa2_kelompok07/screens/dpmdppa/report_cancel_screen.dart';
import 'package:pa2_kelompok07/screens/dpmdppa/report_screen.dart';
import 'package:pa2_kelompok07/screens/laporan/laporan_anda_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pa2_kelompok07/screens/notifikasi_screen.dart';
import 'package:pa2_kelompok07/screens/profile/edit_password_screen.dart';
import 'package:pa2_kelompok07/screens/profile/edit_profile_screen.dart';
import 'package:pa2_kelompok07/screens/profile/profile_screen.dart';
import 'package:pa2_kelompok07/screens/splash_screen.dart';
import 'package:pa2_kelompok07/screens/admin/pages/beranda/admin_dashboard.dart';
import 'package:intl/date_symbol_data_local.dart';
// Tambahkan import untuk AdminProvider
import 'package:pa2_kelompok07/provider/admin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Mengambil token user yang sudah ada
  final userProvider = UserProvider();
  await userProvider.loadUserToken();

  // Tambahkan proses untuk mengambil token admin
  final adminProvider = AdminProvider();
  await adminProvider.loadAdminToken();

  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserToken()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        // Provider baru untuk admin
        ChangeNotifierProvider(
          create: (_) => AdminProvider()..loadAdminToken(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const SplashScreen(),
      routes: {
        '/homepage':
            (context) => const BottomNavigationWidget(
              initialIndex: 0,
              pages: [HomePage(), ReportScreen(), ProfilePage()],
            ),
        '/login': (context) => const LoginPage(),
        '/laporan': (context) => const LaporanScreen(),
        '/register': (context) => const RegisterPage(),
        '/lupa-sandi': (context) => const ForgotPassword(),
        '/profile': (context) => const ProfilePage(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/edit-password': (context) => const EditPasswordScreen(),
        '/add-laporan': (context) => const FormReportDPMADPPA(),
        '/janji-temu': (context) => const AppointmentPage(),
        '/add-janji-temu': (context) => const FormAppointmentScreen(),
        '/edit-janji-temu': (context) => const EditAppointmentScreen(),
        '/prosedur-janji-temu': (context) => const AppointmentProcedure(),
        '/notifikasi': (context) => const NotificationScreen(),
        '/admin-dashboard': (context) => const Beranda(),
      },
    );
  }
}

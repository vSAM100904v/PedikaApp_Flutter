import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/logout_dialog.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/dashboard/dashboard_admin_page.dart';
import 'package:pa2_kelompok07/screens/admin/pages/dashboard_page/reports_page.dart.dart';
import 'package:provider/provider.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  final String title = "Admin Pedika App";

  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout>
    with TickerProviderStateMixin {
  // TabController? _tabController;
  MotionTabBarController? _motionTabBarController;
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _motionTabBarController = MotionTabBarController(
      initialIndex: 2,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController?.dispose();
    super.dispose();
  }

  void _handleLogout(BuildContext context, String userName) {
    ;

    showDialog(
      context: context,
      builder:
          (dialogContext) => LogoutConfirmationDialog(
            userName: userName,
            onLogoutConfirmed: () async {
              try {
                await _userProvider.logout();
                // Periksa apakah widget masih mounted sebelum navigasi
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                } else {
                  print("Widget is no longer mounted, skipping navigation");
                }
              } catch (e) {
                print("Logout failed: $e");
                if (mounted) {
                  // Tampilkan pesan error jika masih mounted
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Logout gagal: $e")));
                }
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveSizes rs = context.responsive;
    final userName = _userProvider.user?.full_name ?? 'Pengguna';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.white),
          onPressed: () {
            // Open drawer or handle menu click
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(
          'PedikaApp',
          style: context.textStyle.onestBold(
            size: SizeScale.xl,
            color: AppColors.white,
          ),
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final user = userProvider.user;
              final String? imageUrl = user?.photo_profile;

              return GestureDetector(
                onTap: () => _handleLogout(context, userName),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: context.responsive.space(SizeScale.sm),
                  ),
                  child: CircleAvatar(
                    radius: context.responsive.fontSize(SizeScale.md),
                    backgroundColor: AppColors.white.withOpacity(0.2),
                    backgroundImage:
                        imageUrl != null
                            ? CachedNetworkImageProvider(Config.fallbackImage)
                            : CachedNetworkImageProvider(imageUrl!),
                  ),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
      backgroundColor: AppColors.white,
      bottomNavigationBar: MotionTabBar(
        controller:
            _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Home",
        useSafeArea: true, // default: true, apply safe area wrapper
        labelAlwaysVisible:
            false, // default: false, set to "true" if you need to always show labels
        labels: const ["Laporan", "Home", "Settings"],

        //// use default icon (with IconData)
        icons: const [Icons.summarize, Icons.home, Icons.settings],

        tabSize: rs.space(SizeScale.xxxl) + rs.space(SizeScale.xl),
        tabBarHeight: rs.space(SizeScale.xxxl) + rs.space(SizeScale.xl),
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),

        // tabIconColor: Colors.blue[600],
        tabIconSize: rs.space(SizeScale.xxxl) + 2,
        tabIconSelectedSize: rs.space(SizeScale.xxxl) + 2,
        tabSelectedColor: Colors.white,
        tabIconSelectedColor: Colors.black,
        tabBarColor: AppColors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics:
            const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _motionTabBarController,
        children: <Widget>[
          DashboardViewReportPage(),
          DashboardRootPage(),

          MainPageContentComponent(
            title: "Settings Page",
            controller: _motionTabBarController!,
          ),
        ],
      ),
    );
  }
}

class MainPageContentComponent extends StatelessWidget {
  const MainPageContentComponent({
    required this.title,
    required this.controller,
    super.key,
  });

  final String title;
  final MotionTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Go to "X" page programmatically'),
          ElevatedButton(
            onPressed: () => controller.index = 0,
            child: const Text('Dashboard Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 1,
            child: const Text('Home Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 2,
            child: const Text('Profile Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 3,
            child: const Text('Settings Page'),
          ),
        ],
      ),
    );
  }
}

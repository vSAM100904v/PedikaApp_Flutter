import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';

import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_hook.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/admin_header.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_admin_card.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/action_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/update_emergency_contact.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/report_detail_modal.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/views/report_count.dart';
import 'package:pa2_kelompok07/main.dart';
import 'package:pa2_kelompok07/model/report/count_report_status.dart';
import 'package:pa2_kelompok07/model/report/emergency_contact_model.dart';

import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Donasi/halaman_donasi.dart';
import 'package:pa2_kelompok07/screens/admin/pages/beranda/admin_dashboard.dart';
import 'package:pa2_kelompok07/screens/admin/pages/event/halaman_event.dart';
import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/halamanbaru_kategori.dart';
import 'package:pa2_kelompok07/screens/admin/pages/konten/halaman_konten.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardRootPage extends StatefulWidget {
  final MotionTabBarController controller;
  const DashboardRootPage({super.key, required this.controller});
  @override
  State<DashboardRootPage> createState() => _DashboardRootPageState();
}

class _DashboardRootPageState extends State<DashboardRootPage>
    with AutomaticKeepAliveClientMixin {
  late Future<CountReportStatus> _statsFuture;
  final APIService _apiService = APIService();
  late Future<String> _emergencyContactFuture; // Simpan Future sebagai state

  @override
  void initState() {
    super.initState();
    _statsFuture = _apiService.fetchStatusStats();
    _emergencyContactFuture = APIService.instance.fetchEmergencyContact();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final responsive = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _headerView(responsive),
              SizedBox(height: responsive.space(SizeScale.sm)),
              Column(
                spacing: 12,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MenuItem(
                        icon: Icons.category,
                        label: 'Kategori Kekerasan',
                        onTap:
                            () => _navigateToPage(const HalamanbaruKategori()),
                      ),
                      _MenuItem(
                        icon: Icons.edit_calendar,
                        label: 'Janji temu',
                        onTap:
                            () => context.toast.showSuccess("Under Devlopping"),
                      ),
                      _MenuItem(
                        icon: Icons.article,
                        label: 'Konten',
                        onTap: () => _navigateToPage(const HalamanKonten()),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24,
                    children: [
                      Center(
                        child: _MenuItem(
                          icon: Icons.event,
                          label: 'Event',
                          onTap: () => _navigateToPage(const HalamanEvent()),
                        ),
                      ),
                      Center(
                        child: _MenuItem(
                          icon: Icons.volunteer_activism,
                          label: 'Donasi',
                          onTap: () => _navigateToPage(const HalamanDonasi()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsive.space(SizeScale.sm)),
              FutureBuilder<CountReportStatus>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Tampilkan shimmer effect saat loading
                    return Column(
                      children: List.generate(
                        3, // Jumlah card yang akan di-shimmer
                        (index) => _buildShimmerCard(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: PlaceHolderComponent(
                        state: PlaceHolderState.error,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final stats = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LaporanCard(
                          jumlah:
                              stats.laporanMasuk +
                              stats.laporanDilihat +
                              stats.laporanDiproses +
                              stats.laporanSelesai +
                              stats.laporanDibatalkan,
                          reportType: "Semua Laporan",
                          onTap: () => widget.controller.index = 0,
                        ),
                        const SizedBox(height: 14),
                        LaporanCard(
                          jumlah: stats.laporanDiproses,
                          reportType: "Laporan Diproses",
                          onTap: () => widget.controller.index = 0,
                        ),
                        const SizedBox(height: 14),
                        LaporanCard(
                          jumlah: stats.laporanDibatalkan,
                          reportType: "Laporan Dibatalkan",
                          onTap: () => widget.controller.index = 0,
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: PlaceHolderComponent(
                        state: PlaceHolderState.emptyReport,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Container _headerView(ResponsiveSizes responsive) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(responsive.space(SizeScale.lg)),
      decoration: BoxDecoration(
        color: Color(0xFF79B2E1),
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.sm),
        ),
        image: DecorationImage(
          image: AssetImage("assets/man.png"),
          fit: BoxFit.contain,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang",
                  style: context.textStyle.onestBold(
                    size: SizeScale.xl,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),
                Text(
                  "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
                  style: context.textStyle.dmSansRegular(
                    size: SizeScale.md,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),
                FutureBuilder<String>(
                  future: APIService.instance.fetchEmergencyContact(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        "Oops ada kesalahan !",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      );
                    } else {
                      return const Text('No data');
                    }
                  },
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),
                GestureDetector(
                  onTap: () async {
                    final result = await showDialog<EmergencyContact>(
                      context: context,
                      builder:
                          (context) => const UpdateEmergencyContactDialog(),
                    );
                    if (result != null) {
                      context.toast.showSuccess(
                        "No Contak berhasil di update ${result.phone}}",
                      );
                    }
                  },
                  child: _tooltip(
                    responsive,
                    "Edit kontak darurat",
                    Icons.phone,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _tooltip(ResponsiveSizes responsive, String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.space(SizeScale.xs),
        vertical: responsive.space(SizeScale.xs) / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF79B2E1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          Text(
            title,
            style: context.textStyle.jakartaSansMedium(size: SizeScale.md),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle;
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.md),
        ),
        splashColor: colors.primary.withOpacity(0.1),
        highlightColor: colors.primary.withOpacity(0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: responsive.space(SizeScale.xs),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
              child: Icon(
                icon,
                color: Color(0xFF79B2E1),
                size: responsive.fontSize(SizeScale.xl),
              ),
            ),
            SizedBox(height: responsive.space(SizeScale.xs)),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.widthPercent(20), // Adjust as needed
              ),
              child: Text(
                label,
                style: textStyle.jakartaSansMedium(
                  size: SizeScale.xs,
                  color: colors.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

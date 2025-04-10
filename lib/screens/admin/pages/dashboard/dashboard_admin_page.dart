import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
import 'package:pa2_kelompok07/core/persentation/widgets/modals/report_detail_modal.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/views/report_count.dart';
import 'package:pa2_kelompok07/main.dart';

import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Donasi/halaman_donasi.dart';
import 'package:pa2_kelompok07/screens/admin/pages/event/halaman_event.dart';
import 'package:pa2_kelompok07/screens/admin/pages/janjiTemu/janjitemu.dart';
import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/halamanbaru_kategori.dart';
import 'package:pa2_kelompok07/screens/admin/pages/konten/halaman_konten.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';
import 'package:provider/provider.dart';

class DashboardRootPage extends StatefulWidget {
  const DashboardRootPage({super.key});

  @override
  State<DashboardRootPage> createState() => _DashboardRootPageState();
}

class _DashboardRootPageState extends State<DashboardRootPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
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
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _MenuItem(
                    icon: Icons.category,
                    label: 'Kategori Kekerasan',
                    onTap: () => _navigateToPage(const HalamanbaruKategori()),
                  ),
                  _MenuItem(
                    icon: Icons.edit_calendar,
                    label: 'Janji temu',
                    onTap: () => _navigateToPage(const JanjiTemu()),
                  ),
                  _MenuItem(
                    icon: Icons.article,
                    label: 'Konten',
                    onTap: () => _navigateToPage(const HalamanKonten()),
                  ),
                  _MenuItem(
                    icon: Icons.event,
                    label: 'Event',
                    onTap: () => _navigateToPage(const HalamanEvent()),
                  ),
                  _MenuItem(
                    icon: Icons.volunteer_activism,
                    label: 'Donasi',
                    onTap: () => _navigateToPage(const HalamanDonasi()),
                  ),
                ],
              ),

              Column(
                spacing: 14,
                children: [
                  LaporanCard(
                    jumlah: 101,
                    reportType: "Semua Laporan",
                    onTap: () {},
                  ),
                  LaporanCard(
                    jumlah: 203,
                    reportType: "Laporan Ditolak",
                    onTap: () {},
                  ),
                  LaporanCard(
                    reportType: "Laporan dibatalkan",
                    jumlah: 204,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _headerView(ResponsiveSizes responsive) {
    return Container(
      width: double.infinity,

      // margin: EdgeInsets.symmetric(
      //   horizontal: responsive.space(SizeScale.md),
      //   vertical: responsive.space(SizeScale.sm),
      // ),
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
                Text(
                  "0895626467202",
                  style: context.textStyle.onestBold(
                    size: SizeScale.md,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),
                _tooltip(responsive, "Edit kontak darurat", Icons.phone),
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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

    return InkWell(
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
              color: colors.surface,
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
    );
  }
}

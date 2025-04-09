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

              Wrap(
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
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),
                Text(
                  "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
                  style: context.textStyle.dmSansRegular(
                    size: SizeScale.md,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

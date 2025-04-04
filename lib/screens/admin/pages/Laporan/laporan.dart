import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../../../../styles/color.dart';
import 'package:pa2_kelompok07/screens/admin/pages/laporan/component/report_list_all.dart';
import 'package:pa2_kelompok07/screens/admin/pages/laporan/component/report_list_done.dart';
import 'package:pa2_kelompok07/screens/admin/pages/laporan/component/report_list_process.dart';
import 'package:pa2_kelompok07/screens/admin/pages/laporan/component/report_list_cancel.dart';

class Laporan extends StatelessWidget {
  const Laporan({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(length: 4, child: LaporanStf());
  }
}

class LaporanStf extends StatefulWidget {
  const LaporanStf({super.key});

  @override
  State<LaporanStf> createState() => _LaporanState();
}

class _LaporanState extends State<LaporanStf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Laporan",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(navigatorKey.currentState!.context)) {
              navigatorKey.currentState!.pop();
            } else {
              navigatorKey.currentState!.pushReplacementNamed('/homepage');
            }
          },
        ),
        bottom: const TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: 'Semua Laporan'),
            Tab(text: 'Dalam Proses'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
          indicatorColor: Colors.lightGreenAccent,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
        ),
      ),
      body: const TabBarView(
        children: [
          ReportListAll(), // Menampilkan semua laporan tanpa filter
          ReportListProcess(),
          ReportListDone(),
          ReportListCancel(),
        ],
      ),
    );
  }
}

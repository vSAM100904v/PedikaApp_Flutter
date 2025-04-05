import 'package:flutter/material.dart';

final List<Map<String, dynamic>> notifications = [
  {
    'title': 'Laporan masuk tentang kasus kekerasan di Desa Silalahi',
    'sender': 'Oleh pihak DPMDPPA',
    'time': DateTime.now().subtract(const Duration(hours: 2)),
    'icon': Icons.report,
    'color': Colors.red,
    'isRead': false,
  },
  {
    'title': 'Sosialisasi Pencegahan Kekerasan Kabupaten Toba',
    'sender': 'Oleh Dinas Sosial Kabupaten',
    'time': DateTime.now().subtract(const Duration(hours: 3)),
    'icon': Icons.campaign,
    'color': Colors.blue,
    'isRead': true,
  },
  {
    'title': 'Pertemuan rutin bulanan tim penanganan kasus',
    'sender': 'Oleh Koordinator Tim',
    'time': DateTime.now().subtract(const Duration(days: 1)),
    'icon': Icons.event,
    'color': Colors.green,
    'isRead': false,
  },
  {
    'title': 'Update data korban untuk laporan triwulan',
    'sender': 'Oleh Admin Sistem',
    'time': DateTime.now().subtract(const Duration(days: 3)),
    'icon': Icons.data_usage,
    'color': Colors.orange,
    'isRead': true,
  },
  {
    'title': 'Pelatihan konseling trauma pasca kekerasan',
    'sender': 'Oleh Psikolog DPMDPPA',
    'time': DateTime.now().subtract(const Duration(days: 7)),
    'icon': Icons.school,
    'color': Colors.purple,
    'isRead': true,
  },
];

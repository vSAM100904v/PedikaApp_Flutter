import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/seed.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/tracking_card.dart';
import 'package:provider/provider.dart';

import '../../../model/report/full_report_model.dart';
import '../../../model/report/tracking_report_model.dart';
import '../../../provider/report_provider.dart';
import '../../../styles/color.dart';
import 'package:url_launcher/url_launcher.dart';

// class TrackingPage extends StatefulWidget {
//   final String noRegistrasi;

//   TrackingPage({Key? key, required this.noRegistrasi}) : super(key: key);

//   @override
//   _TrackingPageState createState() => _TrackingPageState();
// }

// class _TrackingPageState extends State<TrackingPage> with TextLogger {
//   Future<DetailResponseModel>? reportDetailFuture;

//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ReportProvider>(
//         context,
//         listen: false,
//       ).fetchDetailReports(widget.noRegistrasi);
//     });
//   }

//   String formatDate(String dateStr) {
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat('HH:mm', 'id_ID').format(date);
//     } catch (e) {
//       debugPrint("Error parsing date: $e");
//       return "Invalid date";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Detail Laporan",
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: AppColor.primaryColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Consumer<ReportProvider>(
//         builder: (context, reportProvider, child) {
//           if (reportProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (reportProvider.errorMessage != null) {
//             return Center(child: Text('Error: ${reportProvider.errorMessage}'));
//           } else if (reportProvider.detailReport != null) {
//             final detail = reportProvider.detailReport!.data;
//             List<TrackingLaporanModel> sortedTracking =
//                 List<TrackingLaporanModel>.from(detail.trackingLaporan);
//             sortedTracking.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//             debugLog("sortedTracking: $sortedTracking");
//             return ListView.builder(
//               itemCount: sortedTracking.length,
//               itemBuilder: (context, index) {
//                 final tracking = sortedTracking[index];
//                 String jam = DateFormat(
//                   'HH:mm',
//                   'id_ID',
//                 ).format(tracking.updatedAt);
//                 debugLog("tracking: $tracking");
//                 return Column(
//                   children: [
//                     ListTile(
//                       leading: Text(
//                         jam,
//                         style: const TextStyle(
//                           fontSize: 12.0,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       title: Text(
//                         tracking.keterangan,
//                         style: const TextStyle(fontSize: 14.0),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children:
//                             tracking.documents
//                                 .where(
//                                   (url) =>
//                                       url.isNotEmpty && url.startsWith("http"),
//                                 )
//                                 .map((url) => buildContent(url))
//                                 .toList(),
//                       ),
//                       isThreeLine: true,
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 5.0,
//                         horizontal: 20.0,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('Tidak ada data yang tersedia'));
//           }
//         },
//       ),
//     );
//   }

//   Widget buildContent(String url) {
//     if (url.isEmpty || (!url.startsWith("http") && !url.endsWith(".pdf"))) {
//       return const Text("Dokumen tidak valid");
//     }

//     if (url.endsWith(".pdf")) {
//       return TextButton(
//         child: const Text("Open PDF"),
//         onPressed: () => _launchURL(url),
//       );
//     } else {
//       return CachedNetworkImage(
//         imageUrl: url,
//         fit: BoxFit.cover,
//         errorWidget:
//             (context, url, error) => CachedNetworkImage(
//               imageUrl: Config.fallbackImage,
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width,
//             ),
//       );
//     }
//   }

//   Future<void> _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       debugPrint('Could not launch $url');
//     }
//   }
// }

// !

class TrackingPage extends StatefulWidget {
  final String noRegistrasi;

  const TrackingPage({super.key, required this.noRegistrasi});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchDetailReports(widget.noRegistrasi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (reportProvider.errorMessage != null) {
            return Center(child: Text('Error: ${reportProvider.errorMessage}'));
          } else if (reportProvider.detailReport != null) {
            final detail = reportProvider.detailReport!.data;
            final sortedTracking = List<TrackingLaporanModel>.from(
              detail.trackingLaporan,
            )..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            if (sortedTracking.isEmpty) {
              return const Center(child: Text('Tidak ada data yang tersedia'));
            }
            return ListView.builder(
              padding: EdgeInsets.only(
                top: context.responsive.space(SizeScale.md),
              ),
              itemCount: sortedTracking.length,
              itemBuilder: (context, index) {
                final isLatest = index == 0;
                return TrackingCard(
                  tracking: sortedTracking[index],
                  isLatest: isLatest,
                  onTap: () {
                    // Handle card tap if needed
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data yang tersedia'));
          }
        },
      ),
    );
  }
}

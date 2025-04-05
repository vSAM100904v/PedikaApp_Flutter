import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:pa2_kelompok07/core/constant/seed.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/notification_card.dart';
import 'package:pa2_kelompok07/provider/notification_query_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Laporan/detail_report_screen.dart';
import 'package:provider/provider.dart';
import '../styles/color.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   void _handleNotificationTap(int index) {
//     setState(() {
//       MockUp.notifications[index]['isRead'] = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Notifikasi",
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.purple,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.purple.withOpacity(0.05),
//               Colors.purple.withOpacity(0.02),
//               Colors.transparent,
//             ],
//             stops: const [0.0, 0.3, 1.0],
//           ),
//         ),
//         child: ListView.separated(
//           padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
//           itemCount: MockUp.notifications.length,
//           separatorBuilder:
//               (context, index) =>
//                   SizedBox(height: context.responsive.space(SizeScale.xs)),
//           itemBuilder: (context, index) {
//             final notification = MockUp.notifications[index];
//             return NotificationCard(
//               title: notification['title'],
//               sender: notification['sender'],
//               time: notification['time'],
//               icon: notification['icon'],
//               iconColor: notification['color'],
//               isRead: notification['isRead'],
//               onTap: () => _handleNotificationTap(index),
//             );
//           },
//         ),
//       ),
//     );
//   }

// }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final PagingController<int, NotificationPayload> _pagingController;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final provider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      await provider.fetchNotifications(page: pageKey);

      final newItems = provider.notifications;
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, NotificationPayload>.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<NotificationPayload>(
            itemBuilder:
                (context, notification, index) => NotificationCard(
                  title: notification.title,
                  type: notification.type,
                  time: notification.createdAt,
                  isRead: notification.isRead,
                  data: notification.data,
                  onTap: () => _handleNotificationTap(notification),
                ),
            firstPageProgressIndicatorBuilder:
                (_) => const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder:
                (_) => const Center(child: CircularProgressIndicator()),
            firstPageErrorIndicatorBuilder:
                (context) => ErrorRetry(
                  error: _pagingController.error,
                  onRetry: () => _pagingController.refresh(),
                ),
            noItemsFoundIndicatorBuilder:
                (context) => const Center(child: Text('Tidak ada notifikasi')),
          ),
          separatorBuilder: (context, index) => const Divider(height: 1),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationPayload notification) {
    // Handle notification tap based on type
    switch (notification.type) {
      case NotificationType.chat:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (_) => ChatDetailScreen(chatId: notification.data['chatId']),
        //   ),
        // );
        break;
      case NotificationType.appointment:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (_) => AppointmentDetailScreen(
        //           appointmentId: notification.data['appointmentId'],
        //         ),
        //   ),
        // );
        break;
      case NotificationType.reportStatus:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DetailReportScreen(
                  noRegistrasi: notification.data['reportId'],
                ),
          ),
        );
        break;
    }
  }
}

class ErrorRetry extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;

  const ErrorRetry({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error: ${error.toString()}'),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:pa2_kelompok07/core/constant/seed.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/notification_detail_modal.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/notification_card.dart';
import 'package:pa2_kelompok07/core/utils/notification_type_util.dart';
import 'package:pa2_kelompok07/provider/notification_query_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Laporan/detail_report_screen.dart';
import 'package:pa2_kelompok07/screens/admin/pages/beranda/admin_dashboard.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:provider/provider.dart';
import '../styles/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TextLogger {
  static const _pageSize = 10;
  late final String _accessToken;

  late final PagingController<int, NotificationPayload> _pagingController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _accessToken = userProvider.userToken; // Pastikan token tidak null
    _pagingController = PagingController<int, NotificationPayload>(
      getNextPageKey: (PagingState<int, NotificationPayload> state) {
        debugLog("INI ADALAH ISI DARI PAGE KEY");

        final keys = state.keys;
        final pages = state.pages;

        if (keys == null) return 1;

        if (pages != null && pages.last.length < _pageSize) {
          return null;
        }

        return keys.last + 1;
      },
      fetchPage: (pageKey) async {
        try {
          final result = await APIService().fetchNotifications(
            _accessToken,
            pageKey,
            _pageSize,
          );
          final notifications =
              result['notifications'] as List<NotificationPayload>;

          return notifications;
        } catch (e) {
          debugLog('Error fetching page $pageKey: $e');
          rethrow;
        }
      },
    );
    _pagingController.addListener(_showError);
  }

  Future<void> _showError() async {
    if (_pagingController.value.status == PagingStatus.subsequentPageError) {
      context.toast.showError("Gagal memuat notifikasi tambahan");
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
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _pagingController.refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: PagingListener(
          controller: _pagingController,
          builder:
              (
                context,
                state,
                fetchNextPage,
              ) => PagedListView<int, NotificationPayload>.separated(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<NotificationPayload>(
                  animateTransitions: true,
                  itemBuilder:
                      (context, notification, index) => NotificationCard(
                        title: notification.title,
                        type: notification.type,
                        time: notification.createdAt,
                        isRead: notification.isRead,
                        onTap: () => _handleNotificationTap(notification),
                      ),
                  firstPageProgressIndicatorBuilder:
                      (_) => const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder:
                      (_) => const Center(child: CircularProgressIndicator()),
                  firstPageErrorIndicatorBuilder:
                      (context) => PlaceHolderComponent(
                        state: PlaceHolderState.customError,
                      ),
                  newPageErrorIndicatorBuilder:
                      (context) => PlaceHolderComponent(
                        state: PlaceHolderState.customError,
                      ),
                  noItemsFoundIndicatorBuilder:
                      (context) => PlaceHolderComponent(
                        state: PlaceHolderState.noNotifications,
                      ),
                ),
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationPayload notification) async {
    debugLog('Notification tapped: ${notification.data}');

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (alertDialogContext) {
        return NotificationDetail(
          notification: notification,
          onPressed: () {
            switch (notification.type) {
              case NotificationType.chat:
                // Navigator.push(...);
                break;
              case NotificationType.appointment:
                // Navigator.push(...);
                break;
              case NotificationType.reportStatus:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetailReportScreen(
                          noRegistrasi: notification.data.reportId.toString(),
                        ),
                  ),
                );
                break;
              default:
                return null;
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';

class NotificationTypeUtils {
  static IconData getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.chat:
        return Icons.chat_bubble;
      case NotificationType.appointment:
        return Icons.calendar_today;
      case NotificationType.reportStatus:
        return Icons.assignment;

      case NotificationType.trackingUpdate:
        return Icons.spatial_tracking;
      default:
        return Icons.query_stats;
    }
  }

  static Color getColor(NotificationType type) {
    switch (type) {
      case NotificationType.chat:
        return AppColors.secondary;
      case NotificationType.appointment:
        return AppColors.accent1;
      case NotificationType.reportStatus:
        return AppColors.warning;
      case NotificationType.trackingUpdate:
        return AppColors.accent2;
      default:
        return AppColors.error;
    }
  }

  static String getSender(NotificationType type) {
    switch (type) {
      case NotificationType.chat:
        return 'Pesan Baru';
      case NotificationType.appointment:
        return 'Janji Temu';
      case NotificationType.reportStatus:
        return 'Status Laporan';
      case NotificationType.trackingUpdate:
        return 'Tracking Laporan Baru';
      default:
        return 'Unknown';
    }
  }
}

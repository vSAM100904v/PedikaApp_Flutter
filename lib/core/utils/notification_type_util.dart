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
    }
  }
}

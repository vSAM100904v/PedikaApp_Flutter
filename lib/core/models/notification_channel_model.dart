import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationType { chat, appointment, reportStatus }

extension NotificationTypeExtension on NotificationType {
  String get stringValue {
    switch (this) {
      case NotificationType.chat:
        return 'chat';
      case NotificationType.appointment:
        return 'appointment';
      case NotificationType.reportStatus:
        return 'report_status';
    }
  }

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'chat':
        return NotificationType.chat;
      case 'appointment':
        return NotificationType.appointment;
      case 'report_status':
        return NotificationType.reportStatus;
      default:
        throw Exception('Unknown NotificationType: $value');
    }
  }
}

enum ReportStatus {
  received,
  inProgress,
  completed,
  cancelled,
  requiresAction,
  waitingApproval,
}

extension ReportStatusExtension on ReportStatus {
  String get stringValue {
    switch (this) {
      case ReportStatus.received:
        return 'received';
      case ReportStatus.inProgress:
        return 'in_progress';
      case ReportStatus.completed:
        return 'completed';
      case ReportStatus.cancelled:
        return 'cancelled';
      case ReportStatus.requiresAction:
        return 'requires_action';
      case ReportStatus.waitingApproval:
        return 'waiting_approval';
      default:
        return 'unknown';
    }
  }

  String get displayText {
    switch (this) {
      case ReportStatus.received:
        return 'Laporan Diterima';
      case ReportStatus.inProgress:
        return 'Laporan Diproses';
      case ReportStatus.completed:
        return 'Laporan Selesai';
      case ReportStatus.cancelled:
        return 'Laporan Dibatalkan';
      case ReportStatus.requiresAction:
        return 'Perlu Tindakan';
      case ReportStatus.waitingApproval:
        return 'Menunggu Persetujuan';
    }
  }
}

class NotificationContent {
  final String? title;
  final String? body;
  final String? imageUrl;

  NotificationContent({this.title, this.body, this.imageUrl});

  factory NotificationContent.fromRemoteNotification(
    RemoteNotification? notification,
  ) {
    return NotificationContent(
      title: notification?.title,
      body: notification?.body,
      imageUrl: notification?.android?.imageUrl,
    );
  }

  @override
  String toString() {
    return 'NotificationContent{title: $title, body: $body, imageUrl: $imageUrl}';
  }
}

class ReportStatusData {
  final String reportId;
  final ReportStatus status;
  final String? updatedBy;
  final DateTime? updatedAt;
  final String? notes;

  ReportStatusData({
    required this.reportId,
    required this.status,
    this.updatedBy,
    this.updatedAt,
    this.notes,
  });

  factory ReportStatusData.fromMap(Map<String, dynamic> data) {
    return ReportStatusData(
      reportId: data['reportId'] as String,
      status: _parseReportStatus(data['status'] as String),
      updatedBy: data['updatedBy'] as String?,
      updatedAt:
          data['updatedAt'] != null
              ? DateTime.parse(data['updatedAt'] as String)
              : null,
      notes: data['notes'] as String?,
    );
  }

  static ReportStatus _parseReportStatus(String status) {
    switch (status) {
      case 'received':
        return ReportStatus.received;
      case 'in_progress':
        return ReportStatus.inProgress;
      case 'completed':
        return ReportStatus.completed;
      case 'cancelled':
        return ReportStatus.cancelled;
      case 'requires_action':
        return ReportStatus.requiresAction;
      case 'waiting_approval':
        return ReportStatus.waitingApproval;
      default:
        return ReportStatus.received;
    }
  }
}

class NotificationData {
  final NotificationType type;
  final String? chatId;
  final String? appointmentId;
  final ReportStatusData? reportStatusData;

  NotificationData({
    required this.type,
    this.chatId,
    this.appointmentId,
    this.reportStatusData,
  });

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    final typeString = data['type']?.toString().toLowerCase();
    final type = _parseNotificationType(typeString);

    return NotificationData(
      type: type,
      chatId: data['chatId'] as String?,
      appointmentId: data['appointmentId'] as String?,
      reportStatusData:
          type == NotificationType.reportStatus
              ? ReportStatusData.fromMap(data)
              : null,
    );
  }

  static NotificationType _parseNotificationType(String? typeString) {
    switch (typeString) {
      case 'appointment':
        return NotificationType.appointment;
      case 'report_status':
        return NotificationType.reportStatus;
      case 'chat':
      default:
        return NotificationType.chat;
    }
  }

  @override
  String toString() {
    return 'NotificationData{'
        'type: ${type.stringValue}, '
        'chatId: $chatId, '
        'appointmentId: $appointmentId, '
        'reportStatusData: $reportStatusData'
        '}';
  }
}

class AppNotification {
  final NotificationContent content;
  final NotificationData data;
  final DateTime receivedTime;

  AppNotification({
    required this.content,
    required this.data,
    DateTime? receivedTime,
  }) : receivedTime = receivedTime ?? DateTime.now();

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    return AppNotification(
      content: NotificationContent.fromRemoteNotification(message.notification),
      data: NotificationData.fromMap(message.data),
      receivedTime: message.sentTime?.toLocal(),
    );
  }

  @override
  String toString() {
    return 'AppNotification{'
        'content: $content, '
        'data: $data, '
        'receivedTime: $receivedTime'
        '}';
  }
}

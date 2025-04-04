import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationType { chat, appointment }

class NotificationContent {
  final String? title;
  final String? body;

  NotificationContent({this.title, this.body});

  factory NotificationContent.fromRemoteNotification(
    RemoteNotification? notification,
  ) {
    return NotificationContent(
      title: notification?.title,
      body: notification?.body,
    );
  }
}

// Model untuk bagian "data" dari FCM
class NotificationData {
  final NotificationType type;
  final String? chatId; // Opsional, untuk notifikasi chat
  final String? appointmentId; // Opsional, untuk notifikasi janji temu

  NotificationData({required this.type, this.chatId, this.appointmentId});

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    final typeString = data['type']?.toString().toLowerCase();
    final type =
        typeString == 'appointment'
            ? NotificationType.appointment
            : NotificationType.chat;

    return NotificationData(
      type: type,
      chatId: data['chatId'] as String?,
      appointmentId: data['appointmentId'] as String?,
    );
  }
}

// Model utama untuk seluruh pesan FCM
class AppNotification {
  final NotificationContent content;
  final NotificationData data;

  AppNotification({required this.content, required this.data});

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    return AppNotification(
      content: NotificationContent.fromRemoteNotification(message.notification),
      data: NotificationData.fromMap(message.data),
    );
  }
}

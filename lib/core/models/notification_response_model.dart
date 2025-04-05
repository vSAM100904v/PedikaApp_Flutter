import 'dart:convert';

import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';

class NotificationPayload {
  final int id;
  final int userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationPayload({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: NotificationTypeExtension.fromString(json['type'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      data: jsonDecode(json['data'] as String) as Map<String, dynamic>,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  NotificationPayload copyWith({
    int? id,
    int? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationPayload(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationResponse {
  final List<NotificationPayload> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NotificationResponse({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final notificationsData = data['notifications'] as List;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return NotificationResponse(
      notifications:
          notificationsData
              .map(
                (item) =>
                    NotificationPayload.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      total: pagination['total'] as int,
      page: pagination['page'] as int,
      limit: pagination['limit'] as int,
      totalPages: pagination['total_pages'] as int,
    );
  }
}

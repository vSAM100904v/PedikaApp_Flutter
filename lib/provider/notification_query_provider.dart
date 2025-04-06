import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart'; // Sesuaikan path
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';

import 'package:pa2_kelompok07/provider/user_provider.dart';

class NotificationProvider with ChangeNotifier {
  final UserProvider userProvider;
  final Logger _logger = Logger('NotificationProvider');

  List<NotificationPayload> _notifications = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  List<NotificationPayload> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  NotificationProvider({required this.userProvider});

  Future<void> markAsRead(String notificationId) async {
    try {
      final token = userProvider.userToken;
      final url = Uri.parse(
        'http://your-api-url:8080/notifications/$notificationId/read',
      );
      await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      _logger.log('Error marking notification as read: $e');
    }
  }
}

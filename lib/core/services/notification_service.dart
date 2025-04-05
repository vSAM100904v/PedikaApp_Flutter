import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/models/notification_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.instance.initLocalNotifications();
  await NotificationService.instance.showNotification(
    AppNotification.fromRemoteMessage(message),
  );
}

class NotificationService {
  // Singleton pattern
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  // Dependencies
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger('NotificationService');
  bool _isLocalNotificationsInitialized = false;

  // FOR SET FCM TOKEN TO MAKE IT PERSISTED!
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Android notification channel
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description:
            'Channel for important notifications like chat and appointments',
        importance: Importance.high,
      );

  // Inisialisasi utama
  Future<void> initialize() async {
    print('Initializing notification service...');
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await initLocalNotifications();
    _setupMessageHandlers();
    _messaging.onTokenRefresh.listen((newToken) async {
      await _updateFcmToken(newToken);
    });
    await _getAndSaveFcmToken();
  }

  // Meminta izin notifikasi
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _logger.log('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> initLocalNotifications() async {
    if (_isLocalNotificationsInitialized) return;

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    _isLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(AppNotification notification) async {
    final content = notification.content;
    final data = notification.data;

    if (content.title == null || content.body == null) return;

    _logger.log('Received notification: ${notification.toString()}');

    // Customize notification based on type
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: _getNotificationColor(data.type),
      largeIcon:
          content.imageUrl != null
              ? FilePathAndroidBitmap(content.imageUrl!)
              : null,
      styleInformation:
          data.type == NotificationType.reportStatus
              ? InboxStyleInformation(
                [content.body!],
                contentTitle: content.title,
                summaryText: 'Status Laporan Diperbarui',
              )
              : null,
    );

    await _localNotifications.show(
      notification.receivedTime.millisecondsSinceEpoch,
      content.title,
      content.body,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode({
        'type': data.type.stringValue,
        'data': {
          if (data.chatId != null) 'chatId': data.chatId,
          if (data.appointmentId != null) 'appointmentId': data.appointmentId,
          if (data.reportStatusData != null)
            'reportData': {
              'reportId': data.reportStatusData!.reportId,
              'status': data.reportStatusData!.status.stringValue,
              'updatedBy': data.reportStatusData!.updatedBy,
              'notes': data.reportStatusData!.notes,
            },
        },
      }),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.chat:
        return AppColors.secondary;
      case NotificationType.appointment:
        return AppColors.tertiary;
      case NotificationType.reportStatus:
        return AppColors.primary;
    }
  }

  // Setup handler untuk foreground, background, dan saat app dibuka
  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(AppNotification.fromRemoteMessage(message));
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageAction);

    _messaging.getInitialMessage().then((message) {
      if (message != null) _handleMessageAction(message);
    });
  }

  void _handleMessageAction(RemoteMessage message) {
    final appNotification = AppNotification.fromRemoteMessage(message);
    _logger.log('Unknown notification type: ${appNotification.data}');
    switch (appNotification.data.type) {
      case NotificationType.chat:
        _logger.log(
          'Opening chat screen with ID: ${appNotification.data.chatId}',
        );
        // TODO: Navigasi ke layar chat dengan chatId
        break;
      case NotificationType.appointment:
        _logger.log(
          'Opening appointment screen with ID: ${appNotification.data.appointmentId}',
        );
        // TODO: Navigasi ke layar janji temu dengan appointmentId
        break;
      default:
        _logger.log('Unknown notification type: ${appNotification.data.type}');
        break;
    }
  }

  Future<void> _getAndSaveFcmToken() async {
    try {
      final currentToken = await _messaging.getToken();
      if (currentToken == null) return;

      _logger.log('Current FCM Token: $currentToken');
      final storedToken = await _secureStorage.read(key: 'fcm_token');

      if (storedToken != currentToken) {
        await _secureStorage.write(key: 'fcm_token', value: currentToken);
        _logger.log('New FCM Token saved');
      }
    } catch (e) {
      _logger.log('Error handling FCM token: $e');
    }
  }

  // Method untuk update token ketika terjadi refresh
  Future<void> _updateFcmToken(String newToken) async {
    try {
      _logger.log('FCM Token refreshed: $newToken');
      await _secureStorage.write(key: 'fcm_token', value: newToken);
      _logger.log('Refreshed FCM Token saved');
    } catch (e) {
      _logger.log('Error updating FCM token: $e');
    }
  }

  // Method untuk mendapatkan token yang tersimpan
  Future<String?> getStoredFcmToken() async {
    return await _secureStorage.read(key: 'fcm_token');
  }

  void _handleNotificationResponse(NotificationResponse response) {
    _logger.log('Notification clicked with payload: ${response.payload}');
    // TODO: Parsing payload dan navigasi sesuai kebutuhan
  }
}

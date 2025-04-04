import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/models/notification_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await initLocalNotifications();
    _setupMessageHandlers();

    final token = await _messaging.getToken();
    _logger.log('FCM Token: $token');
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

  // Inisialisasi local notifications
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

  // Menampilkan notifikasi dengan model
  Future<void> showNotification(AppNotification notification) async {
    final content = notification.content;
    // final android = notification.content;
    if (content.title == null || content.body == null) return;

    await _localNotifications.show(
      content.title.hashCode,
      content.title,
      content.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.data.toString(),
    );
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

  // Menangani aksi berdasarkan tipe notifikasi
  void _handleMessageAction(RemoteMessage message) {
    final appNotification = AppNotification.fromRemoteMessage(message);
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
    }
  }

  // Menangani respons notifikasi (klik)
  void _handleNotificationResponse(NotificationResponse response) {
    _logger.log('Notification clicked with payload: ${response.payload}');
    // TODO: Parsing payload dan navigasi sesuai kebutuhan
  }
}

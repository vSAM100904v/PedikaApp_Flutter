import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/constant/seed.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/notification_card.dart';
import '../styles/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _handleNotificationTap(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.05),
              Colors.purple.withOpacity(0.02),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
          itemCount: notifications.length,
          separatorBuilder:
              (context, index) =>
                  SizedBox(height: context.responsive.space(SizeScale.xs)),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(
              title: notification['title'],
              sender: notification['sender'],
              time: notification['time'],
              icon: notification['icon'],
              iconColor: notification['color'],
              isRead: notification['isRead'],
              onTap: () => _handleNotificationTap(index),
            );
          },
        ),
      ),
    );
  }
}

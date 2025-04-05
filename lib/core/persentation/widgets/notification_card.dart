import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/utils/notification_type_util.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final NotificationType type;
  final DateTime time;
  final bool isRead;
  final VoidCallback? onTap;
  final Map<String, dynamic>? data;

  const NotificationCard({
    super.key,
    required this.title,
    required this.type,
    required this.time,
    required this.isRead,
    this.onTap,
    this.data,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 30) {
      return DateFormat('dd MMM yyyy').format(time);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: responsive.space(SizeScale.xs)),
      decoration: BoxDecoration(
        color:
            isRead
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.sm),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.space(SizeScale.md)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      transform:
                          Matrix4.identity()
                            ..scale(isRead ? 0.9 : 1.0, isRead ? 0.9 : 1.0),
                      child: CircleAvatar(
                        backgroundColor: NotificationTypeUtils.getColor(
                          type,
                        ).withOpacity(isRead ? 0.7 : 1.0),
                        radius: responsive.space(SizeScale.xxl),
                        child: Icon(
                          NotificationTypeUtils.getIcon(type),
                          color: Colors.white,
                          size: responsive.fontSize(SizeScale.xl),
                        ),
                      ),
                    ),
                    if (isRead)
                      Positioned(
                        right: 0,
                        child: Container(
                          width: responsive.space(SizeScale.xs),
                          height: responsive.space(SizeScale.xs),
                          decoration: BoxDecoration(
                            color:
                                HSLColor.fromColor(AppColors.accent4)
                                    .withSaturation(1.0) // Saturation maksimal
                                    .withLightness(0.4) // Lebih gelap
                                    .toColor(),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.priority_high,
                            size: responsive.space(SizeScale.xs),
                            color: AppColors.accent4,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: responsive.space(SizeScale.md)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                    isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                color:
                                    isRead
                                        ? theme.colorScheme.onSurface
                                            .withOpacity(0.7)
                                        : theme.colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.space(SizeScale.xs)),
                      Text(
                        NotificationTypeUtils.getSender(type),

                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: responsive.space(SizeScale.xs)),
                      Row(
                        children: [
                          Text(
                            _formatTime(time),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            size: responsive.fontSize(SizeScale.md),
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

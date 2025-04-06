import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/custom_icon.dart';
import 'package:pa2_kelompok07/core/utils/notification_type_util.dart';
import 'package:pa2_kelompok07/styles/color.dart';

class ActionDialog extends StatefulWidget {
  final NotificationPayload notification;
  final VoidCallback? onPressed;
  const ActionDialog({super.key, required this.notification, this.onPressed});

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final responsive = context.responsive;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: EdgeInsets.all(responsive.space(SizeScale.xxl)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkSurface,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: responsive.space(SizeScale.md),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(responsive.space(SizeScale.xs)),
                        decoration: BoxDecoration(
                          color: NotificationTypeUtils.getColor(
                            widget.notification.type,
                          ).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconButton(
                          icon: NotificationTypeUtils.getIcon(
                            widget.notification.type,
                          ),
                          iconSize: responsive.space(SizeScale.xxl),
                          color: NotificationTypeUtils.getColor(
                            widget.notification.type,
                          ),
                        ),
                      ),
                      Text(
                        NotificationTypeUtils.getSender(
                          widget.notification.type,
                        ),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.space(SizeScale.xs)),
                  Text(
                    widget.notification.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsive.space(SizeScale.xxl)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.space(SizeScale.md),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: NotificationTypeUtils.getColor(
                                widget.notification.type,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Tutup",
                            style: TextStyle(
                              color: NotificationTypeUtils.getColor(
                                widget.notification.type,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.space(SizeScale.md)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NotificationTypeUtils.getColor(
                              widget.notification.type,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.space(SizeScale.md),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed:
                              () =>
                                  widget.onPressed != null
                                      ? widget.onPressed?.call()
                                      : Navigator.pop(context, true),
                          child: Text(
                            "Lanjut",
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

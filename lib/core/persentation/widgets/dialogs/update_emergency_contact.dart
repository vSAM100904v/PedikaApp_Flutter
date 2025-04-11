import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/model/report/emergency_contact_model.dart';
import 'package:pa2_kelompok07/services/api_service.dart';

import 'package:flutter/material.dart';

class UpdateEmergencyContactDialog extends StatefulWidget {
  const UpdateEmergencyContactDialog({super.key});

  @override
  State<UpdateEmergencyContactDialog> createState() =>
      _UpdateEmergencyContactDialogState();
}

class _UpdateEmergencyContactDialogState
    extends State<UpdateEmergencyContactDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final APIService _apiService = APIService();
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String? _initialPhone; // Menyimpan data awal dari fetch

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

    // Fetch data awal hanya sekali di initState
    _fetchInitialData();
    _controller.forward();
  }

  Future<void> _fetchInitialData() async {
    try {
      final phone = await _apiService.fetchEmergencyContact();
      if (mounted) {
        setState(() {
          _initialPhone = phone;
          _phoneController.text = phone; // Set nilai awal setelah fetch
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _updateContact() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedContact = EmergencyContact(phone: _phoneController.text);
      final result = await _apiService.updateEmergencyContact(updatedContact);
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle;
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                responsive.borderRadius(SizeScale.lg),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(responsive.space(SizeScale.md)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emergency_rounded,
                        size: responsive.fontSize(SizeScale.xxl),
                        color: Colors.red[400],
                      ),
                      SizedBox(width: responsive.space(SizeScale.sm)),
                      Text(
                        'Update Kontak Darurat',
                        style: textStyle.onestBold(
                          size: SizeScale.lg,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.space(SizeScale.md)),
                  if (_initialPhone == null &&
                      _errorMessage == null) // Loading state
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.primaryColor,
                        ),
                      ),
                    )
                  else if (_errorMessage != null &&
                      _initialPhone == null) // Error state
                    Container(
                      padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.sm),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[400]),
                          SizedBox(width: responsive.space(SizeScale.sm)),
                          Expanded(
                            child: Text(
                              'Error: $_errorMessage',
                              style: textStyle.dmSansRegular(
                                size: SizeScale.sm,
                                color: Colors.red[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else // Data loaded state
                    Column(
                      children: [
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Nomor Telepon',
                            labelStyle: textStyle.dmSansRegular(
                              size: SizeScale.sm,
                              color: Colors.grey[600],
                            ),
                            prefixIcon: Icon(
                              Icons.phone_rounded,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                responsive.borderRadius(SizeScale.sm),
                              ),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                responsive.borderRadius(SizeScale.sm),
                              ),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                responsive.borderRadius(SizeScale.sm),
                              ),
                              borderSide: BorderSide(
                                color: theme.primaryColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          style: textStyle.dmSansRegular(
                            size: SizeScale.sm,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: responsive.space(SizeScale.sm)),
                          Container(
                            padding: EdgeInsets.all(
                              responsive.space(SizeScale.sm),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(
                                responsive.borderRadius(SizeScale.sm),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: responsive.fontSize(SizeScale.md),
                                  color: Colors.red[400],
                                ),
                                SizedBox(width: responsive.space(SizeScale.sm)),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: textStyle.dmSansRegular(
                                      size: SizeScale.sm,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  SizedBox(height: responsive.space(SizeScale.lg)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.space(SizeScale.md),
                            vertical: responsive.space(SizeScale.sm),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: textStyle.jakartaSansMedium(
                            size: SizeScale.sm,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.space(SizeScale.sm)),
                      ElevatedButton(
                        onPressed:
                            _isLoading || _initialPhone == null
                                ? null
                                : _updateContact,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.space(SizeScale.md),
                            vertical: responsive.space(SizeScale.sm),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(SizeScale.sm),
                            ),
                          ),
                          elevation: 0,
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: responsive.fontSize(SizeScale.md),
                                  height: responsive.fontSize(SizeScale.md),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  'Update',
                                  style: textStyle.jakartaSansMedium(
                                    size: SizeScale.sm,
                                    color: Colors.white,
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

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

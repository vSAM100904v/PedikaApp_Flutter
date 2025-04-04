import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  String _adminToken = '';

  String get adminToken => _adminToken;

  /// Memuat token admin dari SharedPreferences.
  Future<void> loadAdminToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _adminToken = prefs.getString('adminToken') ?? '';
    notifyListeners();
  }

  /// Menyimpan token admin ke SharedPreferences dan memperbarui state.
  Future<void> saveAdminToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminToken', token);
    _adminToken = token;
    notifyListeners();
  }

  /// Menghapus token admin dari SharedPreferences dan memperbarui state.
  Future<void> clearAdminToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('adminToken');
    _adminToken = '';
    notifyListeners();
  }
}

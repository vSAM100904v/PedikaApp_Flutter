import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  String _adminToken = '';

  String get adminToken => _adminToken;

  List<ListLaporanModel> _reports = [];
  bool _isLoading = false;
  String? _error;
  final int _pageSize = 5; // Sesuaikan dengan _itemsPerPage Anda
  int _currentPage = 1;
  int _totalPages = 1; // Total halaman dari server
  final UserProvider _userProvider;

  AdminProvider(this._userProvider);

  List<ListLaporanModel> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  // Fetch laporan untuk halaman tertentu
  Future<void> fetchReports(int page) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await APIService().retrieveAvailableReportsAdminService(
        _userProvider.userToken!,
        page,
        _pageSize,
      );
      _reports = result['reports'] as List<ListLaporanModel>;
      _totalPages =
          (result['totalItems'] as int? ?? _reports.length) ~/ _pageSize + 1;
      _currentPage = page;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ganti halaman
  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages && page != _currentPage) {
      fetchReports(page);
    }
  }

  void updateReport(String noRegistrasi, String newStatus) {
    final index = _reports.indexWhere(
      (report) => report.noRegistrasi == noRegistrasi,
    );

    print("TIDAKKK ADA DATA DI INDEX $index");
    if (index != -1) {
      print("TIDAKKK ADA DATA DI INDEX $index");
      updateReportByIndex(index, status: newStatus);
    }
  }

  void updateReportByIndex(
    int index, {
    String? status,
    DateTime? tanggalKejadian,
    int? useridMelihat,
    String? waktuDilihat,
  }) {
    if (index >= 0 && index < _reports.length) {
      _reports[index] = _reports[index].copyWith(
        status: status,
        tanggalKejadian: tanggalKejadian,
        useridMelihat: useridMelihat,
        waktuDilihat: waktuDilihat,
      );
      notifyListeners();
    }
  }

  void filterOrSortReports({String? statusFilter, bool sortByDateAsc = true}) {
    List<ListLaporanModel> filteredReports = List.from(_reports);

    if (statusFilter != null && statusFilter.isNotEmpty) {
      filteredReports =
          filteredReports
              .where(
                (report) => report.status.toLowerCase().contains(
                  statusFilter.toLowerCase(),
                ),
              )
              .toList();
    }

    filteredReports.sort((a, b) {
      final dateA = DateTime.parse(a.tanggalKejadian as String);
      final dateB = DateTime.parse(b.tanggalKejadian as String);
      return sortByDateAsc ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    _reports = filteredReports;
    notifyListeners();
  }

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

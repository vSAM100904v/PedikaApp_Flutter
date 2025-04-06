import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import '../model/report/full_report_model.dart';
import '../services/api_service.dart';

class ReportProvider with ChangeNotifier {
  ResponseModel? reports;
  bool isLoading = false;
  String? errorMessage;
  final Logger _logger = Logger("Report Provider");
  DetailResponseModel? detailReport;

  Future<void> fetchReports() async {
    _setLoading(true);
    try {
      reports = await APIService().fetchUserReports();
      _setLoading(false);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> fetchDetailReports(String noRegistrasi) async {
    notifyListeners();
    _setLoading(true);
    try {
      detailReport = await APIService().getFullReportDetails(noRegistrasi);

      _setLoading(false);
    } catch (e) {
      _handleError(e);
    } finally {
      notifyListeners();
    }
  }

  // Future<void> fetchReportsByLaporanMasuk() async {
  //   _setLoading(true);
  //   try {
  //     var allReports = await APIService().fetchUserReports();
  //     if (allReports != null && allReports.data != null) {
  //       var filteredReports =
  //           allReports.data!
  //               .where((report) => report.status == "Laporan masuk")
  //               .toList();
  //       reports = ResponseModel(
  //         code: allReports.code,
  //         status: allReports.status,
  //         message: "Filtered by Laporan masuk",
  //         data: filteredReports,
  //       );
  //     }
  //     _setLoading(false);
  //   } catch (e) {
  //     _handleError(e);
  //   }
  // }

  // Future<void> fetchReportsByLaporanProses() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     var allReports = await APIService().fetchUserReports();
  //     var filteredReports =
  //         allReports.data
  //             .where((report) => report.status == "Diproses")
  //             .toList();
  //     reports = ResponseModel(
  //       code: allReports.code,
  //       status: allReports.status,
  //       message: allReports.message,
  //       data: filteredReports,
  //     );
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> fetchReportsByLaporanSelesai() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     var allReports = await APIService().fetchUserReports();
  //     var filteredReports =
  //         allReports.data
  //             .where((report) => report.status == "Selesai")
  //             .toList();
  //     reports = ResponseModel(
  //       code: allReports.code,
  //       status: allReports.status,
  //       message: allReports.message,
  //       data: filteredReports,
  //     );
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Metode untuk admin: mengambil semua laporan tanpa filter
  // Future<void> fetchAllReports() async {
  //   _setLoading(true);
  //   try {
  //     reports = await APIService().fetchAllReports();
  //     _setLoading(false);
  //   } catch (e) {
  //     _handleError(e);
  //   }
  // }

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _handleError(e) {
    errorMessage = e.toString();
    isLoading = false;
    notifyListeners();
  }

  // class ReportProvider with ChangeNotifier {
  // Separate lists for each report status
  List<ListLaporanModel> _reportsMasuk = [];
  List<ListLaporanModel> _reportsProses = [];
  List<ListLaporanModel> _reportsSelesai = [];

  // Detail report cache
  final Map<String, DetailResponseModel> _detailReportsCache = {};

  // Loading states
  bool _isLoadingAll = false;
  bool _isLoadingDetail = false;
  String? _errorMessage;

  // Getters
  List<ListLaporanModel> get reportsMasuk => _reportsMasuk;
  List<ListLaporanModel> get reportsProses => _reportsProses;
  List<ListLaporanModel> get reportsSelesai => _reportsSelesai;
  bool get isLoadingAll => _isLoadingAll;
  bool get isLoadingDetail => _isLoadingDetail;
  // String? get errorMessage => _errorMessage;

  // Main method to fetch all reports at once
  Future<void> fetchAllReports() async {
    _isLoadingAll = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final allReports = await APIService().fetchUserReports();

      if (allReports.data != null) {
        _reportsMasuk =
            allReports.data!
                .where((report) => report.status == "Laporan masuk")
                .toList();

        _reportsProses =
            allReports.data!
                .where((report) => report.status == "Diproses")
                .toList();

        _reportsSelesai =
            allReports.data!
                .where((report) => report.status == "Selesai")
                .toList();
      }

      _logger.log("Successfully fetched all reports");
    } catch (e) {
      _errorMessage = "Gagal memuat laporan: ${e.toString()}";
      _logger.log("Error fetching reports $e");
    } finally {
      _isLoadingAll = false;
      notifyListeners();
    }
  }

  // // Get detail report with caching
  // Future<DetailResponseModel?> fetchDetailReports(String noRegistrasi) async {
  //   // Return cached data if available
  //   if (_detailReportsCache.containsKey(noRegistrasi)) {
  //     return _detailReportsCache[noRegistrasi];
  //   }

  //   _isLoadingDetail = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     final detailReport = await APIService().getFullReportDetails(
  //       noRegistrasi,
  //     );
  //     _detailReportsCache[noRegistrasi] = detailReport;
  //     return detailReport;
  //   } catch (e) {
  //     _errorMessage = "Gagal memuat detail laporan";
  //     _logger.log("Error fetching detail report $e");
  //     return null;
  //   } finally {
  //     _isLoadingDetail = false;
  //     notifyListeners();
  //   }
  // }

  // Clear cache when needed
  void clearCache() {
    _detailReportsCache.clear();
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    _detailReportsCache.clear();
    await fetchAllReports();
  }

  // Individual status fetchers (optional, can be used for specific refreshes)
  Future<void> fetchReportsMasuk() async {
    try {
      final allReports = await APIService().fetchUserReports();
      _reportsMasuk =
          allReports.data!
              .where((report) => report.status == "Laporan masuk")
              .toList();
    } catch (e) {
      _errorMessage = "Gagal memuat laporan masuk";
    }
    notifyListeners();
  }

  Future<void> fetchReportsProses() async {
    try {
      final allReports = await APIService().fetchUserReports();
      _reportsProses =
          allReports.data!
              .where((report) => report.status == "Diproses")
              .toList();
    } catch (e) {
      _errorMessage = "Gagal memuat laporan proses";
    }
    notifyListeners();
  }

  Future<void> fetchReportsSelesai() async {
    try {
      final allReports = await APIService().fetchUserReports();
      _reportsSelesai =
          allReports.data!
              .where((report) => report.status == "Selesai")
              .toList();
    } catch (e) {
      _errorMessage = "Gagal memuat laporan selesai";
    }
    notifyListeners();
  }
}

// }

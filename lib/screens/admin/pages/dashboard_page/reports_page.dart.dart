import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';

import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_hook.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/admin_header.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_admin_card.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/action_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/report_detail_modal.dart';
import 'package:pa2_kelompok07/main.dart';

import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';
import 'package:provider/provider.dart';

class DashboardViewReportPage extends StatefulWidget {
  const DashboardViewReportPage({super.key});

  @override
  State<DashboardViewReportPage> createState() =>
      _DashboardViewReportPageState();
}

// class _DashboardViewReportPageState extends State<DashboardViewReportPage>
//     with SingleTickerProviderStateMixin, TextLogger {
//   late final UserProvider _userProvider;
//   int _currentPage = 1;
//   final int _itemsPerPage = 5;
//   static const _pageSize = 10;
//   final controller = ScrollController();
//   double offset = 0;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   TextEditingController searchController = TextEditingController();
//   int selectIndex = 0;
//   String searchQuery = '';
//   // Sample data for the table

//   late final PagingController<int, ListLaporanModel> _pagingController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//     _userProvider = Provider.of<UserProvider>(context, listen: false);

//     _pagingController = PagingController<int, ListLaporanModel>(
//       getNextPageKey: (state) {
//         final keys = state.keys;
//         final pages = state.pages;
//         if (keys == null) return 1;
//         if (pages != null && pages.last.length < _pageSize) {
//           return null; // Tidak ada halaman berikutnya jika jumlah item kurang dari limit
//         }
//         return keys.last + 1;
//       },
//       fetchPage: (pageKey) async {
//         try {
//           final result = await APIService()
//               .retrieveAvailableReportsAdminService(
//                 _userProvider.userToken!,
//                 pageKey,
//                 _pageSize,
//               );
//           final reports = result['reports'] as List<ListLaporanModel>;
//           // final totalPages = result['totalPages'] as bool;
//           // final limit = result['limit'] as int;
//           // final page = result['page'] as int;

//           return reports; // Mengembalikan daftar laporan
//         } catch (e) {
//           debugLog('Error fetching page $pageKey: $e');
//           rethrow;
//         }
//       },
//     );

//     _pagingController.addListener(_showError);
//   }

//   Future<void> _showError() async {
//     if (_pagingController.value.status == PagingStatus.subsequentPageError) {
//       context.toast.showError("Gagal memuat notifikasi tambahan");
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void updateSearchQuery(String query) {
//     setState(() {
//       searchQuery = query;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final responsive = context.responsive;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PendikaApp"),
//         leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
//         actions: [
//           IconButton(
//             icon: const CircleAvatar(
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, color: Colors.white),
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       backgroundColor: AppColors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with Cached Network Image
//               _headerView(responsive),

//               SizedBox(height: responsive.space(SizeScale.md)),

//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height:
//                           context.responsive.space(SizeScale.xxxl) +
//                           context.responsive.space(SizeScale.xl),
//                       child: TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.all(0),
//                           prefixIcon: const Icon(Icons.search_outlined),
//                           hintText: "Type Something",
//                           fillColor: Color(0xFFF7F7F7),
//                           filled: true,
//                           border: InputBorder.none,
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.grey.shade800),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(
//                               color: AppColors.black,
//                             ),
//                           ),
//                         ),
//                         onChanged: updateSearchQuery,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               _searchBar(responsive),

//               // Table Title
//               _taglineHeader(context),
//               SizedBox(height: responsive.space(SizeScale.sm)),

//               _columnListTitle(context),
//               // Table
//               SizedBox(
//                 height: 400,
//                 child: PagingListener(
//                   controller: _pagingController,
//                   builder:
//                       (context, state, fetchNextPage) =>
//                           PagedListView<int, ListLaporanModel>.separated(
//                             state: state,
//                             fetchNextPage: fetchNextPage,
//                             builderDelegate:
//                                 PagedChildBuilderDelegate<ListLaporanModel>(
//                                   animateTransitions: true,
//                                   itemBuilder:
//                                       (context, report, index) =>
//                                           ReportCardAdminView(
//                                             reportDate: report.tanggalKejadian,

//                                             status: report.status,
//                                             title: report.noRegistrasi,
//                                             onTap: () {
//                                               showLaporanDetailBottomSheet(
//                                                 context,
//                                                 report,
//                                               );
//                                             },
//                                           ),
//                                   firstPageProgressIndicatorBuilder:
//                                       (_) => const Center(
//                                         child: CircularProgressIndicator(),
//                                       ),
//                                   newPageProgressIndicatorBuilder:
//                                       (_) => const Center(
//                                         child: CircularProgressIndicator(),
//                                       ),
//                                   firstPageErrorIndicatorBuilder:
//                                       (context) => PlaceHolderComponent(
//                                         state: PlaceHolderState.customError,
//                                       ),
//                                   newPageErrorIndicatorBuilder:
//                                       (context) => PlaceHolderComponent(
//                                         state: PlaceHolderState.customError,
//                                       ),
//                                   noItemsFoundIndicatorBuilder:
//                                       (context) => PlaceHolderComponent(
//                                         state: PlaceHolderState.noNotifications,
//                                       ),
//                                 ),
//                             separatorBuilder:
//                                 (context, index) => const Divider(height: 1),
//                           ),
//                 ),
//               ),

//               // Pagination
//               SizedBox(height: responsive.space(SizeScale.md)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed:
//                         _currentPage > 1
//                             ? () {
//                               setState(() {
//                                 _currentPage--;
//                                 _animationController.reset();
//                                 _animationController.forward();
//                               });
//                             }
//                             : null,
//                     icon: const Icon(Icons.arrow_back),
//                   ),
//                   Text(
//                     "Page $_currentPage of ${(4 / _itemsPerPage).ceil()}",
//                     style: TextStyle(
//                       fontSize: responsive.fontSize(SizeScale.sm),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed:
//                         _currentPage < (4 / _itemsPerPage).ceil()
//                             ? () {
//                               setState(() {
//                                 _currentPage++;
//                                 _animationController.reset();
//                                 _animationController.forward();
//                               });
//                             }
//                             : null,
//                     icon: const Icon(Icons.arrow_forward),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Text _taglineHeader(BuildContext context) {
//     return Text(
//       "Laporan Masyarakat Tersedia",
//       style: context.textStyle.onestBold(size: SizeScale.md),
//     );
//   }

//   Row _columnListTitle(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           "Nomor Registrasi".truncate(maxChars: 8),
//           style: context.textStyle.onestBold(size: SizeScale.md),
//         ),
//         // Tanggal Pelaporan
//         Text(
//           "Tanggal Pelaporan",
//           style: context.textStyle.onestBold(size: SizeScale.md),
//         ),

//         Text("Status", style: context.textStyle.onestBold(size: SizeScale.md)),
//       ],
//     );
//   }

//   SizedBox _searchBar(ResponsiveSizes responsive) =>
//       SizedBox(height: responsive.space(SizeScale.md));

//   FadeTransition _headerView(ResponsiveSizes responsive) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         width: double.infinity,

//         // margin: EdgeInsets.symmetric(
//         //   horizontal: responsive.space(SizeScale.md),
//         //   vertical: responsive.space(SizeScale.sm),
//         // ),
//         padding: EdgeInsets.all(responsive.space(SizeScale.lg)),
//         decoration: BoxDecoration(
//           color: Color(0xFF79B2E1),
//           borderRadius: BorderRadius.circular(
//             responsive.borderRadius(SizeScale.sm),
//           ),
//           image: DecorationImage(
//             image: AssetImage("assets/man.png"),
//             fit: BoxFit.contain,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Pelaporan DPMDPPA",
//                     style: context.textStyle.onestBold(
//                       size: SizeScale.xl,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: responsive.space(SizeScale.sm)),
//                   Text(
//                     "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
//                     style: context.textStyle.dmSansRegular(
//                       size: SizeScale.md,
//                       color: Colors.white,
//                     ),
//                   ),
//                   // Text(
//                   //   "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
//                   //   style: context.textStyle.dmSansRegular(
//                   //     size: SizeScale.md,
//                   //     color: Colors.white,
//                   //   ),
//                   //   textAlign: TextAlign.center,
//                   // ),
//                 ],
//               ),
//             ),
//             SizedBox(width: responsive.space(SizeScale.md)),
//           ],
//         ),
//       ),
//     );
//   }

//   void showLaporanDetailBottomSheet(
//     BuildContext context,
//     ListLaporanModel laporan, {
//     bool isRefreshing = false,
//   }) async {
//     // Gunakan rootNavigator untuk mencegah masalah context
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return ReportDetailModal(
//           laporan: laporan,
//           onUpdate:
//               () => showLaporanDetailBottomSheet(
//                 context,
//                 laporan,
//                 isRefreshing: true,
//               ),
//           onOpenDialog: (innerContext) {
//             showDialog(
//               context: innerContext,
//               builder: (dialogContext) {
//                 return ActionDialog(
//                   laporan: laporan,
//                   onStatusUpdated: (newStatus) async {
//                     try {
//                       print("INI NILAI DARI NEW STATUS $newStatus");
//                       // Update status
//                       if (newStatus == "Selesai") {
//                         await APIService.instance
//                             .updateStatusReportAsDoneAdminService(
//                               accessToken: _userProvider.userToken,
//                               noRegistrasi: laporan.noRegistrasi,
//                             );
//                       } else if (newStatus == "Laporan masuk") {
//                         await APIService.instance
//                             .updateStatusReportAsProcessAdminService(
//                               accessToken: _userProvider.userToken,
//                               noRegistrasi: laporan.noRegistrasi,
//                             );
//                       }

//                       // Tutup dialog menggunakan navigatorKey
//                       // navigatorKey.currentState?.pop();

//                       // Tutup modal menggunakan Future.delayed
//                       Future.delayed(Duration.zero, () {
//                         if (context.mounted) {
//                           Navigator.of(context, rootNavigator: true).pop();
//                         }
//                       });

//                       // Refresh data tanpa membuka kembali modal
//                       // Gunakan state management atau callback untuk update UI
//                       // _pagingController.refresh();

//                       context.toast.showSuccess(
//                         "Status berhasil diubah ke $newStatus",
//                       );
//                     } catch (e) {
//                       context.toast.showError(
//                         "Gagal mengupdate status: ${e.toString()}",
//                       );
//                     }
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// !
class _DashboardViewReportPageState extends State<DashboardViewReportPage>
    with SingleTickerProviderStateMixin {
  late final UserProvider _userProvider;
  late AdminProvider _reportsNotifier;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportsNotifier = AdminProvider(_userProvider);
    _reportsNotifier.fetchReports(1); // Fetch halaman pertama
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _headerView(responsive),

              SizedBox(height: responsive.space(SizeScale.md)),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height:
                          context.responsive.space(SizeScale.xxxl) +
                          context.responsive.space(SizeScale.xl),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(Icons.search_outlined),
                          hintText: "Type Something",
                          fillColor: Color(0xFFF7F7F7),
                          filled: true,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade800),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        onChanged: updateSearchQuery,
                      ),
                    ),
                  ),
                ],
              ),
              _searchBar(responsive),

              // Table Title
              _taglineHeader(context),
              SizedBox(height: responsive.space(SizeScale.sm)),

              _columnListTitle(context),
              SizedBox(
                height: 400,
                child: ChangeNotifierProvider.value(
                  value: _reportsNotifier,
                  child: Consumer<AdminProvider>(
                    builder: (context, notifier, child) {
                      if (notifier.isLoading && notifier.reports.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (notifier.error != null && notifier.reports.isEmpty) {
                        return const Center(
                          child: PlaceHolderComponent(
                            state: PlaceHolderState.emptyReport,
                          ),
                        );
                      }

                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Tabel
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: notifier.reports.length,
                                itemBuilder: (context, index) {
                                  final report = notifier.reports[index];
                                  return ReportCardAdminView(
                                    reportDate: report.tanggalKejadian,
                                    status: report.status,
                                    title: report.noRegistrasi,
                                    onTap: () {
                                      showLaporanDetailBottomSheet(
                                        context,
                                        report,
                                        index,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed:
                                      notifier.currentPage > 1
                                          ? () {
                                            _animationController.reset();
                                            _animationController.forward();
                                            notifier.goToPage(
                                              notifier.currentPage - 1,
                                            );
                                          }
                                          : null,
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Text(
                                  "Page ${notifier.currentPage} of ${notifier.totalPages}",
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(SizeScale.sm),
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      notifier.currentPage < notifier.totalPages
                                          ? () {
                                            _animationController.reset();
                                            _animationController.forward();
                                            notifier.goToPage(
                                              notifier.currentPage + 1,
                                            );
                                          }
                                          : null,
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _taglineHeader(BuildContext context) {
    return Text(
      "Laporan Masyarakat Tersedia",
      style: context.textStyle.onestBold(size: SizeScale.md),
    );
  }

  Row _columnListTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Nomor Registrasi".truncate(maxChars: 8),
          style: context.textStyle.onestBold(size: SizeScale.md),
        ),
        // Tanggal Pelaporan
        Text(
          "Tanggal Pelaporan".truncate(maxChars: 8),
          style: context.textStyle.onestBold(size: SizeScale.md),
        ),

        Text("Status", style: context.textStyle.onestBold(size: SizeScale.md)),
      ],
    );
  }

  SizedBox _searchBar(ResponsiveSizes responsive) =>
      SizedBox(height: responsive.space(SizeScale.md));

  FadeTransition _headerView(ResponsiveSizes responsive) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,

        // margin: EdgeInsets.symmetric(
        //   horizontal: responsive.space(SizeScale.md),
        //   vertical: responsive.space(SizeScale.sm),
        // ),
        padding: EdgeInsets.all(responsive.space(SizeScale.lg)),
        decoration: BoxDecoration(
          color: Color(0xFF79B2E1),
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
          image: DecorationImage(
            image: AssetImage("assets/man.png"),
            fit: BoxFit.contain,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pelaporan DPMDPPA",
                    style: context.textStyle.onestBold(
                      size: SizeScale.xl,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: responsive.space(SizeScale.sm)),
                  Text(
                    "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
                    style: context.textStyle.dmSansRegular(
                      size: SizeScale.md,
                      color: Colors.white,
                    ),
                  ),
                  // Text(
                  //   "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
                  //   style: context.textStyle.dmSansRegular(
                  //     size: SizeScale.md,
                  //     color: Colors.white,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),
            SizedBox(width: responsive.space(SizeScale.md)),
          ],
        ),
      ),
    );
  }

  void showLaporanDetailBottomSheet(
    BuildContext context,
    ListLaporanModel laporan,
    int index, {
    bool isRefreshing = false,
  }) async {
    if (laporan.useridMelihat == null) {
      showLoadingAnimated(context);
      try {
        await APIService.instance.updateStatusReportAsReadAdminService(
          accessToken: _userProvider.userToken,
          noRegistrasi: laporan.noRegistrasi,
        );

        final updatedLaporan = laporan.copyWith(
          useridMelihat: _userProvider.userId,
          waktuDilihat: DateTime.now().toIso8601String(),
        );

        _reportsNotifier.updateReportByIndex(
          index,
          status: updatedLaporan.status,
          useridMelihat: updatedLaporan.useridMelihat,
          waktuDilihat: updatedLaporan.waktuDilihat,
        );

        closeLoadingDialog(context);
        // Buka modal dengan data yang diperbarui
        showLaporanDetailBottomSheet(context, updatedLaporan, index);
      } catch (e) {
        closeLoadingDialog(context);
        context.toast.showError(
          "Gagal menandai laporan sebagai dilihat: ${e.toString()}",
        );
        print("Error: $e");
      }
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ReportDetailModal(
            laporan: laporan,
            isMe: _userProvider.userId == laporan.useridMelihat,
            onUpdate:
                () => showLaporanDetailBottomSheet(
                  context,
                  laporan,
                  index,
                  isRefreshing: true,
                ),
            onOpenDialog: (innerContext) {
              showDialog(
                context: innerContext,
                builder: (dialogContext) {
                  return ActionDialog(
                    laporan: laporan,
                    onStatusUpdated: (newStatus) async {
                      try {
                        print("INIII NILAI STATUSSSSSSSSSSSSSSS $newStatus");

                        if (newStatus == "Diproses") {
                          await APIService.instance
                              .updateStatusReportAsDoneAdminService(
                                accessToken: _userProvider.userToken,
                                noRegistrasi: laporan.noRegistrasi,
                                innerContext: innerContext,
                              );
                          _reportsNotifier.updateReportByIndex(
                            index,
                            status: newStatus,
                          );
                          // Perbarui status lokal di modal
                        } else if (newStatus == "Selesai") {
                          await APIService.instance
                              .updateStatusReportAsProcessAdminService(
                                accessToken: _userProvider.userToken,
                                noRegistrasi: laporan.noRegistrasi,
                                innerContext: innerContext,
                              );
                          _reportsNotifier.updateReportByIndex(
                            index,
                            status: newStatus,
                          );
                        }

                        Navigator.of(innerContext).pop();
                      } catch (e) {
                        innerContext.toast.showSuccess(
                          "Status berhasil diubah ke $newStatus",
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      );
    }
  }
}

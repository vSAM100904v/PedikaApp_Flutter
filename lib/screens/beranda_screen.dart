import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pa2_kelompok07/carousel/carousel_loading.dart';
import 'package:pa2_kelompok07/styles/color.dart';

import '../provider/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TextLogger {
  late var width = MediaQuery.sizeOf(context).width;
  late var height = MediaQuery.sizeOf(context).height;

  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    debugLog(
      "Usser ${userProvider.isLoggedIn ? " User telah login" : "user belum login"} ",
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColor.descColor,
                  ),
                ),
                Text(
                  userProvider.isLoggedIn
                      ? "${userProvider.user?.full_name}"
                      : "Guest",
                  style: TextStyle(fontSize: 16, color: AppColor.descColor),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<UserProvider>(
                  builder:
                      (context, provider, _) => Badge(
                        label: Text(provider.unreadCount.toString()),
                        isLabelVisible: provider.unreadCount > 0,
                        child: IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed:
                              () => Navigator.of(
                                context,
                              ).pushNamed('/notifikasi'),
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          const CarouselLoading(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        tooltip: 'Increment',
        onPressed: () async {
          const url = 'tel:081262135011';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: const Icon(Icons.call, color: Colors.white, size: 28),
      ),
    );
  }
}

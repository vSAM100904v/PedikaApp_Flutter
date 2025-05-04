import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/styles/color.dart';

import '../screens/beranda_screen.dart';
import '../screens/dpmdppa/report_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/appointment/appointment_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int initialIndex;
  final List<Widget> pages;

  const BottomNavigationWidget({
    Key? key,
    this.initialIndex = 0,
    this.pages = const <Widget>[
      HomePage(),
      ReportScreen(),
      SizedBox(),
      AppointmentPage(),
    ],
  }) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widget.pages.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        height: 85, // Increased height
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColor.primaryColor,
            unselectedItemColor: AppColor.darkGreen,
            selectedFontSize: 14, // Increased font size
            unselectedFontSize: 14, // Increased font size
            iconSize: 28, // Increased icon size
            items: const <BottomNavigationBarItem>[
              // 1. Beranda
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home_rounded),
                ),
                label: 'Beranda',
              ),

              // 2. Laporan
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.description_outlined),
                ),
                label: 'Laporan',
              ),

              // 3. Donasi
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.favorite_outline_rounded),
                ),
                label: 'Donasi',
              ),

              // 4. Janji Temu
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_today_outlined),
                ),
                label: 'Janji Temu',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

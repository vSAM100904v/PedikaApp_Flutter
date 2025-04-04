import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/screens/admin/pages/janjiTemu/janjitemubaru.dart';
import 'package:pa2_kelompok07/screens/admin/pages/janjiTemu/detailJanjiTemu.dart';
import 'package:pa2_kelompok07/screens/admin/pages/janjiTemu/halaman_janjiTemu.dart';

class JanjiTemu extends StatelessWidget {
  const JanjiTemu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Konten'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),

              // Tambahkan Konten
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JanjiTemuBaru(),
                    ),
                  );
                },
                child: const Text('Janjitemu'),
              ),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailJanjiTemu(),
                    ),
                  );
                },
                child: const Text('Detail Janji Temu'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HalamanJanjitemu(),
                    ),
                  );
                },
                child: const Text('Halaman Janji Temu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

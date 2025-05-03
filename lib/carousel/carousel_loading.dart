import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pa2_kelompok07/model/content_model.dart';
import 'package:pa2_kelompok07/model/event_model.dart';
import 'package:pa2_kelompok07/screens/event_detail_page.dart';
import '../screens/community_screen.dart';
import '../services/api_service.dart';

class CarouselLoading extends StatefulWidget {
  const CarouselLoading({super.key});

  @override
  _CarouselLoadingState createState() => _CarouselLoadingState();
}

class _CarouselLoadingState extends State<CarouselLoading> {
  Future<List<Content>>? futureContents;
  Future<List<Event>>? futureEvents;
  int _currentCarousel = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    futureContents = APIService().fetchContents();
    futureEvents = APIService().fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor =
        screenWidth < 600
            ? 1.0
            : screenWidth < 1200
            ? 2.0
            : 2.5;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB2D8B2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(5, 60, 25, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selamat datang",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Dinas Pemberdayaan Masyarakat Desa\nPerempuan dan Anak",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentCarousel == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildNavigateSection("Informasi dan Berita", scaleFactor),
            ),

            const SizedBox(height: 10),

            // Artikel Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<List<Content>>(
                future: futureContents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildHorizontalCarouselSkeleton();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return buildCarousel(snapshot.data!, scaleFactor);
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildNavigateSection("Event", scaleFactor),
            ),

            const SizedBox(height: 10),

            // Event List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<List<Event>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildEventListSkeleton();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return buildEventList(snapshot.data!);
                  } else {
                    return const Text('No events available');
                  }
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  CarouselSlider buildCarousel(List<Content> contents, double scaleFactor) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.9,
        autoPlay: true,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarousel = index;
          });
        },
      ),
      items:
          contents.map((content) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Image.network(
                        content.imageContent,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          content.judul,
                          style: TextStyle(
                            fontSize: 14 * scaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget buildNavigateSection(String title, double scaleFactor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CommunityPage()),
            );
          },
          child: Text(
            "Lihat semua",
            style: TextStyle(
              color: Colors.green,
              fontSize: 14 * scaleFactor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHorizontalCarouselSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget buildEventListSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder:
              (_, index) => Container(
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
        ),
      ),
    );
  }

  Widget buildEventList(List<Event> events) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(event: event),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      event.thumbnailEvent,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      event.namaEvent,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community Page")),
      body: const Center(child: Text("Halaman lengkap daftar konten / event")),
    );
  }
}

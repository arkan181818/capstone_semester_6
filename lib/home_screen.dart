import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../widgets/app_bottom_nav.dart';
import 'riwayat_screen.dart';
import 'detail_event_screen.dart';
import 'event_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());
    controller.setIndex(0);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "RunTrack",
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=3",
              ),
            ),
          ),
        ],
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.deepOrange,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SELAMAT PAGI",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "RUNNERS 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Icon(
                    Icons.directions_run,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),

            /// MENU
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  /// INFO EVENT
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DetailEventScreen(
                            image: "assets/images/event1.png",
                            title: "BSI Runfest",
                            price: "Rp 150.000",
                          ));
                    },
                    child: const MenuItem(
                      Icons.event,
                      "Info Event",
                    ),
                  ),

                  /// RIWAYAT
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const RiwayatScreen());
                    },
                    child: const MenuItem(
                      Icons.history,
                      "Riwayat",
                    ),
                  ),

                  /// PEMBAYARAN
                  const MenuItem(
                    Icons.payment,
                    "Pembayaran",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// TITLE
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Info & Berita Terbaru",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  /// LIHAT SEMUA
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const EventListScreen());
                    },
                    child: const Text(
                      "Lihat semua",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// EVENT LIST
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  EventCard(
                    image:
                        "assets/images/event1.png",
                    title: "BSI Runfest",
                    price: "Rp 150.000",
                  ),

                  EventCard(
                    image:
                        "assets/images/event2.png",
                    title:
                        "Tegal Fun Run",
                    price:
                        "Rp 200.000",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: AppBottomNav(),
    );
  }
}

/// ================= MENU =================
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuItem(
    this.icon,
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                Colors.orange.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Colors.orange,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// ================= EVENT CARD =================
class EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const EventCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// KLIK CARD
      onTap: () {
        Get.to(() => DetailEventScreen(
              image: image,
              title: title,
              price: price,
            ));
      },

      child: Container(
        width: 260,
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(20),
              ),

              child: Image.asset(
                image,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "Kota Tegal",
                        style: TextStyle(
                          color:
                              Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
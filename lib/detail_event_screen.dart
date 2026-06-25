import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'event_list_screen.dart';

class DetailEventScreen extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const DetailEventScreen({
    super.key,
    required this.image,
    required this.title,
    required this.price,
  });

  factory DetailEventScreen.fromArgs() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    return DetailEventScreen(
      image: args['image']?.toString() ?? 'assets/images/event1.png',
      title: args['title']?.toString() ?? 'RunTrack Event',
      price: args['price']?.toString() ?? 'Rp 0',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
            child: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          )
        ],
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              /// LINE
              Container(
                width: 40,
                height: 3,

                decoration: BoxDecoration(
                  color: Colors.orange,

                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Event Lari\nMendatang",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Temukan dan daftarkan dirimu di event lari terbaik",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              /// LIHAT SEMUA
              GestureDetector(
                onTap: () {
                  Get.to(() => const EventListScreen());
                },

                child: const Text(
                  "Lihat Semua →",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CARD
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(20),

                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// IMAGE
                    Stack(
                      children: [

                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),

                          child: Image.asset(
                            image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          top: 15,
                          right: 15,

                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.orange,

                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),

                            child: const Text(
                              "LIVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          /// DATE
                          Row(
                            children: [

                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color:
                                    Colors.grey[700],
                              ),

                              const SizedBox(width: 5),

                              Text(
                                "10 Juli 2026",
                                style: TextStyle(
                                  color:
                                      Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Icon(
                                Icons.access_time,
                                size: 14,
                                color:
                                    Colors.grey[700],
                              ),

                              const SizedBox(width: 5),

                              Text(
                                "06:00 WIB",
                                style: TextStyle(
                                  color:
                                      Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          /// TITLE
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// CATEGORY
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,

                            children: [

                              kategori(
                                  "5K Beginner"),

                              kategori(
                                  "10K Competitive"),

                              kategori(
                                  "Half Marathon"),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// PROGRESS
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              const Text(
                                "750 / 1.000 peserta",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),

                              Text(
                                "75%",
                                style: TextStyle(
                                  color:
                                      Colors.green[700],
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          LinearProgressIndicator(
                            value: 0.75,
                            minHeight: 6,

                            backgroundColor:
                                Colors.grey.shade300,

                            color: Colors.lightGreen,

                            borderRadius:
                                BorderRadius.circular(
                                    20),
                          ),

                          const SizedBox(height: 20),

                          /// PRICE + BUTTON
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(
                                    "MULAI DARI",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          Colors.grey[
                                              600],
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 5),

                                  Text(
                                    price,
                                    style:
                                        const TextStyle(
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),

                              ElevatedButton(
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      Colors.orange,

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 15,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                12),
                                  ),
                                ),

                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.payment,
                                    arguments: {
                                      'title': title,
                                      'price': price,
                                      'date': '30 Agustus 2026',
                                      'location': 'Alun-Alun Kota Tegal',
                                      'category': '10K Competitive Category',
                                    },
                                  );
                                },

                                child: const Text(
                                  "Daftar",
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offNamed(AppRoutes.home);
              break;
            case 1:
              Get.offNamed(AppRoutes.eventList);
              break;
            case 2:
              Get.offNamed(AppRoutes.scanner);
              break;
            case 3:
              Get.offNamed(AppRoutes.profile);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "EVENTS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "SCANNER",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "PROFILE",
          ),
        ],
      ),
    );
  }

  /// CATEGORY
  Widget kategori(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius:
            BorderRadius.circular(6),
      ),

      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }
}
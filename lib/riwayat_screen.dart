import 'package:flutter/material.dart';

/// ================= RIWAYAT SCREEN =================
class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f1ef),

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Riwayat Event",
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.brown),
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// TOTAL JARAK
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff2f2b2b),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOTAL JARAK",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),

                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.orange,
                        child: const Icon(
                          Icons.north_east,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "67.2",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " KM",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.orange,
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// INFO BOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  /// FINISH
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                          ),

                          SizedBox(height: 8),

                          Text(
                            "12\nFinish",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// MUSIM
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.brown,
                          ),

                          SizedBox(height: 8),

                          Text(
                            "2024\nMusim Ini",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  Text(
                    "Partisipasi Event",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "TERBARU",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// EVENT CARD
            const EventCard(
              title: "Tegal Night Run 10K",
              location: "Alun-Alun Tegal",
              time: "00:54:12",
            ),

            const EventCard(
              title: "Independence Run",
              location: "Kota Tegal",
              time: "00:22:45",
            ),

            const SizedBox(height: 20),

            /// BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text("Tampilkan Event Tahun Lalu"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Event",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

/// ================= EVENT CARD =================
class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String time;

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LOGO
          Row(
            children: const [

              Icon(
                Icons.directions_run,
                color: Colors.orange,
              ),

              SizedBox(width: 6),

              Text(
                'RUNTRACK',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// TITLE EVENT
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 14),

          /// LOCATION & TIME
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [

                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.brown,
                  ),

                  const SizedBox(width: 4),

                  Text(location),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  const Text(
                    'WAKTU',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 11,
                    ),
                  ),

                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../widgets/app_bottom_nav.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import 'detail_event_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());
    controller.setIndex(1);
    
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

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
              Icons.menu,
              color: Colors.black,
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// TITLE
              const Text(
                "Event Lari\nMendatang",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Temukan dan daftarkan dirimu di event lari terbaik",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 20),

              /// SEARCH
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: "Cari event...",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// FILTER
              Row(
                children: [
                  Expanded(
                    child: dropdownBox("Semua Lokasi"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: dropdownBox("Tanggal Terdekat"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: dropdownBox("Semua Kategori"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5b7300),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        "Cari",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// EVENT CARD
              FutureBuilder<List<EventModel>>(
                future: EventService.getUserEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }
                  final events = snapshot.data ?? [];
                  if (events.isEmpty) {
                    return const Center(child: Text('Tidak ada event saat ini'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => DetailEventScreen(
                                eventId: event.id,
                                image: event.bannerUrl ?? 'assets/images/event1.png',
                                title: event.namaEvent,
                                price: event.harga.isNotEmpty ? 'Rp ${event.harga}' : 'Gratis',
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: event.bannerUrl != null
                                        ? Image.network(
                                            event.bannerUrl!,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              height: 200,
                                              color: Colors.grey[200],
                                              child: const Center(child: Icon(Icons.broken_image)),
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/event1.png',
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Live Soon',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.namaEvent,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    infoRow(Icons.calendar_today, event.tanggal.toLocal().toString().split(' ').first),
                                    infoRow(Icons.access_time, '06:00 WIB'),
                                    infoRow(Icons.location_on, event.lokasi),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        chip('10K Competitive'),
                                        chip('5K Fun Run'),
                                        chip('Half Marathon'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNav(),
    );
  }

  Widget dropdownBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: text,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: text,
              child: Text(text),
            ),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
          )
        ],
      ),
    );
  }
}

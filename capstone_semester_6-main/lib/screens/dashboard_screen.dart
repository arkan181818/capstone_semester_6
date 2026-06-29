import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_chart.dart';
import '../widgets/dashboard_event_card.dart';
import '../widgets/dashboard_registration_card.dart';
import '../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'RunTrack EO',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
            onPressed: () {
              Get.toNamed('/notification');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.grey),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.profile);
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DASHBOARD OVERVIEW HEADER
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Welcome back, Admin. Here\'s your event performance today.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// CREATE NEW EVENT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.eoEventForm);
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create New Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// STATISTICS CARDS
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Obx(() => DashboardStatCard(
                      icon: Icons.event,
                      title: 'TOTAL EVENT',
                      value: controller.totalEvents.toString(),
                      change: '+',
                      changeColor: Colors.green,
                    )),
                Obx(() => DashboardStatCard(
                      icon: Icons.people,
                      title: 'TOTAL PESERTA',
                      value: controller.totalParticipants.toString(),
                      change: '-',
                      changeColor: Colors.green,
                    )),
                Obx(() => DashboardStatCard(
                      icon: Icons.attach_money,
                      title: 'TOTAL PENDAPATAN',
                      value: controller.totalRevenue.value,
                      change: '-',
                      changeColor: Colors.orange,
                    )),
                Obx(() => DashboardStatCard(
                      icon: Icons.trending_up,
                      title: 'LIVE EVENTS',
                      value: controller.liveEvents.toString(),
                      change: '+',
                      changeColor: Colors.green,
                    )),
              ],
            ),
            const SizedBox(height: 30),

            /// EVENT AKTIF CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a3a52),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Live Now',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'EVENT AKTIF',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                            controller.liveEvents.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Colors.orange,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// CHART SECTION
            const Text(
              'Pertumbuhan Peserta & Pendapatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last 30 days',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Last 30 Days',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const DashboardChart(),
            const SizedBox(height: 30),

            /// EVENT TERDEKAT SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Event Terdekat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.eoEventList);
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Obx(() {
              final events = controller.events;
              if (events.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No upcoming events'),
                );
              }
              final months = [
                'JAN',
                'FEB',
                'MAR',
                'APR',
                'MAY',
                'JUN',
                'JUL',
                'AUG',
                'SEP',
                'OCT',
                'NOV',
                'DES'
              ];
              return Column(
                children: events.take(3).map((e) {
                  final day = e.tanggal.day.toString().padLeft(2, '0');
                  final month = months[e.tanggal.month - 1];
                  return Column(
                    children: [
                      DashboardEventCard(
                        day: day,
                        month: month,
                        title: e.namaEvent,
                        location: e.lokasi,
                        icon: Icons.location_on,
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 30),

            /// PENDAFTARAN TERBARU SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pendaftaran Terbaru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Export CSV',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// TABLE HEADER
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'PARTICIPANT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'EVENT NAME',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// TABLE ROWS
            // Registration data not available from current API; show placeholder
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text('Registration data not available'),
            ),
            
            const SizedBox(height: 30),

            /// BOTTOM NAVIGATION SPACE
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

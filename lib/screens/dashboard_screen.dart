import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_chart.dart';
import '../widgets/dashboard_event_card.dart';
import '../widgets/dashboard_registration_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Get.toNamed('/profile');
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
                onPressed: () {},
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
                DashboardStatCard(
                  icon: Icons.event,
                  title: 'TOTAL EVENT',
                  value: '42',
                  change: '+4 this month',
                  changeColor: Colors.green,
                ),
                DashboardStatCard(
                  icon: Icons.people,
                  title: 'TOTAL PESERTA',
                  value: '8,241',
                  change: '+12% vs last week',
                  changeColor: Colors.green,
                ),
                DashboardStatCard(
                  icon: Icons.attach_money,
                  title: 'TOTAL PENDAPATAN',
                  value: 'Rp 1.2M',
                  change: 'Record high',
                  changeColor: Colors.orange,
                ),
                DashboardStatCard(
                  icon: Icons.trending_up,
                  title: 'CONVERSION RATE',
                  value: '68%',
                  change: '+5% this month',
                  changeColor: Colors.green,
                ),
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
                      const SizedBox(height: 12),
                      const Text(
                        'EVENT AKTIF',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  onPressed: () {},
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
            DashboardEventCard(
              day: '28',
              month: 'NOV',
              title: 'Jakarta City Marathon 2023',
              location: 'GBK, Jakarta',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 12),
            DashboardEventCard(
              day: '05',
              month: 'DES',
              title: 'Borobudur 10K Run',
              location: 'Magelang, Jawa Tengah',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 12),
            DashboardEventCard(
              day: '12',
              month: 'DES',
              title: 'Sunset Beach Run',
              location: 'Bali, Indonesia',
              icon: Icons.location_on,
            ),
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
            DashboardRegistrationCard(
                participant: 'AS', name: 'Andi Saputra', email: 'andi.saputra@gmail.com', event: 'Jakarta Marathon'),
            DashboardRegistrationCard(
                participant: 'IW', name: 'Rina Wijaya', email: 'rina.wijaya@gmail.com', event: 'Borobudur 10K Run'),
            DashboardRegistrationCard(
                participant: 'DP', name: 'Devi Pratama', email: 'devi.pratama@gmail.com', event: 'Sunset Beach Run'),
            
            const SizedBox(height: 30),

            /// BOTTOM NAVIGATION SPACE
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_chart.dart';
import '../widgets/dashboard_event_card.dart';
import '../widgets/dashboard_registration_card.dart';
import '../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import '../config/api_config.dart';
import '../services/event_service.dart';
import '../widgets/eo_bottom_nav.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<ProfileModel> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = ProfileService.fetchProfile();
  }

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
              child: FutureBuilder<ProfileModel>(
                future: profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final profile = snapshot.data!;
                    final imageUrl = profile.imageUrl;
                    if (imageUrl.isNotEmpty) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                      );
                    }
                  }
                  return const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  );
                },
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
            const SizedBox(height: 25),

            /// QUICK ACTIONS MENU
            const Text(
              'Menu Operasional EO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfffdf2e9),
                      foregroundColor: const Color(0xffa04000),
                      side: const BorderSide(color: Color(0xfff5cba7)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Get.offAllNamed(AppRoutes.scanner, arguments: {'mode': 'qr'}),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text(
                      'Scan Racepack',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffebf5fb),
                      foregroundColor: const Color(0xff1f618d),
                      side: const BorderSide(color: Color(0xffa9cce3)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Get.offAllNamed(AppRoutes.scanner, arguments: {'mode': 'face'}),
                    icon: const Icon(Icons.face),
                    label: const Text(
                      'Scan Wajah Acara',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
            Obx(() {
              final regs = controller.registrations;
              if (regs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('No recent registrations'),
                );
              }
              return Column(
                children: regs.map((r) {
                  return GestureDetector(
                    onTap: () async {
                      // show detail dialog with image and actions
                      final proofUrl = r.buktiPembayaran != null && r.buktiPembayaran!.isNotEmpty
                          ? (r.buktiPembayaran!.startsWith('http') ? r.buktiPembayaran! : '${ApiConfig.baseUrl}/${r.buktiPembayaran!.replaceAll('\\', '/')}')
                          : null;

                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Detail Pendaftaran - ${r.namaPeserta}'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kategori: ${r.kategoriLomba}'),
                                const SizedBox(height: 8),
                                Text('Email: ${r.emailPeserta}'),
                                const SizedBox(height: 8),
                                Text('Status: ${r.status}'),
                                const SizedBox(height: 12),
                                const Text(
                                  'Bukti Pembayaran:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                if (proofUrl != null)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        proofUrl,
                                        fit: BoxFit.contain,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                        errorBuilder: (c, e, s) => Container(
                                          padding: const EdgeInsets.all(16),
                                          width: double.infinity,
                                          color: Colors.red[50],
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.error_outline, color: Colors.red[700]),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Gagal memuat gambar. Silakan periksa URL:\n$proofUrl',
                                                style: TextStyle(color: Colors.red[700], fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  const Text(
                                    'Belum mengupload bukti pembayaran',
                                    style: TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                final ok = await EventService.rejectRegistration(r.id, "Pembayaran ditolak oleh EO");
                                if (ok) {
                                  Get.snackbar('Sukses', 'Pembayaran ditolak', snackPosition: SnackPosition.BOTTOM);
                                  await controller.loadData();
                                } else {
                                  Get.snackbar('Gagal', 'Gagal menolak pembayaran', snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                              child: const Text('Reject'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                final ok = await EventService.approveRegistration(r.id);
                                if (ok) {
                                  Get.snackbar('Sukses', 'Pembayaran disetujui', snackPosition: SnackPosition.BOTTOM);
                                  await controller.loadData();
                                } else {
                                  Get.snackbar('Gagal', 'Gagal menyetujui pembayaran', snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                              child: const Text('Approve'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        DashboardRegistrationCard(
                          participant: r.namaPeserta.isNotEmpty ? r.namaPeserta[0].toUpperCase() : '?',
                          name: r.namaPeserta,
                          email: r.emailPeserta,
                          event: controller.events.where((ev) => ev.id == r.eventId).isNotEmpty
                              ? controller.events.where((ev) => ev.id == r.eventId).first.namaEvent
                              : 'Event ${r.eventId}',
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            
            const SizedBox(height: 30),

            /// BOTTOM NAVIGATION SPACE
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: EOBottomNav(),
    );
  }
}

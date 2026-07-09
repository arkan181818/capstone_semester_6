import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/eo_bottom_nav.dart';
import '../controllers/eo_bottom_nav_controller.dart';
import '../services/event_service.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  late Future<List<Map<String, dynamic>>> historyFuture;

  @override
  void initState() {
    super.initState();
    final navController = Get.put(EOBottomNavController());
    navController.setIndex(3);
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      historyFuture = EventService.getScanHistory();
    });
  }

  String _formatDateTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final date = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
      final time = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      return "$date, $time";
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Riwayat Scan Racepack',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.orange),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Belum Ada Riwayat Scan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Peserta yang sudah berhasil di-scan oleh EO untuk pemanggilan racepack akan muncul di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadHistory();
              await historyFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = list[index];


                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Colored Indicator or Badge
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['nama_peserta'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.confirmation_number_outlined, size: 16, color: Colors.orange),
                                  const SizedBox(width: 6),
                                  Text(
                                    item['bib_number'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Divider(color: Colors.grey[200]),
                              const SizedBox(height: 4),
                              Text(
                                'Event: ${item['nama_event'] ?? '-'}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kategori: ${item['kategori_lomba'] ?? '-'}',
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (item['status_kehadiran'] == 'hadir') ...[
                                          Row(
                                            children: [
                                              const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.blue),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Racepack diambil: ${_formatDateTime(item['scan_at'])}',
                                                style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                        if (item['status_kehadiran_event'] == 'hadir') ...[
                                          Row(
                                            children: [
                                              const Icon(Icons.portrait_outlined, size: 14, color: Colors.green),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Check-In Event: ${_formatDateTime(item['checkin_event_at'])}',
                                                style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
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
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: EOBottomNav(),
    );
  }
}

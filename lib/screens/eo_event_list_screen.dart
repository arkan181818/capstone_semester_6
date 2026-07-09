import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/event_model.dart';
import '../services/event_service.dart';
import '../routes/app_routes.dart';
import '../widgets/eo_bottom_nav.dart';

class EOEventListScreen extends StatefulWidget {
  const EOEventListScreen({super.key});

  @override
  State<EOEventListScreen> createState() => _EOEventListScreenState();
}

class _EOEventListScreenState extends State<EOEventListScreen> {
  late Future<List<EventModel>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = EventService.getEOEvents();
  }

  void _refreshEvents() {
    setState(() {
      eventsFuture = EventService.getEOEvents();
    });
  }

  Future<void> _deleteEvent(int eventId) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Hapus Event',
      middleText: 'Apakah Anda yakin ingin menghapus event ini?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed != true) return;

    final result = await EventService.deleteEvent(eventId);
    if (result['status'] == 200) {
      Get.snackbar('Sukses', result['data']['msg'] ?? 'Event dihapus');
      _refreshEvents();
    } else {
      Get.snackbar('Error', result['data']['msg'] ?? 'Gagal menghapus event');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Event EO'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<EventModel>>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final events = snapshot.data ?? [];
          if (events.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event, size: 80, color: Colors.orange),
                    const SizedBox(height: 20),
                    const Text(
                      'Belum ada event EO. Buat event baru untuk mulai mengisi data.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Get.toNamed(AppRoutes.eoEventForm);
                        if (result == true) {
                          _refreshEvents();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Buat Event Baru'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshEvents();
              await eventsFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.bannerUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: Image.network(
                            event.bannerUrl!,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 170,
                              color: Colors.grey[200],
                              child: const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.namaEvent,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(event.lokasi),
                            const SizedBox(height: 8),
                            Text('Tanggal: ${event.tanggal.toLocal().toString().split(' ')[0]}'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  backgroundColor: event.status == 'aktif'
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  label: Text(event.status.toUpperCase()),
                                ),
                                const SizedBox(width: 8),
                                Text('Kuota: ${event.kuota}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final result = await Get.toNamed(
                                        AppRoutes.eoEventForm,
                                        arguments: event.toJson(),
                                      );
                                      if (result == true) {
                                        _refreshEvents();
                                      }
                                    },
                                    child: const Text('Edit'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () => _deleteEvent(event.id),
                                    child: const Text('Hapus'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.eoEventForm);
          if (result == true) {
            _refreshEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: EOBottomNav(),
    );
  }
}

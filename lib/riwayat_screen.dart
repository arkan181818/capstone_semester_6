import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/event_service.dart';
import 'models/registration_model.dart';
import 'config/api_config.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late Future<List<RegistrationModel>> riwayatFuture;

  @override
  void initState() {
    super.initState();
    riwayatFuture = EventService.getMyRegistrations();
  }

  void _refreshData() {
    setState(() {
      riwayatFuture = EventService.getMyRegistrations();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'waiting_verification':
        return Colors.amber[800]!;
      case 'pending_payment':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'Paid (Lunas)';
      case 'waiting_verification':
        return 'Waiting Verification';
      case 'pending_payment':
        return 'Pending Payment';
      case 'rejected':
        return 'Rejected (Ditolak)';
      default:
        return status;
    }
  }

  void _showDetailBottomSheet(BuildContext context, RegistrationModel reg) {
    final bannerUrl = reg.banner != null && reg.banner!.isNotEmpty
        ? (reg.banner!.startsWith('http') ? reg.banner! : '${ApiConfig.baseUrl}/${reg.banner!.replaceAll('\\', '/')}')
        : null;

    final qrData = reg.bibNumber ?? 'REG-${reg.id}';
    final qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$qrData';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Detail Pendaftaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const Divider(height: 25),

              // Event Card Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bannerUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        bannerUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event, color: Colors.orange),
                    ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reg.namaEvent ?? 'Nama Event',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                reg.lokasi ?? 'Lokasi',
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              reg.tanggalEvent != null ? reg.tanggalEvent!.split(' ')[0] : 'Tanggal',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),

              // Detail fields
              _buildDetailItem('Nama Peserta', reg.namaPeserta),
              _buildDetailItem('Email', reg.emailPeserta),
              _buildDetailItem('Nama BIB', reg.namaBib),
              _buildDetailItem('Kategori Lomba', reg.kategoriLomba),
              _buildDetailItem('Status Pendaftaran', _getStatusText(reg.status), color: _getStatusColor(reg.status)),
              if (reg.status == 'paid') ...[
                _buildDetailItem(
                  'Status Racepack',
                  reg.statusKehadiran == 'hadir' ? 'Sudah Diambil (Checked In)' : 'Belum Diambil',
                  color: reg.statusKehadiran == 'hadir' ? Colors.green : Colors.orange,
                ),
                if (reg.statusKehadiran == 'hadir' && reg.scanAt != null)
                  _buildDetailItem(
                    'Waktu Pengambilan',
                    _formatDateTime(reg.scanAt),
                  ),
                _buildDetailItem(
                  'Check-In Event',
                  reg.statusKehadiranEvent == 'hadir' ? 'Sudah Check-In (Hadir)' : 'Belum Check-In',
                  color: reg.statusKehadiranEvent == 'hadir' ? Colors.green : Colors.red,
                ),
                if (reg.statusKehadiranEvent == 'hadir' && reg.checkinEventAt != null)
                  _buildDetailItem(
                    'Waktu Check-In Event',
                    _formatDateTime(reg.checkinEventAt),
                  ),
              ],

              if (reg.status == 'rejected' && reg.rejectReason != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alasan Penolakan:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reg.rejectReason!,
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ],
                  ),
                ),
              ],

              // Show QR code and Bib number only if paid
              if (reg.status == 'paid') ...[
                const Divider(height: 30),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'NOMOR BIB ANDA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reg.bibNumber ?? '-',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Image.network(
                          qrUrl,
                          width: 150,
                          height: 150,
                          loadingBuilder: (c, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              width: 150,
                              height: 150,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (c, e, s) => Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey[100],
                            child: const Center(
                              child: Text(
                                'Gagal memuat QR',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tunjukkan QR Code di atas saat pengambilan racepack.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (reg.status == 'pending_payment') ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Silakan lakukan pembayaran dan unggah bukti transfer di detail event untuk menyelesaikan pendaftaran Anda.',
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                ),
              ] else if (reg.status == 'waiting_verification') ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    border: Border.all(color: Colors.amber[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Bukti pembayaran Anda telah diunggah dan sedang dalam proses verifikasi oleh Event Organizer.',
                    style: TextStyle(color: Colors.amber, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.grey[800],
            ),
          ),
        ],
      ),
    );
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
      backgroundColor: const Color(0xfff5f1ef),
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
      body: FutureBuilder<List<RegistrationModel>>(
        future: riwayatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final regs = snapshot.data ?? [];
          if (regs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 80, color: Colors.grey),
                    const SizedBox(height: 20),
                    Text(
                      'Belum ada riwayat pendaftaran event.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
              await riwayatFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: regs.length,
              itemBuilder: (context, index) {
                final reg = regs[index];
                final bannerUrl = reg.banner != null && reg.banner!.isNotEmpty
                    ? (reg.banner!.startsWith('http') ? reg.banner! : '${ApiConfig.baseUrl}/${reg.banner!.replaceAll('\\', '/')}')
                    : null;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: InkWell(
                    onTap: () => _showDetailBottomSheet(context, reg),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (bannerUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    bannerUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.event, color: Colors.orange),
                                ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reg.namaEvent ?? 'Event',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Kategori: ${reg.kategoriLomba}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tanggal: ${reg.tanggalEvent != null ? reg.tanggalEvent!.split(' ')[0] : '-'}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(reg.status).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getStatusText(reg.status),
                                  style: TextStyle(
                                    color: _getStatusColor(reg.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              if (reg.status == 'paid' && reg.bibNumber != null)
                                Text(
                                  'BIB: ${reg.bibNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                            ],
                          ),
                          if (reg.status == 'paid') ...[
                            const SizedBox(height: 8),
                            // Racepack status row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      reg.statusKehadiran == 'hadir' ? Icons.check_circle : Icons.hourglass_empty,
                                      size: 16,
                                      color: reg.statusKehadiran == 'hadir' ? Colors.green : Colors.orange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      reg.statusKehadiran == 'hadir' ? 'Racepack sudah diambil' : 'Racepack belum diambil',
                                      style: TextStyle(
                                        color: reg.statusKehadiran == 'hadir' ? Colors.green[800] : Colors.orange[800],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (reg.statusKehadiran == 'hadir' && reg.scanAt != null)
                                  Text(
                                    _formatDateTime(reg.scanAt),
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Event Check-in status row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      reg.statusKehadiranEvent == 'hadir' ? Icons.check_circle : Icons.portrait_outlined,
                                      size: 16,
                                      color: reg.statusKehadiranEvent == 'hadir' ? Colors.green : Colors.red,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      reg.statusKehadiranEvent == 'hadir' ? 'Check-In Event: Hadir' : 'Check-In Event: Belum Hadir',
                                      style: TextStyle(
                                        color: reg.statusKehadiranEvent == 'hadir' ? Colors.green[800] : Colors.red[850],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (reg.statusKehadiranEvent == 'hadir' && reg.checkinEventAt != null)
                                  Text(
                                    _formatDateTime(reg.checkinEventAt),
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Notifikasi',
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'PENGINGAT EVENT LARI KAMU',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.grey),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              notificationCard(
                icon: Icons.directions_run,
                iconBg: const Color(0xFFFFE5DC),
                iconColor: Colors.deepOrange,
                title: 'Reminder Event Lari',
                subtitle:
                    'Tegal Bhari Run 2026\nEvent lari akan dilaksanakan pada 10 Juli 2026, jangan sampai terlewat!',
                time: 'Baru Saja',
                date: '10 JULI 2026',
                lineColor: Colors.deepOrange,
              ),

              const SizedBox(height: 14),

              notificationCard(
                icon: Icons.location_on_outlined,
                iconBg: const Color(0xFFE8F5D7),
                iconColor: Colors.green,
                title: 'Pendaftaran Berhasil',
                subtitle:
                    'Semarang Night Fun Run\nSelamat! Slot kamu telah diamankan. Segera ambil race pack pada lokasi yang ditentukan.',
                time: '2 Jam Lalu',
                date: '08.00P-09.45',
                lineColor: Colors.green,
              ),

              const SizedBox(height: 14),

              notificationCard(
                icon: Icons.emoji_events_outlined,
                iconBg: const Color(0xFFDDF7F8),
                iconColor: Colors.teal,
                title: 'Hasil Lomba Tersedia',
                subtitle:
                    'Pekalongan 10K City Run\nHasil resmi lomba lari kemarin sudah dapat dilihat, cek peringkat dan catatan waktu kamu sekarang!',
                time: 'Kemarin',
                date: 'LIHAT LEADERBOARD',
                lineColor: Colors.teal,
              ),

              const SizedBox(height: 18),

              promoCard(),

              const SizedBox(height: 18),

              activityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required String date,
    required Color lineColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 140,
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: iconColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: Colors.black54,
                                height: 1.4,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              date,
                              style: TextStyle(
                                color: lineColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget promoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'OFFER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Early Bird: Tegal Half Marathon',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dapatkan potongan 30% untuk 100 pendaftar pertama hari ini.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'DAFTAR SEKARANG',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget activityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: const Icon(Icons.directions_run, color: Colors.deepOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Aktivitas Klub',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      '3 Menit Lalu',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Tegal Runner Club baru saja menambahkan jadwal lari pagi baru.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '“Minggu Pagi Ceria di Pantai Ayer Indah”',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
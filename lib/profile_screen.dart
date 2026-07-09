import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/profile_model.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';
import 'routes/app_routes.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  late Future<ProfileModel> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = ProfileService.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<ProfileModel>(
        future: profileFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final user = snapshot.data!;

          Widget buildPaymentStatus() {
            final status = user.registrationStatus;
            
            if (status == 'paid') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: const Text('Status Pembayaran'),
                    subtitle: const Text('Pembayaran Disetujui (Paid)'),
                  ),
                  if (user.bibNumber != null && user.bibNumber!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nomor Bib', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(user.bibNumber!, style: const TextStyle(fontSize: 18, color: Colors.orange)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            }

            if (status == 'waiting_verification') {
              return ListTile(
                leading: const Icon(Icons.hourglass_top, color: Colors.amber),
                title: const Text('Status Pembayaran'),
                subtitle: const Text('Menunggu verifikasi oleh EO'),
              );
            }

            if (status == 'pending_payment') {
              return ListTile(
                leading: const Icon(Icons.payment, color: Colors.blue),
                title: const Text('Status Pembayaran'),
                subtitle: const Text('Menunggu Pembayaran'),
              );
            }

            if (status == 'rejected') {
              return ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Status Pembayaran'),
                subtitle: const Text('Pembayaran Ditolak (Rejected)'),
              );
            }

            // status == null -> unknown/no payment
            return ListTile(
              leading: const Icon(Icons.payment, color: Colors.grey),
              title: const Text('Status Pembayaran'),
              subtitle: const Text('Belum ada riwayat pendaftaran'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            user.imageUrl.isNotEmpty
                                ? NetworkImage(user.imageUrl)
                                : null,
                        child: user.imageUrl.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text("Nama"),
                        subtitle: Text(user.nama),
                      ),
                      ListTile(
                        title: const Text("Username"),
                        subtitle: Text(user.username),
                      ),
                      ListTile(
                        title: const Text("Email"),
                        subtitle: Text(user.email),
                      ),
                      ListTile(
                        title: const Text("No HP"),
                        subtitle: Text(
                          user.nohp ?? "-",
                        ),
                      ),
                      ListTile(
                        title: const Text("Alamat"),
                        subtitle: Text(
                          user.alamat ?? "-",
                        ),
                      ),

                      const SizedBox(height: 12),
                      // Payment status / bib
                      buildPaymentStatus(),

                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.history),
                    label: const Text("Riwayat Pendaftaran"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Get.toNamed(AppRoutes.riwayat);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profil"),
                    onPressed: () async {
                      final result = await Get.toNamed(AppRoutes.editProfile);
                      if (result == true) {
                        setState(() {
                          profileFuture = ProfileService.fetchProfile();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                    onPressed: () {
                      AuthService.accessToken = null;
                      Get.offAllNamed(AppRoutes.login);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
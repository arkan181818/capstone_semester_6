import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/profile_model.dart';
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : null,
                  child: user.imageUrl.isEmpty
                      ? const Icon(Icons.person,size: 50)
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

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Edit Profil",
                    ),
                    onPressed: () async {

                      final result =
                          await Get.toNamed(
                        AppRoutes.editProfile,
                      );

                      if (result == true) {
                        setState(() {
                          profileFuture =
                              ProfileService
                                  .fetchProfile();
                        });
                      }
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
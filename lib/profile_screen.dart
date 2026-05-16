import 'package:flutter/material.dart';
import 'notification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f1ef),

      /// APPBAR
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
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: Colors.grey),
          ),
        ],
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// FOTO PROFILE
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.orange.shade100,
              backgroundImage: const AssetImage("assets/images/profile.png"),
            ),

            const SizedBox(height: 12),

            /// NAMA
            const Text(
              "Tegal Runner",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            /// LOKASI
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  "Kota Tegal, Central Java",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// STATISTIK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  statCard("42.5km", "TOTAL DISTANCE"),

                  const SizedBox(width: 10),

                  statCard("14", "RACES"),

                  const SizedBox(width: 10),

                  statCard("12", "MEDALS"),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// INFORMASI AKUN
            sectionTitle("INFORMASI AKUN"),

            infoTile(
              Icons.email_outlined,
              "EMAIL",
              "runner@example.com",
            ),

            infoTile(
              Icons.phone_outlined,
              "NOMOR TELEPON",
              "+62 812 3456 7890",
            ),

            infoTile(
              Icons.person_outline,
              "JENIS KELAMIN",
              "Laki-laki",
            ),

            infoTile(
              Icons.location_on_outlined,
              "ALAMAT",
              "Jl. Pancasila, Kota Tegal",
            ),

            const SizedBox(height: 20),

            /// ACCOUNT SETTINGS
            sectionTitle("ACCOUNT SETTINGS"),

            settingTile(
              context,
              Icons.person_outline,
              "Edit Profile",
            ),

            /// NOTIFICATION BUTTON
            settingTile(
              context,
              Icons.notifications_none,
              "Notifications",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Events",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// ================= STAT CARD =================
  static Expanded statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SECTION TITLE =================
  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  /// ================= INFO TILE =================
  static Widget infoTile(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffe6e6e6)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SETTING TILE =================
  static Widget settingTile(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffe6e6e6)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class RunTrackScreen extends StatelessWidget {
  const RunTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A2A66), Color(0xFFFF7A00)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                /// FINISH
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "FINISH",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// TITLE
                const Text(
                  "RUNTRACK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGO
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                ),

                const SizedBox(height: 20),

                /// NAME
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Run",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "Track",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Smart running event management",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                /// BUTTON (SUDAH ADA NAVIGASI)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    child: const Text(
                      "MULAI SEKARANG →",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// STATS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    StatItem("12k+", "Pelari"),
                    StatItem("450", "Event"),
                    StatItem("TGL", "Wilayah"),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// WIDGET STAT
class StatItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const StatItem(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
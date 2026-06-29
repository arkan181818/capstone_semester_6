import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../routes/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          controller.setIndex(index);

          /// HOME
          if (index == 0) {
            Get.toNamed(AppRoutes.home);
          }

          /// EVENT
          if (index == 1) {
            Get.toNamed(AppRoutes.eventList);
          }

          /// SCANNER
          if (index == 2) {
            Get.toNamed(AppRoutes.scanner);
          }

          /// PROFILE
          if (index == 3) {
            Get.toNamed(AppRoutes.profile);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Event",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

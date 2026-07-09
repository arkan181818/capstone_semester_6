import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/eo_bottom_nav_controller.dart';
import '../routes/app_routes.dart';

class EOBottomNav extends StatelessWidget {
  final EOBottomNavController controller = Get.put(EOBottomNavController());

  EOBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    controller.updateIndexBasedOnRoute();
    return Obx(
      () => BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          if (controller.currentIndex.value == index) return;
          controller.setIndex(index);

          if (index == 0) {
            Get.offAllNamed(AppRoutes.dashboard);
          } else if (index == 1) {
            Get.offAllNamed(AppRoutes.eoEventList);
          } else if (index == 2) {
            Get.offAllNamed(AppRoutes.scanner);
          } else if (index == 3) {
            Get.offAllNamed(AppRoutes.riwayatScan);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
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
            icon: Icon(Icons.history),
            label: "Riwayat",
          ),
        ],
      ),
    );
  }
}

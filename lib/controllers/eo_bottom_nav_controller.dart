import 'package:get/get.dart';
import '../routes/app_routes.dart';

class EOBottomNavController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateIndexBasedOnRoute();
  }

  void setIndex(int index) {
    currentIndex.value = index;
  }

  void updateIndexBasedOnRoute() {
    String? currentRoute = Get.currentRoute;
    
    if (currentRoute == AppRoutes.dashboard) {
      currentIndex.value = 0;
    } else if (currentRoute == AppRoutes.eoEventList) {
      currentIndex.value = 1;
    } else if (currentRoute == AppRoutes.scanner) {
      currentIndex.value = 2;
    } else if (currentRoute == AppRoutes.riwayatScan) {
      currentIndex.value = 3;
    }
  }
}

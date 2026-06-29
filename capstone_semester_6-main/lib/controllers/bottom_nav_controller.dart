import 'package:get/get.dart';
import '../routes/app_routes.dart';

class BottomNavController extends GetxController {
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
    
    if (currentRoute == AppRoutes.home) {
      currentIndex.value = 0;
    } else if (currentRoute == AppRoutes.eventList) {
      currentIndex.value = 1;
    } else if (currentRoute == AppRoutes.scanner) {
      currentIndex.value = 2;
    } else if (currentRoute == AppRoutes.profile) {
      currentIndex.value = 3;
    }
  }
}

import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt currentIndex = 0.obs;

  void setIndex(int index) {
    currentIndex.value = index;
  }
}

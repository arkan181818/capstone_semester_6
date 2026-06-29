import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isChecked = false.obs;

  void toggleChecked(bool value) {
    isChecked.value = value;
  }
}

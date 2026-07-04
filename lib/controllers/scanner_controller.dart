import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController();
  RxBool isFlashOn = false.obs;

  Future<void> toggleFlash() async {
    await cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}

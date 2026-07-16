import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/event_service.dart';
import 'package:image_picker/image_picker.dart';

class FaceScanSimulationScreen extends StatefulWidget {
  const FaceScanSimulationScreen({super.key});

  @override
  State<FaceScanSimulationScreen> createState() => _FaceScanSimulationScreenState();
}

class _FaceScanSimulationScreenState extends State<FaceScanSimulationScreen>
    with SingleTickerProviderStateMixin {
  late final bool isDirect;
  int? registrationId;
  String participantName = "Mencari...";
  String? selfieUrl;
  
  late final MobileScannerController controller;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  bool isFlashOn = false;
  bool isCompleted = false;
  bool isError = false;
  String statusMessage = "Posisikan wajah peserta di dalam area scan";

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    final args = Get.arguments as Map<String, dynamic>?;
    isDirect = args == null || args['direct'] == true;

    if (!isDirect && args != null) {
      registrationId = args['registration_id'] as int?;
      participantName = args['nama_peserta'] as String? ?? "Mencari...";
      selfieUrl = args['scan_wajah'] as String?;
    }

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start simulation check-in
    _startFaceScanning();
  }

  Future<void> _startFaceScanning() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    setState(() {
      statusMessage = isDirect ? "Mendeteksi wajah..." : "Mencocokkan dengan foto pendaftaran...";
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    
    if (isDirect) {
      final match = await EventService.matchFace();
      if (!mounted) return;

      if (match != null) {
        setState(() {
          isCompleted = true;
          registrationId = match['registration_id'] as int?;
          participantName = match['nama_peserta'] as String? ?? "-";
          selfieUrl = match['scan_wajah'] as String?;
          statusMessage = "Wajah cocok! Check-in berhasil.";
        });
        _animationController.stop();

        Get.snackbar(
          'Sukses',
          'Peserta $participantName berhasil check-in event!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );

        await Future.delayed(const Duration(milliseconds: 2500));
        Get.back(result: true);
      } else {
        setState(() {
          isError = true;
          statusMessage = "Verifikasi Gagal. Wajah tidak cocok / Semua peserta sudah check-in.";
        });
        _animationController.stop();
      }
    } else {
      if (registrationId == null) return;
      final success = await EventService.checkinEventParticipant(registrationId!);

      if (!mounted) return;

      if (success) {
        setState(() {
          isCompleted = true;
          statusMessage = "Wajah cocok! Check-in berhasil.";
        });
        _animationController.stop();

        Get.snackbar(
          'Sukses',
          'Peserta $participantName berhasil check-in event!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back(result: true);
      } else {
        setState(() {
          isError = true;
          statusMessage = "Verifikasi Gagal. Wajah tidak cocok / kendala server.";
        });
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Camera (Simulated or Live Camera)
          Positioned.fill(
            child: MobileScanner(
              controller: controller,
              onDetect: (_) {},
            ),
          ),

          // Camera dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // UI guides & overlays
          SafeArea(
            child: Column(
              children: [
                // Top Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Get.back(result: false),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Scan Wajah (Check-In Event)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Face Scanning Circle Frame
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 380,
                    child: Stack(
                      children: [
                        // Border Oval Guide
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isCompleted
                                  ? Colors.green
                                  : (isError ? Colors.red : Colors.orange),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(140),
                          ),
                        ),

                        // Moving scanning line overlay
                        if (!isCompleted && !isError)
                          AnimatedBuilder(
                            animation: _scanAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: 380 * _scanAnimation.value,
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.8),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // Checkmark on success
                        if (isCompleted)
                          const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 100,
                            ),
                          ),

                        // Error Icon
                        if (isError)
                          const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 100,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Status Message and Details
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.5)
                          : (isError ? Colors.red.withOpacity(0.5) : Colors.white24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isCompleted
                              ? Colors.green
                              : (isError ? Colors.red : Colors.white),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, color: Colors.orange, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            participantName,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (isError) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () {
                            setState(() {
                              isError = false;
                              statusMessage = "Posisikan wajah peserta di dalam area scan";
                            });
                            _animationController.repeat(reverse: true);
                            _startFaceScanning();
                          },
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

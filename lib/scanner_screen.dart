import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'controllers/eo_bottom_nav_controller.dart';
import 'widgets/eo_bottom_nav.dart';
import 'services/event_service.dart';
import 'config/api_config.dart';
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  late final MobileScannerController controller;
  bool isFlashOn = false;
  bool isProcessing = false;

  // Face Scan Mode Variables
  bool isFaceScanMode = false;
  bool isFaceScanning = false;
  String faceScanStatus = "Posisikan wajah peserta di dalam area scan";
  late AnimationController _faceAnimationController;
  late Animation<double> _faceScanAnimation;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();

    // Determine default mode based on routing arguments
    final args = Get.arguments as Map<String, dynamic>?;
    isFaceScanMode = args != null && args['mode'] == 'face';

    final navController = Get.put(EOBottomNavController());
    navController.setIndex(2);

    _faceAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _faceScanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _faceAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _faceAnimationController.dispose();
    super.dispose();
  }

  Future<void> _startFaceCheckin() async {
    setState(() {
      isFaceScanning = true;
      faceScanStatus = "Mendeteksi wajah...";
    });
    _faceAnimationController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    setState(() {
      faceScanStatus = "Mencocokkan wajah dengan foto selfie...";
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final match = await EventService.matchFace();
    
    if (!mounted) return;
    setState(() {
      isFaceScanning = false;
      _faceAnimationController.stop();
    });

    if (match != null) {
      final name = match['nama_peserta'] ?? '-';
      setState(() {
        faceScanStatus = "Check-in Berhasil! Terdeteksi: $name";
      });

      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text("Check-In Event Berhasil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 15),
              Text(
                "Peserta $name telah terverifikasi wajah dan berhasil check-in event!",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text("OK"),
            )
          ],
        ),
      );

      Get.snackbar(
        'Sukses',
        'Peserta $name berhasil check-in event!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } else {
      setState(() {
        faceScanStatus = "Verifikasi Gagal. Wajah tidak cocok / Semua peserta sudah check-in.";
      });
      Get.snackbar(
        'Gagal',
        'Verifikasi Wajah Gagal. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// CAMERA
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (isFaceScanMode) return; // Ignore QR scan callback when in Face Mode
              if (isProcessing) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final code = barcode.rawValue;
                if (code == null || code.isEmpty) continue;
                
                setState(() {
                  isProcessing = true;
                });
                
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                
                final result = await EventService.verifyScan(code);
                Get.back(); // Close loading
                
                if (result != null) {
                  _showParticipantDialog(result);
                } else {
                  Get.snackbar(
                    'Gagal',
                    'Data pendaftaran tidak ditemukan atau bukan wewenang Anda.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[900],
                  );
                  setState(() {
                    isProcessing = false;
                  });
                }
                break;
              }
            },
          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          /// CONTENT
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFaceScanMode ? "Check-in Wajah" : "Scan Barcode Racepack",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isFaceScanMode ? "Arahkan kamera ke wajah peserta" : "Arahkan kamera ke barcode pelari",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                /// MODE SELECTOR (TAB BAR STYLE)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!isFaceScanMode) return;
                              setState(() {
                                isFaceScanMode = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isFaceScanMode ? Colors.orange : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Racepack (QR)",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isFaceScanMode) return;
                              setState(() {
                                isFaceScanMode = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isFaceScanMode ? Colors.orange : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Check-in Wajah",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                /// SCANNER FRAME
                Center(
                  child: isFaceScanMode
                      ? SizedBox(
                          width: 260,
                          height: 340,
                          child: Stack(
                            children: [
                              // Oval border guide
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 3.5,
                                  ),
                                  borderRadius: BorderRadius.circular(130),
                                ),
                              ),
                              // Moving scanning bar animation
                              if (isFaceScanning)
                                AnimatedBuilder(
                                  animation: _faceScanAnimation,
                                  builder: (context, child) {
                                    return Positioned(
                                      top: 340 * _faceScanAnimation.value,
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
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            children: [
                              scannerCorner(Alignment.topLeft),
                              scannerCorner(Alignment.topRight),
                              scannerCorner(Alignment.bottomLeft),
                              scannerCorner(Alignment.bottomRight),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 240,
                                  height: 2,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                const Spacer(),

                /// ACTION BUTTONS OR SCAN FACE TRIGGER
                if (isFaceScanMode) ...[
                  if (!isFaceScanning)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                      ),
                      onPressed: _startFaceCheckin,
                      icon: const Icon(Icons.face, color: Colors.white, size: 22),
                      label: const Text(
                        "PINDAI WAJAH",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.2),
                      ),
                    ),
                  const SizedBox(height: 30),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        actionButton(
                          Icons.arrow_back,
                          () {
                            Get.back();
                          },
                        ),
                        actionButton(
                          isFlashOn ? Icons.flash_on : Icons.flash_off,
                          () async {
                            await controller.toggleTorch();
                            setState(() {
                              isFlashOn = !isFlashOn;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                /// STATUS BOTTOM CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: isFaceScanMode ? (isFaceScanning ? Colors.amber : Colors.green) : Colors.lime,
                        size: 10,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFaceScanMode ? faceScanStatus : "Menunggu Barcode...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isFaceScanMode
                                  ? (isFaceScanning ? "Harap diam selama pemindaian" : "Posisikan wajah di tengah area")
                                  : "Pastikan pencahayaan cukup",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: EOBottomNav(),
    );
  }

  /// CORNER
  Widget scannerCorner(
    Alignment alignment,
  ) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          border: Border(
            top: alignment == Alignment.topLeft || alignment == Alignment.topRight
                ? const BorderSide(color: Colors.deepOrange, width: 5)
                : BorderSide.none,
            bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.deepOrange, width: 5)
                : BorderSide.none,
            left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft
                ? const BorderSide(color: Colors.deepOrange, width: 5)
                : BorderSide.none,
            right: alignment == Alignment.topRight || alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.deepOrange, width: 5)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// BUTTON
  Widget actionButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatDateTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final date = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
      final time = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      return "$date, $time";
    } catch (_) {
      return isoString;
    }
  }

  void _showParticipantDialog(Map<String, dynamic> reg) {
    final selfie = reg['scan_wajah'] as String?;
    final selfieUrl = selfie != null && selfie.isNotEmpty
        ? (selfie.startsWith('http') ? selfie : '${ApiConfig.baseUrl}/${selfie.replaceAll('\\', '/')}')
        : null;

    final isPaid = reg['status'] == 'paid';
    final hasCheckedIn = reg['status_kehadiran'] == 'hadir';
    final hasCheckedInEvent = reg['status_kehadiran_event'] == 'hadir';
    final checkinEventAt = reg['checkin_event_at'] as String?;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Verifikasi Peserta - ${reg['nama_event']}'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selfieUrl != null)
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            selfieUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (c, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (c, e, s) => const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 120,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 15),
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                      ),

                    Text('Nama: ${reg['nama_peserta']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text('BIB Name: ${reg['nama_bib']}'),
                    const SizedBox(height: 4),
                    Text('BIB Number: ${reg['bib_number'] ?? '-'}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Kategori: ${reg['kategori_lomba']}'),
                    const SizedBox(height: 12),

                    // Status display
                    Row(
                      children: [
                        const Text('Status Pembayaran: '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPaid ? Colors.green[50] : Colors.red[50],
                            border: Border.all(color: isPaid ? Colors.green : Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            reg['status'].toString().toUpperCase(),
                            style: TextStyle(color: isPaid ? Colors.green[800] : Colors.red[800], fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Check-in status display (Racepack)
                    Row(
                      children: [
                        const Text('Status Racepack: '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasCheckedIn ? Colors.blue[50] : Colors.amber[50],
                            border: Border.all(color: hasCheckedIn ? Colors.blue : Colors.amber),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            hasCheckedIn ? "SUDAH DIAMBIL" : "BELUM DIAMBIL",
                            style: TextStyle(color: hasCheckedIn ? Colors.blue[800] : Colors.amber[800], fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Event Check-in status display
                    Row(
                      children: [
                        const Text('Check-In Event: '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasCheckedInEvent ? Colors.green[50] : Colors.red[50],
                            border: Border.all(color: hasCheckedInEvent ? Colors.green : Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            hasCheckedInEvent ? "HADIR / CHECKED IN" : "BELUM HADIR",
                            style: TextStyle(color: hasCheckedInEvent ? Colors.green[800] : Colors.red[800], fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),

                    if (hasCheckedIn) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Info: Racepack sudah diambil pada ${_formatDateTime(reg['scan_at'])}",
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],

                    if (hasCheckedInEvent) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Info: Peserta sudah check-in event pada ${_formatDateTime(checkinEventAt)}",
                          style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isProcessing = false;
                    });
                  },
                  child: const Text('Tutup'),
                ),
                if (isPaid && !hasCheckedIn)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () async {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      final ok = await EventService.checkinParticipant(reg['registration_id']);
                      Get.back(); // close loading

                      if (ok) {
                        Get.snackbar('Sukses', 'Peserta berhasil Ambil Racepack!', snackPosition: SnackPosition.BOTTOM);
                        Navigator.of(context).pop();
                        setState(() {
                          isProcessing = false;
                        });
                      } else {
                        Get.snackbar('Gagal', 'Gagal memproses check-in racepack', snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    child: const Text('Ambil Racepack', style: TextStyle(color: Colors.white)),
                  ),
                if (isPaid && !hasCheckedInEvent)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      
                      try {
                        await controller.stop();
                      } catch (e) {
                        print("Error stopping scanner: $e");
                      }

                      final success = await Get.toNamed(
                        '/face-scan',
                        arguments: {
                          'registration_id': reg['registration_id'],
                          'nama_peserta': reg['nama_peserta'],
                          'scan_wajah': reg['scan_wajah'],
                        },
                      );

                      try {
                        await controller.start();
                      } catch (e) {
                        print("Error starting scanner: $e");
                      }

                      setState(() {
                        isProcessing = false;
                      });
                    },
                    icon: const Icon(Icons.face, color: Colors.white, size: 16),
                    label: const Text('Scan Wajah', style: TextStyle(color: Colors.white)),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
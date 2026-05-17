import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'controllers/bottom_nav_controller.dart';
import 'widgets/app_bottom_nav.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller =
      MobileScannerController();

  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    final navController = Get.put(BottomNavController());
    navController.setIndex(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// CAMERA
          MobileScanner(
            controller: controller,

            onDetect: (capture) {
              final List<Barcode> barcodes =
                  capture.barcodes;

              for (final barcode in barcodes) {
                debugPrint(
                  'Barcode ditemukan: ${barcode.rawValue}',
                );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      'Barcode: ${barcode.rawValue}',
                    ),
                  ),
                );
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
                const Padding(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        "Scan Barcode Racepack",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "Arahkan kamera ke barcode pelari",
                        style: TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// SCANNER FRAME
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        scannerCorner(
                          Alignment.topLeft,
                        ),

                        scannerCorner(
                          Alignment.topRight,
                        ),

                        scannerCorner(
                          Alignment.bottomLeft,
                        ),

                        scannerCorner(
                          Alignment.bottomRight,
                        ),

                        Align(
                          alignment:
                              Alignment.center,
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

                /// BUTTONS
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 80,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      actionButton(
                        Icons.arrow_back,
                        () {
                          Get.back();
                        },
                      ),

                      actionButton(
                        isFlashOn
                            ? Icons.flash_on
                            : Icons.flash_off,
                        () async {
                          await controller
                              .toggleTorch();

                          setState(() {
                            isFlashOn =
                                !isFlashOn;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// STATUS
                Container(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.45),
                    borderRadius:
                        BorderRadius.circular(
                            16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.lime,
                        size: 10,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              "Menunggu Barcode...",
                              style: TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Pastikan pencahayaan cukup",
                              style: TextStyle(
                                color: Colors
                                    .white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(),
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
            top: alignment ==
                        Alignment.topLeft ||
                    alignment ==
                        Alignment.topRight
                ? const BorderSide(
                    color:
                        Colors.deepOrange,
                    width: 5,
                  )
                : BorderSide.none,

            bottom: alignment ==
                        Alignment
                            .bottomLeft ||
                    alignment ==
                        Alignment
                            .bottomRight
                ? const BorderSide(
                    color:
                        Colors.deepOrange,
                    width: 5,
                  )
                : BorderSide.none,

            left: alignment ==
                        Alignment.topLeft ||
                    alignment ==
                        Alignment
                            .bottomLeft
                ? const BorderSide(
                    color:
                        Colors.deepOrange,
                    width: 5,
                  )
                : BorderSide.none,

            right: alignment ==
                        Alignment.topRight ||
                    alignment ==
                        Alignment
                            .bottomRight
                ? const BorderSide(
                    color:
                        Colors.deepOrange,
                    width: 5,
                  )
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
          color: Colors.black
              .withOpacity(0.35),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
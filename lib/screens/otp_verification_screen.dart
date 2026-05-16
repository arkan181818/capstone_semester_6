import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController otp1 =
      TextEditingController();

  final TextEditingController otp2 =
      TextEditingController();

  final TextEditingController otp3 =
      TextEditingController();

  final TextEditingController otp4 =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff7f3f1),

      /// APPBAR
      appBar: AppBar(
        title:
            const Text("Verifikasi OTP"),
        backgroundColor: Colors.white,
        foregroundColor:
            Colors.black87,
        elevation: 0,
      ),

      /// BODY
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(24),

            child: Column(
              children: [

                const SizedBox(height: 60),

                /// LOGO
                const Text(
                  "🏁RUNTRACK",
                  style: TextStyle(
                    color:
                        Colors.deepOrange,
                    fontSize: 34,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 60),

                /// CARD OTP
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(
                          24),

                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                                0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),

                  child: Column(
                    children: [

                      /// TITLE
                      const Text(
                        "Verifikasi Email",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 14),

                      /// SUBTITLE
                      const Text(
                        "Kami telah mengirimkan kode OTP ke\nemail Anda name@event.com",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(
                          height: 35),

                      /// OTP BOX
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [

                          otpBox(otp1),

                          otpBox(otp2),

                          otpBox(otp3),

                          otpBox(otp4),
                        ],
                      ),

                      const SizedBox(
                          height: 35),

                      /// BUTTON VERIFIKASI
                      SizedBox(
                        width:
                            double.infinity,
                        height: 55,

                        child:
                            ElevatedButton(
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                Colors
                                    .deepOrange,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          12),
                            ),
                          ),

                          onPressed: () {

                            String otp =
                                otp1.text +
                                    otp2.text +
                                    otp3.text +
                                    otp4.text;

                            if (otp.length ==
                                4) {

                              /// PINDAH KE HOME
                              Get.offNamed(
                                AppRoutes.home,
                              );

                            } else {
                              Get.snackbar(
                                'Error',
                                'Masukkan OTP lengkap',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },

                          child: const Text(
                            "VERIFIKASI",
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              letterSpacing:
                                  1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 22),

                      /// RESEND OTP
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [

                          const Text(
                            "Tidak menerima kode? ",
                            style:
                                TextStyle(
                              color: Colors
                                  .black54,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Get.snackbar(
                                'Sukses',
                                'Kode OTP dikirim ulang',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },

                            child:
                                const Text(
                              "Kirim Ulang Kode",
                              style:
                                  TextStyle(
                                color: Colors
                                    .deepOrange,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= OTP BOX =================
  Widget otpBox(
      TextEditingController
          controller) {
    return SizedBox(
      width: 58,
      height: 65,

      child: TextField(
        controller: controller,
        keyboardType:
            TextInputType.number,
        textAlign:
            TextAlign.center,
        maxLength: 1,

        style: const TextStyle(
          fontSize: 24,
          fontWeight:
              FontWeight.bold,
        ),

        decoration: InputDecoration(
          counterText: "",

          filled: true,
          fillColor: Colors.white,

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    12),
            borderSide: BorderSide(
              color: Colors
                  .orange.shade100,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    12),
            borderSide:
                const BorderSide(
              color:
                  Colors.deepOrange,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
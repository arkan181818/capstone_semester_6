import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String? email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();
  final TextEditingController otp5 = TextEditingController();
  final TextEditingController otp6 = TextEditingController();

  final FocusNode otp1Focus = FocusNode();
  final FocusNode otp2Focus = FocusNode();
  final FocusNode otp3Focus = FocusNode();
  final FocusNode otp4Focus = FocusNode();
  final FocusNode otp5Focus = FocusNode();
  final FocusNode otp6Focus = FocusNode();

  bool isVerifying = false;

  Future<void> verifyOtp() async {
    String otp =
        otp1.text +
        otp2.text +
        otp3.text +
        otp4.text +
        otp5.text +
        otp6.text;

    if (otp.length != 6) {
      Get.snackbar(
        "Error",
        "OTP harus 6 digit",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (widget.email == null || widget.email!.isEmpty) {
      Get.snackbar(
        "Error",
        "Email tidak tersedia",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isVerifying = true;
    });

    final result = await AuthService.verifyOtp(
      email: widget.email!,
      otp: otp,
    );

    setState(() {
      isVerifying = false;
    });

    if (result["status"] == 200) {
      Get.snackbar(
        "Sukses",
        "Verifikasi berhasil",
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed(AppRoutes.login);
    } else {
      Get.snackbar(
        "Error",
        result["data"]["msg"],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    otp5.dispose();
    otp6.dispose();
    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();
    otp5Focus.dispose();
    otp6Focus.dispose();
    super.dispose();
  }

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
                      Text(
                        "Kami telah mengirimkan kode OTP ke\nemail Anda ${widget.email ?? 'name@event.com'}",
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
                          otpBox(
                            otp1,
                            otp1Focus,
                            nextFocus: otp2Focus,
                          ),
                          otpBox(
                            otp2,
                            otp2Focus,
                            nextFocus: otp3Focus,
                          ),
                          otpBox(
                            otp3,
                            otp3Focus,
                            nextFocus: otp4Focus,
                          ),
                          otpBox(
                            otp4,
                            otp4Focus,
                            nextFocus: otp5Focus,
                          ),
                          otpBox(
                            otp5,
                            otp5Focus,
                            nextFocus: otp6Focus,
                          ),
                          otpBox(
                            otp6,
                            otp6Focus,
                            nextFocus: null,
                          ),
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

                          onPressed: isVerifying ? null : verifyOtp,
                          child: isVerifying
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "VERIFIKASI",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
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
    TextEditingController controller,
    FocusNode focusNode, {
    FocusNode? nextFocus,
  }) {
    return SizedBox(
      width: 45,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              focusNode.unfocus();
            }
          }

          if (otp1.text.isNotEmpty &&
              otp2.text.isNotEmpty &&
              otp3.text.isNotEmpty &&
              otp4.text.isNotEmpty &&
              otp5.text.isNotEmpty &&
              otp6.text.isNotEmpty) {
            verifyOtp();
          }
        },
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
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
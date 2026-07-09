import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'routes/app_routes.dart';
import 'services/event_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? proofBytes;
  String? proofFileName;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final registrationId = args?['registration_id'];
    final title = args?['title'] ?? 'MC RUN 2026';
    final category = args?['category'] ?? '10K Competitive Category';
    final date = args?['date'] ?? '30 Agustus 2026';
    final location = args?['location'] ?? 'Alun-Alun Kota Tegal';
    final price = args?['price'] ?? 'Rp 250.000';
    final totalPrice = args?['total_price'] ?? price;
    final bankAccount = args?['bank_account'] ?? 'BCA 123-456-7890';
    final accountName = args?['account_name'] ?? 'PT RunTrack Indonesia';

    return Scaffold(
      backgroundColor: const Color(0xfff7f4f0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xfffff3e4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Menunggu Pembayaran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '23:59:45',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(
                        'assets/images/event1.png',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'RACE ENTRY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xfff8f0e4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  date.split(' ').last.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Text(
                                price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Transaksi aman & terenkripsi',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'TRANSFER BANK & VA',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              paymentMethodTile(
                icon: Icons.account_balance,
                title: 'Virtual Account',
                subtitle: 'BCA, Mandiri, BNI, BRI',
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Nomor Rekening',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bankAccount,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      accountName,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  children: [
                    paymentSummaryRow('Harga Tiket', price),
                    const SizedBox(height: 10),
                    paymentSummaryRow('Biaya Layanan', 'Rp 5.000'),
                    const SizedBox(height: 10),
                    paymentSummaryRow('Promo "RUNTEGAL"', '- Rp 5.000', isPromo: true),
                    const Divider(height: 28, thickness: 1),
                    paymentSummaryRow('Total Bayar', totalPrice, isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Unggah Bukti Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickPaymentProof,
                      icon: const Icon(Icons.upload_file),
                      label: Text(
                        proofFileName == null ? 'Pilih Foto Bukti Pembayaran' : 'Ganti File: $proofFileName',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (proofBytes != null)
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: MemoryImage(proofBytes!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isUploading || proofBytes == null || registrationId == null ? null : () => _uploadProof(registrationId as int),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isUploading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Kirim Bukti Pembayaran',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: const [
                  Icon(
                    Icons.lock,
                    size: 16,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SECURE ENCRYPTED PAYMENT POWERED BY MIDTRANS',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPaymentProof() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (pickedFile == null) return;
    final bytes = await pickedFile.readAsBytes();
    setState(() {
      proofBytes = bytes;
      proofFileName = pickedFile.name;
    });
  }

  Future<void> _uploadProof(int registrationId) async {
    setState(() {
      isUploading = true;
    });

    try {
      final result = await EventService.uploadPaymentProof(
        registrationId: registrationId,
        proofBytes: proofBytes!,
        proofName: proofFileName ?? 'bukti.jpg',
      );

      if (result['status'] == 200) {
        Get.snackbar('Sukses', result['data']['msg']?.toString() ?? 'Bukti pembayaran dikirim.', snackPosition: SnackPosition.BOTTOM);
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(AppRoutes.home);
          });
        }
      } else {
        final message = result['data'] is Map<String, dynamic> ? result['data']['msg']?.toString() ?? 'Gagal mengirim bukti.' : 'Gagal mengirim bukti.';
        Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Widget paymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xfff9f3ea),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }

  Widget paymentSummaryRow(String label, String value,
      {bool isTotal = false, bool isPromo = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isPromo ? Colors.green[800] : Colors.black54,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
            color: isPromo ? Colors.green[800] : Colors.black87,
          ),
        ),
      ],
    );
  }
}

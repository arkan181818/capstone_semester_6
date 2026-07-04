import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

class EventRegistrationScreen extends StatefulWidget {
  final int eventId;
  final String eventTitle;
  final dynamic eventPrice;
  final String token;
  final int userId;

  const EventRegistrationScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.eventPrice,
    required this.token,
    required this.userId,
  });

  factory EventRegistrationScreen.fromArgs() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    return EventRegistrationScreen(
      eventId: args['eventId'] ?? 0,
      eventTitle: args['eventTitle'] ?? 'Event',
      eventPrice: args['eventPrice'] ?? 0,
      token: args['token'] ?? '',
      userId: args['userId'] ?? 0,
    );
  }

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  late ScrollController _scrollController;
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController kategoriLombaController = TextEditingController();
  final TextEditingController namaPesertaController = TextEditingController();
  final TextEditingController emailPesertaController = TextEditingController();
  final TextEditingController namaBibController = TextEditingController();
  final TextEditingController nohpPesertaController = TextEditingController();
  final TextEditingController alamatPesertaController = TextEditingController();
  final TextEditingController kotaPesertaController = TextEditingController();
  final TextEditingController provinsiPesertaController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController ukuranJerseyController = TextEditingController();
  final TextEditingController golonganDarahController = TextEditingController();
  final TextEditingController namaKontakDaruratController = TextEditingController();
  final TextEditingController nomorKontakDaruratController = TextEditingController();
  final TextEditingController riwayatPenyakitController = TextEditingController();

  String selectedGender = '';
  bool pernyataanSehat = false;
  bool isLoading = false;
  File? scanWajahImage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    kategoriLombaController.dispose();
    namaPesertaController.dispose();
    emailPesertaController.dispose();
    namaBibController.dispose();
    nohpPesertaController.dispose();
    alamatPesertaController.dispose();
    kotaPesertaController.dispose();
    provinsiPesertaController.dispose();
    tanggalLahirController.dispose();
    ukuranJerseyController.dispose();
    golonganDarahController.dispose();
    namaKontakDaruratController.dispose();
    nomorKontakDaruratController.dispose();
    riwayatPenyakitController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickScanWajah() async {
    try {
      XFile? pickedFile;

      // Platform check using kIsWeb
      if (kIsWeb) {
        // Web: Use gallery file picker
        pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
      } else {
        // Mobile: Use camera for selfie
        pickedFile = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
      }

      if (pickedFile != null) {
        setState(() {
          scanWajahImage = File(pickedFile!.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih foto: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _submitRegistration() async {
    // Validasi semua field
    if (kategoriLombaController.text.isEmpty ||
        namaPesertaController.text.isEmpty ||
        emailPesertaController.text.isEmpty ||
        namaBibController.text.isEmpty ||
        nohpPesertaController.text.isEmpty ||
        alamatPesertaController.text.isEmpty ||
        kotaPesertaController.text.isEmpty ||
        provinsiPesertaController.text.isEmpty ||
        tanggalLahirController.text.isEmpty ||
        selectedGender.isEmpty ||
        ukuranJerseyController.text.isEmpty ||
        golonganDarahController.text.isEmpty ||
        namaKontakDaruratController.text.isEmpty ||
        nomorKontakDaruratController.text.isEmpty ||
        scanWajahImage == null ||
        !pernyataanSehat) {
      Get.snackbar(
        'Error',
        'Lengkapi semua data terlebih dahulu (termasuk foto scan wajah)',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final registrationData = {
        "kategori_lomba": kategoriLombaController.text,
        "nama_peserta": namaPesertaController.text,
        "email_peserta": emailPesertaController.text,
        "nama_bib": namaBibController.text,
        "nohp_peserta": nohpPesertaController.text,
        "alamat_peserta": alamatPesertaController.text,
        "kota_peserta": kotaPesertaController.text,
        "provinsi_peserta": provinsiPesertaController.text,
        "tanggal_lahir": tanggalLahirController.text,
        "jenis_kelamin": selectedGender,
        "ukuran_jersey": ukuranJerseyController.text,
        "golongan_darah": golonganDarahController.text,
        "nama_kontak_darurat": namaKontakDaruratController.text,
        "nomor_kontak_darurat": nomorKontakDaruratController.text,
        "riwayat_penyakit": riwayatPenyakitController.text,
        "pernyataan_sehat": pernyataanSehat,
      };

      final result = await AuthService.registerEvent(
        token: widget.token,
        eventId: widget.eventId,
        data: registrationData,
        scanWajahFile: scanWajahImage!,
      );

      if (!mounted) return;

      if (result["status"] == 201) {
        Get.snackbar(
          'Sukses',
          'Pendaftaran berhasil, silakan upload bukti pembayaran',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Go to payment screen with registration ID
        Get.toNamed('/payment-upload', arguments: {
          'title': widget.eventTitle,
          'price': widget.eventPrice.toString(),
          'registrationId': result["data"]["registration_id"] ?? 0,
          'token': widget.token,
        });
      } else {
        final message = result["data"]["msg"] ?? 'Pendaftaran gagal';
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildInput(
    String label,
    String hint,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEFEFEF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (scanWajahImage == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 40,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          Text(
            kIsWeb
                ? "Tap untuk pilih foto wajah"
                : "Tap untuk ambil foto wajah (Selfie)",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    // Only show image preview on mobile platforms
    if (!kIsWeb) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              scanWajahImage!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tap untuk ganti foto",
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Web: Show selected indicator instead of image
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Colors.green,
                ),
                SizedBox(height: 8),
                Text(
                  "Foto dipilih ✓",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Tap untuk ganti foto",
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendaftaran Event"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "DATA PESERTA",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              buildInput(
                "KATEGORI LOMBA",
                "Pilih kategori",
                kategoriLombaController,
              ),
              buildInput(
                "NAMA PESERTA",
                "Masukkan nama lengkap",
                namaPesertaController,
              ),
              buildInput(
                "EMAIL PESERTA",
                "example@email.com",
                emailPesertaController,
                keyboardType: TextInputType.emailAddress,
              ),
              buildInput(
                "NAMA BIB",
                "Masukkan nama untuk BIB",
                namaBibController,
              ),
              buildInput(
                "NOMOR TELEPON",
                "+62 812...",
                nohpPesertaController,
                keyboardType: TextInputType.phone,
              ),
              buildInput(
                "ALAMAT",
                "Masukkan alamat lengkap",
                alamatPesertaController,
              ),
              buildInput(
                "KOTA",
                "Masukkan nama kota",
                kotaPesertaController,
              ),
              buildInput(
                "PROVINSI",
                "Masukkan nama provinsi",
                provinsiPesertaController,
              ),
              buildInput(
                "TANGGAL LAHIR",
                "Pilih tanggal lahir",
                tanggalLahirController,
                readOnly: true,
                onTap: _selectDate,
              ),
              const Text(
                "JENIS KELAMIN",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedGender.isEmpty ? null : selectedGender,
                hint: const Text("Pilih jenis kelamin"),
                items: const [
                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 14),
              buildInput(
                "UKURAN JERSEY",
                "XS / S / M / L / XL / XXL",
                ukuranJerseyController,
              ),
              buildInput(
                "GOLONGAN DARAH",
                "A / B / AB / O",
                golonganDarahController,
              ),
              buildInput(
                "NAMA KONTAK DARURAT",
                "Masukkan nama",
                namaKontakDaruratController,
              ),
              buildInput(
                "NOMOR KONTAK DARURAT",
                "+62 812...",
                nomorKontakDaruratController,
                keyboardType: TextInputType.phone,
              ),
              buildInput(
                "RIWAYAT PENYAKIT (OPSIONAL)",
                "Tuliskan jika ada",
                riwayatPenyakitController,
              ),
              const Text(
                "SCAN WAJAH",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _pickScanWajah,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scanWajahImage != null
                          ? Colors.green
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: Colors.orange,
                    value: pernyataanSehat,
                    onChanged: (v) {
                      setState(() {
                        pernyataanSehat = v!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "Saya menyatakan bahwa data yang diberikan benar dan saya dalam kondisi sehat untuk mengikuti lomba ini.",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _submitRegistration,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "LANJUT PEMBAYARAN →",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

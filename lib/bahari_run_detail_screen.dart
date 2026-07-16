import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'payment_screen.dart';
import 'services/event_service.dart';
import 'models/event_model.dart';
import 'config/api_config.dart';

class BahariRunDetailScreen extends StatefulWidget {
  final int eventId;
  final String title;
  final String price;
  final String date;
  final String location;

  const BahariRunDetailScreen({
    super.key,
    this.eventId = 1,
    this.title = 'BAHARI RUN',
    this.price = 'IDR 250.000',
    this.date = '24 Oct 2024',
    this.location = 'Alun-Alun Tegal',
  });

  @override
  State<BahariRunDetailScreen> createState() => _BahariRunDetailScreenState();
}

class _BahariRunDetailScreenState extends State<BahariRunDetailScreen> {
  EventModel? event;
  bool isLoading = true;

  String selectedCategory = '10K Competitive';
  String fullName = '';
  String email = '';
  String namaBib = '';
  String phoneNumber = '';
  String alamat = '';
  String kota = '';
  String provinsi = '';
  String tanggalLahir = '';
  String jenisKelamin = 'Laki-laki';
  String ukuranJersey = 'M';
  String golonganDarah = 'O';
  String namaKontakDarurat = '';
  String nomorKontakDarurat = '';
  String riwayatPenyakit = '';
  bool pernyataanSehat = false;
  Uint8List? scanWajahBytes;
  String? scanWajahName;
  bool isRegistering = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadEventDetail();
  }

  Future<void> _loadEventDetail() async {
    try {
      final ev = await EventService.getEventDetail(widget.eventId);
      setState(() {
        event = ev;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'Gagal memuat data event: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  String formatRupiah(double val) {
    return 'Rp ${val.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  double getCategoryPrice(String category) {
    if (event == null) return 0;
    final basePrice = double.tryParse(event!.harga) ?? 0.0;
    if (category == '5K Fun Run') {
      return basePrice * 0.6;
    } else if (category == '3K Fun Run') {
      return basePrice * 0.4;
    }
    return basePrice;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Event')),
        body: const Center(
          child: Text('Gagal memuat data event.'),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),

            // Event Banner
            _buildEventBanner(),

            // Event Info Cards
            _buildEventInfoCards(),

            // Map Section
            _buildMapSection(),

            // Racepack Details
            _buildRacepackDetails(),

            // Pendaftaran Section
            _buildPendaftaranSection(),

            // Scan Wajah Section
            _buildScanWajahSection(),

            // Kontak Darurat Section
            _buildKontakDaruratSection(),

            // Total & Button
            _buildTotalAndButton(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            event?.lokasi ?? 'Detail Event',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBanner() {
    final banner = event?.bannerUrl;
    final bannerUrl = banner != null && banner.isNotEmpty
        ? (banner.startsWith('http') ? banner : '${ApiConfig.baseUrl}/${banner.replaceAll('\\', '/')}')
        : null;

    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: bannerUrl != null
              ? Image.network(
                  bannerUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
                )
              : Image.asset(
                  'assets/images/event1.png',
                  fit: BoxFit.cover,
                ),
        ),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event?.status.toUpperCase() ?? 'DRAFT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event?.namaEvent ?? '',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '10K',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6B35),
                ),
              ),
              Text(
                event?.lokasi ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfoCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoCard(
            icon: '📅',
            label: 'DATE',
            value: event?.tanggal != null ? event!.tanggal.toLocal().toString().split(' ')[0] : '',
          ),
          _buildInfoCard(
            icon: '⏰',
            label: 'START TIME',
            value: '06:00 WIB',
          ),
          _buildInfoCard(
            icon: '📍',
            label: 'DISTANCE',
            value: '10.0 KM',
          ),
          _buildInfoCard(
            icon: '👥',
            label: 'PARTICIPANTS',
            value: '${event?.totalPeserta ?? 0} / ${event?.kuota ?? 0}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[400]!,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.map,
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'START LINE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          event?.lokasi ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRacepackDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Racepack Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          _buildDetailItem(
            icon: '🏆',
            title: 'High-Performance Jersey',
            subtitle: 'Moisture-wicking professional fabric.',
          ),
          SizedBox(height: 12),
          _buildDetailItem(
            icon: '⏱️',
            title: 'Timing Chip Bib',
            subtitle: 'Real-time tracking for official results.',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendaftaranSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pendaftaran Peserta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'NAMA LENGKAP',
            hint: 'Masukkan nama sesuai KTP',
            value: fullName,
            onChanged: (value) => setState(() => fullName = value),
          ),
          _buildTextField(
            label: 'EMAIL PESERTA',
            hint: 'Masukkan email peserta',
            value: email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => setState(() => email = value),
          ),
          _buildTextField(
            label: 'NAMA BIB',
            hint: 'Masukkan nama BIB',
            value: namaBib,
            onChanged: (value) => setState(() => namaBib = value),
          ),
          _buildTextField(
            label: 'NO HP PESERTA',
            hint: 'Contoh: 0812xxxxxxx',
            value: phoneNumber,
            keyboardType: TextInputType.phone,
            onChanged: (value) => setState(() => phoneNumber = value),
          ),
          _buildTextField(
            label: 'ALAMAT',
            hint: 'Masukkan alamat lengkap',
            value: alamat,
            onChanged: (value) => setState(() => alamat = value),
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'KOTA',
                  hint: 'Kota',
                  value: kota,
                  onChanged: (value) => setState(() => kota = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'PROVINSI',
                  hint: 'Provinsi',
                  value: provinsi,
                  onChanged: (value) => setState(() => provinsi = value),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'TANGGAL LAHIR',
                  hint: 'YYYY-MM-DD',
                  value: tanggalLahir,
                  onChanged: (value) => setState(() => tanggalLahir = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'JENIS KELAMIN',
                  value: jenisKelamin,
                  options: ['Laki-laki', 'Perempuan'],
                  onChanged: (value) => setState(() => jenisKelamin = value),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'UKURAN JERSEY',
                  value: ukuranJersey,
                  options: ['S', 'M', 'L', 'XL'],
                  onChanged: (value) => setState(() => ukuranJersey = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  label: 'GOLONGAN DARAH',
                  value: golonganDarah,
                  options: ['O', 'A', 'B', 'AB'],
                  onChanged: (value) => setState(() => golonganDarah = value),
                ),
              ),
            ],
          ),
          _buildTextField(
            label: 'RIWAYAT PENYAKIT (opsional)',
            hint: 'Contoh: asma, alergi',
            value: riwayatPenyakit,
            onChanged: (value) => setState(() => riwayatPenyakit = value),
          ),
          const SizedBox(height: 8),
          Text(
            'KATEGORI LARI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryOption(
            title: '10K Competitive',
            price: formatRupiah(getCategoryPrice('10K Competitive')),
            value: '10K Competitive',
          ),
          const SizedBox(height: 10),
          _buildCategoryOption(
            title: '5K Fun Run',
            price: formatRupiah(getCategoryPrice('5K Fun Run')),
            value: '5K Fun Run',
          ),
          const SizedBox(height: 10),
          _buildCategoryOption(
            title: '3K Fun Run',
            price: formatRupiah(getCategoryPrice('3K Fun Run')),
            value: '3K Fun Run',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption({
    required String title,
    required String price,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedCategory == value ? Color(0xFFFF6B35) : Colors.grey[300]!,
            width: selectedCategory == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: selectedCategory == value ? Color(0xFFFF6B35).withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedCategory == value ? Color(0xFFFF6B35) : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: selectedCategory == value
                  ? Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFF6B35),
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanWajahSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFFF6B35),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFFF6B35),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.face_retouching_natural,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selfie Wajah',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ambil foto selfie wajah Anda langsung menggunakan kamera untuk verifikasi.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickScanWajah,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: Text(
                scanWajahName == null ? 'Ambil Foto Selfie Wajah (Kamera)' : 'Ganti Selfie: $scanWajahName',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            if (scanWajahBytes != null)
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: MemoryImage(scanWajahBytes!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKontakDaruratSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KONTAK DARURAT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            label: 'NAMA KONTAK DARURAT',
            hint: 'Masukkan nama kontak darurat',
            value: namaKontakDarurat,
            onChanged: (value) => setState(() => namaKontakDarurat = value),
          ),
          _buildTextField(
            label: 'NOMOR KONTAK DARURAT',
            hint: 'Masukkan nomor telepon',
            value: nomorKontakDarurat,
            keyboardType: TextInputType.phone,
            onChanged: (value) => setState(() => nomorKontakDarurat = value),
          ),
        ],
      ),
    );
  }

  String get _selectedCategoryPrice {
    return formatRupiah(getCategoryPrice(selectedCategory));
  }

  Future<void> _pickScanWajah() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75,
      );
      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      setState(() {
        scanWajahBytes = bytes;
        scanWajahName = pickedFile.name;
      });
    } catch (e) {
      Get.snackbar(
        'Gagal Membuka Kamera',
        'Pastikan izin kamera diaktifkan dan gunakan browser/device fisik yang didukung: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _submitRegistration() async {
    if (fullName.isEmpty || email.isEmpty || namaBib.isEmpty || phoneNumber.isEmpty || alamat.isEmpty || kota.isEmpty || provinsi.isEmpty || tanggalLahir.isEmpty || namaKontakDarurat.isEmpty || nomorKontakDarurat.isEmpty || !pernyataanSehat || scanWajahBytes == null) {
      Get.snackbar(
        'Lengkapi data',
        'Mohon isi semua data wajib dan ambil foto selfie wajah.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isRegistering = true;
    });

    try {
      final result = await EventService.registerEventUser(
        eventId: widget.eventId,
        kategoriLomba: selectedCategory,
        namaPeserta: fullName,
        emailPeserta: email,
        namaBib: namaBib,
        nohpPeserta: phoneNumber,
        alamatPeserta: alamat,
        kotaPeserta: kota,
        provinsiPeserta: provinsi,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelamin,
        ukuranJersey: ukuranJersey,
        golonganDarah: golonganDarah,
        namaKontakDarurat: namaKontakDarurat,
        nomorKontakDarurat: nomorKontakDarurat,
        riwayatPenyakit: riwayatPenyakit.isNotEmpty ? riwayatPenyakit : null,
        pernyataanSehat: pernyataanSehat,
        scanWajahBytes: scanWajahBytes,
        scanWajahName: scanWajahName,
      );

      if (result['status'] == 201) {
        final registrationId = result['data']['registration_id'];
        Get.to(
          PaymentScreen(),
          arguments: {
            'registration_id': registrationId,
            'title': event?.namaEvent ?? widget.title,
            'price': _selectedCategoryPrice,
            'date': event?.tanggal != null ? event!.tanggal.toLocal().toString().split(' ')[0] : widget.date,
            'location': event?.lokasi ?? widget.location,
            'category': selectedCategory,
            'total_price': _selectedCategoryPrice,
            'bank_account': 'BCA 123-456-7890',
            'account_name': 'PT RunTrack Indonesia',
          },
        );
      } else {
        final message = result['data'] is Map<String, dynamic> ? result['data']['msg']?.toString() ?? 'Pendaftaran gagal.' : 'Pendaftaran gagal.';
        Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        isRegistering = false;
      });
    }
  }

  Widget _buildTotalAndButton() {
    final totalPrice = _selectedCategoryPrice;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                totalPrice,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: pernyataanSehat,
                activeColor: Color(0xFFFF6B35),
                onChanged: (value) {
                  setState(() {
                    pernyataanSehat = value ?? false;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'Saya menyatakan data sudah benar dan sehat untuk mengikuti event.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isRegistering ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: isRegistering
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'DAFTAR SEKARANG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

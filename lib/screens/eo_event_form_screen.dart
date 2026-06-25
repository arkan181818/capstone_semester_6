import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../routes/app_routes.dart';
import '../services/event_service.dart';
import '../models/event_model.dart';

class EOEventFormScreen extends StatefulWidget {
  const EOEventFormScreen({super.key});

  @override
  State<EOEventFormScreen> createState() => _EOEventFormScreenState();
}

class _EOEventFormScreenState extends State<EOEventFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quotaController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int? selectedCategoryId;

  final List<Map<String, dynamic>> categoryOptions = [
    {'id': 1, 'name': '5K'},
    {'id': 2, 'name': '10K'},
    {'id': 3, 'name': 'Half Marathon'},
    {'id': 4, 'name': 'Marathon'},
  ];

  final ImagePicker _picker = ImagePicker();
  Uint8List? pickedImageBytes;
  String? pickedImageName;
  bool isSaving = false;
  bool isEditing = false;
  int? eventId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      isEditing = true;
      eventId = args['id'] as int?;
      nameController.text = args['nama_event'] as String? ?? '';
      locationController.text = args['lokasi'] as String? ?? '';
      dateController.text = args['tanggal'] as String? ?? '';
      priceController.text = args['harga']?.toString() ?? '';
      quotaController.text = args['kuota']?.toString() ?? '';
      descriptionController.text = args['deskripsi'] as String? ?? '';
      selectedCategoryId = args['category_id'] is int
          ? args['category_id'] as int
          : int.tryParse(args['category_id']?.toString() ?? '');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    dateController.dispose();
    priceController.dispose();
    quotaController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickBanner() async {
    final result = await _picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      pickedImageBytes = await result.readAsBytes();
      pickedImageName = result.name;
      setState(() {});
    }
  }

  Future<void> saveEvent() async {
    if (nameController.text.isEmpty || locationController.text.isEmpty || dateController.text.isEmpty || priceController.text.isEmpty || quotaController.text.isEmpty || selectedCategoryId == null) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final result = isEditing
          ? await EventService.updateEvent(
              eventId: eventId!,
              categoryId: selectedCategoryId!,
              namaEvent: nameController.text,
              tanggal: dateController.text,
              lokasi: locationController.text,
              deskripsi: descriptionController.text,
              harga: priceController.text,
              kuota: int.tryParse(quotaController.text) ?? 0,
              bannerBytes: pickedImageBytes,
              bannerName: pickedImageName,
            )
          : await EventService.createEvent(
              categoryId: selectedCategoryId!,
              namaEvent: nameController.text,
              tanggal: dateController.text,
              lokasi: locationController.text,
              deskripsi: descriptionController.text,
              harga: priceController.text,
              kuota: int.tryParse(quotaController.text) ?? 0,
              bannerBytes: pickedImageBytes,
              bannerName: pickedImageName,
            );

      if (result['status'] == 201 || result['status'] == 200) {
        Get.snackbar(
          'Sukses',
          result['data']['msg'] ?? 'Berhasil disimpan. Menunggu persetujuan Super Admin.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          'Error',
          result['data']['msg'] ?? 'Gagal menyimpan event',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event' : 'Tambah Event'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Kategori Event',
                border: OutlineInputBorder(),
              ),
              items: categoryOptions.map((category) {
                return DropdownMenuItem<int>(
                  value: category['id'] as int,
                  child: Text(category['name'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Event',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal (YYYY-MM-DD atau YYYY-MM-DD HH:MM:SS)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quotaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kuota',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickBanner,
              child: const Text('Pilih Banner'),
            ),
            if (pickedImageName != null) ...[
              const SizedBox(height: 8),
              Text('Banner: $pickedImageName'),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveEvent,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? 'Simpan Perubahan' : 'Buat Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

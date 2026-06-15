import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Uint8List? selectedImageBytes;
  String? selectedImageName;
  String? profileImageUrl;
  bool isSaving = false;
  bool isFetching = true;
  String? fetchError;

  String selectedGender = "Laki-laki";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isFetching
          ? const Center(child: CircularProgressIndicator())
          : fetchError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          fetchError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadProfile,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
            // Foto Profil
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      image: DecorationImage(
                        image: selectedImageBytes != null
                            ? MemoryImage(selectedImageBytes!)
                            : profileImageUrl != null
                                ? NetworkImage(profileImageUrl!)
                                : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: showImageSourceSheet,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Full Name
            buildLabel("Full Name"),
            const SizedBox(height: 6),
            buildTextField(controller: nameController),

            const SizedBox(height: 16),

            // Email
            buildLabel("Email"),
            const SizedBox(height: 6),
            buildTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            // Alamat
            buildLabel("Alamat"),
            const SizedBox(height: 6),
            buildTextField(
              controller: addressController,
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            // Gender
            buildLabel("Gender"),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: genderButton("Laki-laki"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: genderButton("Perempuan"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (selectedImageName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Gambar terpilih: $selectedImageName",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "SIMPAN PERUBAHAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Tombol Batal
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Batal",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadProfile() async {
    setState(() {
      isFetching = true;
      fetchError = null;
    });

    try {
      final profile = await ProfileService.fetchProfile();
      nameController.text = profile.nama;
      emailController.text = profile.email;
      addressController.text = profile.alamat ?? '';
      profileImageUrl = profile.imageUrl.isNotEmpty ? profile.imageUrl : null;
    } catch (error) {
      fetchError = error.toString();
    } finally {
      if (mounted) {
        setState(() {
          isFetching = false;
        });
      }
    }
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(
            color: Colors.orange,
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    setState(() {
      selectedImageBytes = bytes;
      selectedImageName = pickedFile.name;
    });
  }

  void showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil foto menggunakan kamera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitProfile() async {
    final nama = nameController.text.trim();
    final email = emailController.text.trim();
    final alamat = addressController.text.trim();

    setState(() {
      isSaving = true;
    });

    try {
      final result = await ProfileService.updateProfile(
        nama: nama,
        email: email,
        alamat: alamat,
        imageBytes: selectedImageBytes,
        imageName: selectedImageName,
      );

      final status = result['status'] as int;
      final data = result['data'] as Map<String, dynamic>;

      if (status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['msg'] ?? 'Profil berhasil diperbarui'),
          ),
        );
        Navigator.pop(context);
      } else {
        final message = data['msg'] ?? 'Gagal memperbarui profil';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget genderButton(String gender) {
    final isSelected = selectedGender == gender;

    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.orange : Colors.grey.shade400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      icon: Icon(
        gender == "Laki-laki" ? Icons.male : Icons.female,
        color: isSelected ? Colors.orange : Colors.grey,
        size: 18,
      ),
      label: Text(
        gender,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.black87,
        ),
      ),
    );
  }
}
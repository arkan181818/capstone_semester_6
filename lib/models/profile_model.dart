import '../config/api_config.dart';

class ProfileModel {
  final int id;
  final String nama;
  final String username;
  final String email;
  final String? tglLahir;
  final String? nohp;
  final String? alamat;
  final String? fotoProfile;
  final bool isVerified;
  final String createdAt;

  ProfileModel({
    required this.id,
    required this.nama,
    required this.username,
    required this.email,
    required this.tglLahir,
    required this.nohp,
    required this.alamat,
    required this.fotoProfile,
    required this.isVerified,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      tglLahir: json['tgl_lahir'] as String?,
      nohp: json['nohp'] as String?,
      alamat: json['alamat'] as String?,
      fotoProfile: json['foto_profile'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );
  }

  String get imageUrl {
    if (fotoProfile == null || fotoProfile!.isEmpty) {
      return '';
    }

    if (fotoProfile!.startsWith('http')) {
      return fotoProfile!;
    }

    final normalized = fotoProfile!.replaceAll('\\', '/');
    return '${ApiConfig.baseUrl}/$normalized';
  }
}

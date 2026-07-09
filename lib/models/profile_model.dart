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

  // New fields from /me endpoint
  final bool? paymentVerified;
  final String? bibNumber;
  final String? registrationStatus;
  final int? role;

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
    this.paymentVerified,
    this.bibNumber,
    this.registrationStatus,
    this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Flexible parsing for payment verification and bib number because backend keys may vary
    bool? parsePaymentVerified(Map<String, dynamic> j) {
      if (j.containsKey('is_payment_verified')) {
        return j['is_payment_verified'] as bool?;
      }
      if (j.containsKey('payment_verified')) {
        return j['payment_verified'] as bool?;
      }
      if (j.containsKey('status_pembayaran')) {
        final v = j['status_pembayaran'];
        if (v is String) {
          final s = v.toLowerCase();
          return s == 'accepted' || s == 'approved' || s == 'verified' || s == 'lunas' || s == 'success';
        }
        if (v is bool) return v;
      }
      return null;
    }

    String? parseBib(Map<String, dynamic> j) {
      if (j.containsKey('bib_number')) return j['bib_number']?.toString();
      if (j.containsKey('kode_bib')) return j['kode_bib']?.toString();
      if (j.containsKey('bib')) return j['bib']?.toString();
      if (j.containsKey('nomor_bib')) return j['nomor_bib']?.toString();
      return null;
    }

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
      paymentVerified: parsePaymentVerified(json),
      bibNumber: parseBib(json),
      registrationStatus: json['registration_status'] as String?,
      role: json['role'] as int?,
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

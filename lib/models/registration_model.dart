class RegistrationModel {
  final int id;
  final int eventId;
  final int userId;
  final String userName;
  final String namaPeserta;
  final String emailPeserta;
  final String namaBib;
  final String kategoriLomba;
  final String status;
  final String? bibNumber;
  final String? buktiPembayaran;
  final String? rejectReason;

  // New fields for User's my_registrations
  final String? namaEvent;
  final String? banner;
  final String? tanggalEvent;
  final String? lokasi;
  final double? harga;
  final String? statusKehadiran;
  final String? scanAt;
  final String? statusKehadiranEvent;
  final String? checkinEventAt;

  RegistrationModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.namaPeserta,
    required this.emailPeserta,
    required this.namaBib,
    required this.kategoriLomba,
    required this.status,
    this.bibNumber,
    this.buktiPembayaran,
    this.rejectReason,
    this.namaEvent,
    this.banner,
    this.tanggalEvent,
    this.lokasi,
    this.harga,
    this.statusKehadiran,
    this.scanAt,
    this.statusKehadiranEvent,
    this.checkinEventAt,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: (json['registration_id'] ?? json['id'] ?? 0) as int,
      eventId: (json['event_id'] ?? 0) as int,
      userId: (json['user_id'] ?? 0) as int,
      userName: (json['user_name'] ?? json['nama'] ?? '') as String,
      namaPeserta: (json['nama_peserta'] ?? '') as String,
      emailPeserta: (json['email_peserta'] ?? json['email'] ?? '') as String,
      namaBib: (json['nama_bib'] ?? '') as String,
      kategoriLomba: (json['kategori_lomba'] ?? '') as String,
      status: (json['status'] ?? 'pending') as String,
      bibNumber: json['bib_number'] as String?,
      buktiPembayaran: json['bukti_pembayaran'] as String?,
      rejectReason: json['reject_reason'] as String?,
      namaEvent: json['nama_event'] as String?,
      banner: json['banner'] as String?,
      tanggalEvent: json['tanggal_event'] as String?,
      lokasi: json['lokasi'] as String?,
      harga: json['harga'] != null ? double.tryParse(json['harga'].toString()) : null,
      statusKehadiran: json['status_kehadiran'] as String?,
      scanAt: json['scan_at'] as String?,
      statusKehadiranEvent: json['status_kehadiran_event'] as String?,
      checkinEventAt: json['checkin_event_at'] as String?,
    );
  }
}

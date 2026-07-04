class EventModel {
  final int id;
  final String namaEvent;
  final String lokasi;
  final DateTime tanggal;
  final String? deskripsi;
  final String? bannerUrl;
  final String status;
  final String harga;
  final int kuota;

  EventModel({
    required this.id,
    required this.namaEvent,
    required this.lokasi,
    required this.tanggal,
    this.deskripsi,
    this.bannerUrl,
    required this.status,
    required this.harga,
    required this.kuota,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final rawTanggal = json['tanggal'] as String? ?? '';
    DateTime tanggal;
    try {
      tanggal = DateTime.parse(rawTanggal);
    } catch (_) {
      tanggal = DateTime.tryParse(rawTanggal) ?? DateTime.now();
    }

    return EventModel(
      id: json['id'] as int,
      namaEvent: json['nama_event'] as String? ?? '',
      lokasi: json['lokasi'] as String? ?? '',
      tanggal: tanggal,
      deskripsi: json['deskripsi'] as String?,
      bannerUrl: json['banner'] as String?,
      status: json['status'] as String? ?? '',
      harga: json['harga']?.toString() ?? '',
      kuota: json['kuota'] is int ? json['kuota'] as int : int.tryParse(json['kuota']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_event': namaEvent,
      'lokasi': lokasi,
      'tanggal': tanggal.toIso8601String(),
      'deskripsi': deskripsi,
      'banner': bannerUrl,
      'status': status,
      'harga': harga,
      'kuota': kuota,
    };
  }
}

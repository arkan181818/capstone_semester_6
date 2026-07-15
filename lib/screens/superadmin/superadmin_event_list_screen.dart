import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/admin_service.dart';

class SuperAdminEventListScreen extends StatefulWidget {
  const SuperAdminEventListScreen({super.key});

  @override
  State<SuperAdminEventListScreen> createState() =>
      _SuperAdminEventListScreenState();
}

class _SuperAdminEventListScreenState
    extends State<SuperAdminEventListScreen> {
  List<dynamic> _events = [];
  List<dynamic> _filtered = [];
  bool _loading = true;
  String _filterStatus = 'semua';

  final List<Map<String, String>> _statusFilters = [
    {'key': 'semua', 'label': 'Semua'},
    {'key': 'pending_approval', 'label': 'Pending'},
    {'key': 'published', 'label': 'Published'},
    {'key': 'draft', 'label': 'Draft'},
    {'key': 'rejected', 'label': 'Ditolak'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await AdminService.getAllEvents();
    if (res['status'] == 200) {
      _events = res['data'] as List;
      _applyFilter();
    }
    setState(() => _loading = false);
  }

  void _applyFilter() {
    if (_filterStatus == 'semua') {
      _filtered = List.from(_events);
    } else {
      _filtered =
          _events.where((e) => e['status'] == _filterStatus).toList();
    }
    setState(() {});
  }

  Future<void> _approve(int id, String nama) async {
    final confirm = await _showConfirm(
        'Approve Event', 'Approve "$nama"?\nEvent akan dipublish.', true);
    if (!confirm) return;

    final res = await AdminService.approveEvent(id);
    _showSnack(res['status'] == 200, res['data']['msg']);
    if (res['status'] == 200) _load();
  }

  Future<void> _reject(int id, String nama) async {
    final confirm = await _showConfirm(
        'Reject Event', 'Tolak "$nama"?\nEvent tidak akan dipublish.', false);
    if (!confirm) return;

    final res = await AdminService.rejectEvent(id);
    _showSnack(res['status'] == 200, res['data']['msg']);
    if (res['status'] == 200) _load();
  }

  Future<bool> _showConfirm(
      String title, String content, bool isApprove) async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            content:
                Text(content, style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Batal',
                    style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isApprove ? const Color(0xFF43E97B) : Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Get.back(result: true),
                child: Text(isApprove ? 'Approve' : 'Reject',
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSnack(bool success, String msg) {
    Get.snackbar(
      success ? 'Berhasil' : 'Gagal',
      msg,
      backgroundColor:
          success ? const Color(0xFF43E97B) : Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'published':
        return const Color(0xFF43E97B);
      case 'pending_approval':
        return const Color(0xFFFFA500);
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.white38;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'published':
        return 'Published';
      case 'pending_approval':
        return 'Pending';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Draft';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Kelola Event',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _load,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter Bar ─────────────────────────────────────────────────────
          Container(
            height: 48,
            color: const Color(0xFF1A1A2E),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _statusFilters.length,
              itemBuilder: (_, i) {
                final f = _statusFilters[i];
                final selected = _filterStatus == f['key'];
                return GestureDetector(
                  onTap: () {
                    _filterStatus = f['key']!;
                    _applyFilter();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)])
                          : null,
                      color: selected ? null : const Color(0xFF252540),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      f['label']!,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ── List ───────────────────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF)))
                : _filtered.isEmpty
                    ? const Center(
                        child: Text('Tidak ada event.',
                            style: TextStyle(color: Colors.white54)))
                    : RefreshIndicator(
                        color: const Color(0xFF6C63FF),
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) =>
                              _buildEventCard(_filtered[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> e) {
    final status = e['status'] as String?;
    final isPending = status == 'pending_approval' || status == 'draft';
    print("DEBUG Kelola Event: status=$status, isPending=$isPending");

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: _statusColor(status).withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner placeholder
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _statusColor(status),
                    _statusColor(status).withOpacity(0.3)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge + nama
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor(status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _statusLabel(status),
                        style: TextStyle(
                            color: _statusColor(status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e['nama_event'] ?? '-',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _infoRow(Icons.person_outline, 'EO: ${e['eo_nama'] ?? '-'}'),
                _infoRow(Icons.category_outlined, e['kategori'] ?? '-'),
                _infoRow(Icons.location_on_outlined, e['lokasi'] ?? '-'),
                _infoRow(Icons.calendar_today_outlined,
                    (e['tanggal'] ?? '').toString().substring(0, 10)),
                _infoRow(Icons.people_outline,
                    'Kuota: ${e['kuota'] ?? 0} peserta'),
                _infoRow(Icons.payments_outlined,
                    'Rp ${_formatPrice(e['harga'])}'),
                // ── Action Buttons ─────────────────────────────────────────
                if (isPending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _reject(e['id'], e['nama_event'] ?? ''),
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Tolak'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _approve(e['id'], e['nama_event'] ?? ''),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF43E97B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style:
                    const TextStyle(color: Colors.white60, fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    final n = (price as num).toInt();
    return n.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}

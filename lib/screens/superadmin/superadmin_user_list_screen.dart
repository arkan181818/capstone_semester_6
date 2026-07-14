import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/admin_service.dart';

class SuperAdminUserListScreen extends StatefulWidget {
  const SuperAdminUserListScreen({super.key});

  @override
  State<SuperAdminUserListScreen> createState() =>
      _SuperAdminUserListScreenState();
}

class _SuperAdminUserListScreenState
    extends State<SuperAdminUserListScreen> {
  List<dynamic> _users = [];
  List<dynamic> _filtered = [];
  bool _loading = true;
  int _filterRole = 0; // 0=semua, 1=user, 2=EO, 3=admin

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await AdminService.getAllUsers();
    if (res['status'] == 200) {
      _users = res['data'] as List;
      _applyFilter();
    }
    setState(() => _loading = false);
  }

  void _applyFilter() {
    if (_filterRole == 0) {
      _filtered = List.from(_users);
    } else {
      _filtered =
          _users.where((u) => u['role'] == _filterRole).toList();
    }
    setState(() {});
  }

  Color _roleColor(int? role) {
    switch (role) {
      case 1:
        return const Color(0xFF6C63FF);
      case 2:
        return const Color(0xFF3ECFCF);
      case 3:
        return const Color(0xFFFFA500);
      default:
        return Colors.white38;
    }
  }

  IconData _roleIcon(int? role) {
    switch (role) {
      case 1:
        return Icons.person_rounded;
      case 2:
        return Icons.business_center_rounded;
      case 3:
        return Icons.admin_panel_settings_rounded;
      default:
        return Icons.person_outline;
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
        title: const Text('Kelola User',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _load,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter Tabs ────────────────────────────────────────────────────
          Container(
            color: const Color(0xFF1A1A2E),
            child: Row(
              children: [
                _filterTab(0, 'Semua'),
                _filterTab(1, 'User'),
                _filterTab(2, 'EO'),
                _filterTab(3, 'Admin'),
              ],
            ),
          ),
          // ── Summary Bar ────────────────────────────────────────────────────
          Container(
            color: const Color(0xFF13131F),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.group, color: Colors.white38, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${_filtered.length} pengguna',
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
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
                        child: Text('Tidak ada user.',
                            style: TextStyle(color: Colors.white54)))
                    : RefreshIndicator(
                        color: const Color(0xFF6C63FF),
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) =>
                              _buildUserCard(_filtered[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _filterTab(int role, String label) {
    final selected = _filterRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _filterRole = role;
          _applyFilter();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? const Color(0xFF6C63FF)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF6C63FF) : Colors.white38,
              fontSize: 13,
              fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> u) {
    final role = u['role'] as int?;
    final isVerified = u['is_verified'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: _roleColor(role).withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _roleColor(role).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_roleIcon(role),
                color: _roleColor(role), size: 22),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        u['nama'] ?? '-',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Verified badge
                    if (isVerified)
                      const Icon(Icons.verified_rounded,
                          color: Color(0xFF43E97B), size: 16)
                    else
                      const Icon(Icons.cancel_outlined,
                          color: Colors.redAccent, size: 16),
                  ],
                ),
                const SizedBox(height: 2),
                Text('@${u['username'] ?? '-'}',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
                Text(u['email'] ?? '-',
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 11),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Role badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _roleColor(role).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              u['role_name'] ?? '-',
              style: TextStyle(
                  color: _roleColor(role),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

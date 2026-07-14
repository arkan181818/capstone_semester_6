import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/admin_service.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState
    extends State<SuperAdminDashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    final res = await AdminService.getDashboardStats();
    if (res['status'] == 200) {
      setState(() {
        _stats = res['data'];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  void _logout() {
    AuthService.accessToken = null;
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Super Admin',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _loadStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _logout,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : RefreshIndicator(
              color: const Color(0xFF6C63FF),
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ─────────────────────────────────────────────
                    _buildHeader(),
                    const SizedBox(height: 24),

                    // ── Stats Grid ─────────────────────────────────────────
                    const Text(
                      'Statistik Platform',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    _buildStatsGrid(),
                    const SizedBox(height: 28),

                    // ── Menu ───────────────────────────────────────────────
                    const Text(
                      'Menu Admin',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    _buildMenuCards(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selamat Datang,',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Text(
            'Super Admin 👋',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Event pending: ${_stats?['total_pending'] ?? 0} menunggu approval',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final items = [
      {
        'label': 'Total User',
        'value': '${_stats?['total_users'] ?? 0}',
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF6C63FF),
      },
      {
        'label': 'Event Organizer',
        'value': '${_stats?['total_eo'] ?? 0}',
        'icon': Icons.business_center_rounded,
        'color': const Color(0xFF3ECFCF),
      },
      {
        'label': 'Total Event',
        'value': '${_stats?['total_events'] ?? 0}',
        'icon': Icons.event_rounded,
        'color': const Color(0xFFFF6584),
      },
      {
        'label': 'Published',
        'value': '${_stats?['total_published'] ?? 0}',
        'icon': Icons.check_circle_rounded,
        'color': const Color(0xFF43E97B),
      },
      {
        'label': 'Pending Approval',
        'value': '${_stats?['total_pending'] ?? 0}',
        'icon': Icons.pending_actions_rounded,
        'color': const Color(0xFFFFA500),
      },
      {
        'label': 'Registrasi',
        'value': '${_stats?['total_registrasi'] ?? 0}',
        'icon': Icons.how_to_reg_rounded,
        'color': const Color(0xFFE040FB),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: (item['color'] as Color).withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(item['icon'] as IconData,
                  color: item['color'] as Color, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: TextStyle(
                        color: item['color'] as Color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuCards() {
    final menus = [
      {
        'title': 'Kelola Event',
        'subtitle': 'Approve / Reject event dari EO',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFF6C63FF),
        'route': AppRoutes.superadminEvents,
      },
      {
        'title': 'Kelola User',
        'subtitle': 'Lihat semua user & EO terdaftar',
        'icon': Icons.manage_accounts_rounded,
        'color': const Color(0xFF3ECFCF),
        'route': AppRoutes.superadminUsers,
      },
    ];

    return Column(
      children: menus.map((m) {
        return GestureDetector(
          onTap: () => Get.toNamed(m['route'] as String),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: (m['color'] as Color).withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (m['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(m['icon'] as IconData,
                      color: m['color'] as Color, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['title'] as String,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(m['subtitle'] as String,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white30, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

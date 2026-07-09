import 'dart:async';
import 'package:get/get.dart';

import '../models/event_model.dart';
import '../models/registration_model.dart';
import '../services/event_service.dart';
import '../services/auth_service.dart';

class DashboardController extends GetxController {
  final totalEvents = 0.obs;
  final totalParticipants = 0.obs;
  final totalRevenue = 'Rp 0'.obs;
  final liveEvents = 0.obs;

  final events = <EventModel>[].obs;
  final registrations = <RegistrationModel>[].obs;
  Timer? _pollTimer;

  @override
  void onInit() {
    super.onInit();
    loadData();
    // Start a periodic poll to refresh registrations every 5 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _loadRegistrations();
    });
  }

  Future<void> loadData() async {
    try {
      // diagnostic: check current user's role
      try {
        final me = await AuthService.getMe();
        if (me['status'] == 200 && me['data'] is Map && me['data']['role'] != null) {
          final role = me['data']['role'];
          print('Current user role: $role');
          if (role != 2) {
            // Not EO — show info message once
            Get.snackbar('Not EO', 'You are not logged in as EO. Dashboard EO data unavailable.', snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          print('GetMe status: ${me['status']}');
        }
      } catch (e) {
        print('getMe failed: $e');
      }

      final list = await EventService.getEOEvents();
      events.assignAll(list);
      totalEvents.value = list.length;
      liveEvents.value = list.where((e) {
        final s = e.status.toLowerCase();
        return s.contains('live') || s.contains('active') || s.contains('ongoing');
      }).length;

      // totalParticipants and totalRevenue are not provided by current API.
      // Keep them as zero or compute if you add an endpoint for registrations/revenue.
    } catch (err) {
      // ignore errors for now; you may show a toast or set error state
      events.clear();
      totalEvents.value = 0;
      liveEvents.value = 0;
    }
    // initial load of registrations
    await _loadRegistrations();
  }

  Future<void> _loadRegistrations() async {
    try {
      final allRegs = await EventService.getRegistrationsForEO();
      registrations.assignAll(allRegs);
    } catch (e) {
      registrations.clear();
    }
  }



  void createNewEvent() {}

  void viewAllEvents() {}

  void exportData() {}

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}

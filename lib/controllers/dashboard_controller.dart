import 'package:get/get.dart';

import '../models/event_model.dart';
import '../services/event_service.dart';

class DashboardController extends GetxController {
  final totalEvents = 0.obs;
  final totalParticipants = 0.obs;
  final totalRevenue = 'Rp 0'.obs;
  final liveEvents = 0.obs;

  final events = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
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
  }

  void createNewEvent() {}

  void viewAllEvents() {}

  void exportData() {}
}

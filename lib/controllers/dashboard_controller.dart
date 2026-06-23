import 'package:get/get.dart';

class DashboardController extends GetxController {
  final totalEvents = 42.obs;
  final totalParticipants = 8241.obs;
  final totalRevenue = 'Rp 1.2M'.obs;
  final liveEvents = 8.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize dashboard data
  }

  void createNewEvent() {
    // Handle create event action
  }

  void viewAllEvents() {
    // Handle view all events
  }

  void exportData() {
    // Handle export data
  }
}

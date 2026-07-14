import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/register_screen.dart';
import '../screens/runtrack_screen.dart';
import '../home_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../event_list_screen.dart';
import '../detail_event_screen.dart';
import '../payment_screen.dart';
import '../scanner_screen.dart';
import '../screens/eo_event_form_screen.dart';
import '../screens/eo_event_list_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../profile_screen.dart';
import '../riwayat_screen.dart';
import '../notification_screen.dart';
import '../screens/scan_history_screen.dart';
import '../screens/face_scan_simulation_screen.dart';
import '../screens/superadmin/superadmin_dashboard_screen.dart';
import '../screens/superadmin/superadmin_event_list_screen.dart';
import '../screens/superadmin/superadmin_user_list_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.runtrack, page: () => const RunTrackScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.otpVerification, page: () => OtpScreen(email: Get.arguments as String)),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.eventList, page: () => const EventListScreen()),
    GetPage(name: AppRoutes.detailEvent, page: () => DetailEventScreen.fromArgs()),
    GetPage(name: AppRoutes.payment, page: () => const PaymentScreen()),
    GetPage(name: AppRoutes.scanner, page: () => const ScannerScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfilePage()),
    GetPage(name: AppRoutes.eoEventList, page: () => const EOEventListScreen()),
    GetPage(name: AppRoutes.eoEventForm, page: () => const EOEventFormScreen()),
    GetPage(name: AppRoutes.riwayat, page: () => const RiwayatScreen()),
    GetPage(name: AppRoutes.notification, page: () => const NotificationScreen()),
    GetPage(name: AppRoutes.riwayatScan, page: () => const ScanHistoryScreen()),
    GetPage(name: AppRoutes.faceScan, page: () => const FaceScanSimulationScreen()),
    // Super Admin
    GetPage(name: AppRoutes.superadminDashboard, page: () => const SuperAdminDashboardScreen()),
    GetPage(name: AppRoutes.superadminEvents, page: () => const SuperAdminEventListScreen()),
    GetPage(name: AppRoutes.superadminUsers, page: () => const SuperAdminUserListScreen()),
  ];
}

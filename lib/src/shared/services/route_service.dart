import 'package:flutter/material.dart';
import 'package:project_pjam_2023/src/features/feedback_history/feedback_history.dart';
import 'package:project_pjam_2023/src/features/user_profile/user_profile.dart';

import '../../features/authentication/login/login_page.dart';
import '../../features/authentication/register/register_page.dart';
import '../../features/error/error_page.dart';
import '../../features/home/home_page.dart';
import '../../features/image_details/image_details.dart';
import '../../features/my_images/my_images.dart';
import '../../features/my_patients/my_patients.dart';
import '../../features/my_patients_images/my_patients_images.dart';
import '../../features/patient_images/patient_images.dart';
import '../../features/splash_screen/splash_screen.dart';
import '../../features/upload_image/upload_image.dart';
import '../configs/constants.dart' as constants;

class RouteItem {
  final String description;
  final String routeName;
  final bool inDrawer;
  Widget page;
  final IconData? icon;
  List<String>? roles;

  RouteItem(
      {required this.description,
      required this.routeName,
      this.inDrawer = false,
      required this.page,
      this.icon,
      this.roles});
}

class RouteService {
  static List<RouteItem> routes = [
    RouteItem(
        description: 'Splash',
        routeName: '/splash',
        page: const SplashScreen()),
    RouteItem(
        description: 'Error', routeName: '/error', page: const ErrorPage()),
    RouteItem(
        description: 'Login', routeName: '/login', page: const LoginPage()),
    RouteItem(
        description: 'Register',
        routeName: '/register',
        page: const RegisterPage()),
    RouteItem(
        description: 'Home',
        routeName: '/home',
        inDrawer: true,
        page: const HomePage(),
        icon: Icons.home,
        roles: [constants.rolePatient, constants.roleClinician]),
    RouteItem(
        description: 'Upload Image',
        routeName: '/upload-image',
        inDrawer: true,
        page: const UploadImagePage(),
        icon: Icons.upload_rounded,
        roles: [constants.rolePatient]),
    RouteItem(
        description: 'My Images',
        routeName: '/my-images',
        inDrawer: true,
        page: const MyImages(),
        icon: Icons.image,
        roles: [constants.rolePatient]),
    RouteItem(
        description: 'Image Details',
        routeName: '/image-details',
        page: const ImageDetails()),
    RouteItem(
        description: "My Patients' Images",
        routeName: '/patients-images',
        inDrawer: true,
        page: const MyPatientsImages(),
        icon: Icons.image,
        roles: [constants.roleClinician]),
    RouteItem(
        description: 'Patient Images',
        routeName: '/patient-images',
        page: const PatientImages(),
        roles: [constants.roleClinician]),
    RouteItem(
        description: 'My Patients',
        routeName: '/my-patients',
        inDrawer: true,
        page: const MyPatients(),
        icon: Icons.person,
        roles: [constants.roleClinician]),
    RouteItem(
        description: 'Feedback History',
        routeName: '/feedback-history',
        inDrawer: true,
        page: const FeedbackHistory(),
        icon: Icons.feedback,
        roles: [constants.roleClinician]),
    RouteItem(
        description: 'Profile',
        routeName: '/profile',
        inDrawer: true,
        page: const UserProfile(),
        icon: Icons.person,
        roles: [constants.rolePatient, constants.roleClinician]),
  ];

  static RouteItem getRouteByName(String name) {
    return RouteService.routes.firstWhere(
      (route) => route.description.toLowerCase() == name.toLowerCase(),
      orElse: () => getRouteByName('Error'),
    );
  }

  static Map<String, Widget Function(BuildContext)> getRoutes(
      BuildContext context) {
    Map<String, Widget Function(BuildContext)> routesMap = {};
    for (RouteItem route in routes) {
      routesMap.putIfAbsent(
          route.routeName, () => (BuildContext context) => route.page);
    }
    return routesMap;
  }

  static List<RouteItem> getRoutesInDrawer() {
    return routes.where((route) => route.inDrawer).toList();
  }

  static bool canAccessRoute(String routeName, String role) {
    RouteItem routeItem = getRouteByName(routeName);
    if (routeItem.roles == null) {
      return true;
    }
    return routeItem.roles!.contains(role);
  }
}

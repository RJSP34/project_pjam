import 'package:flutter/material.dart';

import '../../features/error/error_page.dart';
import 'route_service.dart';

class NavigationService {
  NavigationService._();

  static final NavigationService _instance = NavigationService._();

  factory NavigationService() => _instance;

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  void goBack([dynamic popValue]) {
    navigationKey.currentState?.pop(popValue);
  }

  Future<dynamic> navigateToScreen(String routeName,
      {dynamic arguments}) async {
    final RouteItem routeItem = RouteService.getRouteByName(routeName);
    return navigationKey.currentState?.pushNamed(
      routeItem.routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateToErrorScreen(String? title, String? message) async {
    RouteItem routeItem = RouteService.getRouteByName("Error");
    routeItem.page = ErrorPage(
      title: title,
      message: message,
    );
    return navigationKey.currentState?.pushNamed(
      routeItem.routeName,
    );
  }

  Future<dynamic> replaceScreen(String routeName,
      {String? title, String? message, dynamic arguments}) async {
    final RouteItem routeItem = RouteService.getRouteByName(routeName);

    if (routeItem.description == "Error") {
      return navigateToErrorScreen(title, message);
    }
    return navigationKey.currentState?.pushReplacementNamed(
      routeItem.routeName,
      arguments: arguments,
    );
  }

  void popToFirst() {
    navigationKey.currentState
        ?.pushNamedAndRemoveUntil("/home", (route) => false);
  }
}

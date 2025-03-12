import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../services/route_service.dart';
import '../services/snackbar_service.dart';

class MyDrawer extends StatelessWidget {
  final List<RouteItem> routesInDrawer = RouteService.getRoutesInDrawer();

  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getUserRole();

    return Drawer(
      child: ListView(
        children: [
          for (var route in routesInDrawer)
            if (RouteService.canAccessRoute(route.description, role))
              ListTile(
                leading: route.icon != null ? Icon(route.icon) : null,
                title: Text(route.description),
                onTap: () {
                  String currentRoute =
                      ModalRoute.of(context)?.settings.name ?? "";
                  if (currentRoute != route.routeName) {
                    NavigationService().replaceScreen(route.description);
                  }
                },
              ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              try {
                await ApiService().logout();
                SnackbarService.showSuccessSnackbar("Logout successful");
              } catch (error) {
                SnackbarService.showErrorSnackbar(
                    "An error occurred during logout");
              }
              NavigationService().replaceScreen('Login');
            },
          ),
        ],
      ),
    );
  }
}

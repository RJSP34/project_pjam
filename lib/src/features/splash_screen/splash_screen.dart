import 'package:flutter/material.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/services/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    bool isTokenValid = await AuthService().isAuthTokenValid();
    // await Future.delayed(const Duration(seconds: 2));

    if (isTokenValid) {
      NavigationService().replaceScreen('Home');
    } else {
      NavigationService().replaceScreen('Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

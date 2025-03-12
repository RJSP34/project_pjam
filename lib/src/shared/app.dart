import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './configs/constants.dart' as constants;
import './services/navigation_service.dart';
import './services/route_service.dart';
import './services/snackbar_service.dart';
import '../features/authentication/login/login_provider.dart';
import '../features/authentication/register/register_provider.dart';
import '../features/feedback_history/feedback_history_provider.dart';
import '../features/home/home_provider.dart';
import '../features/image_details/image_details_provider.dart';
import '../features/my_images/my_images_provider.dart';
import '../features/my_patients/my_patients_provider.dart';
import '../features/my_patients_images/my_patients_images_provider.dart';
import '../features/patient_images/patient_images_provider.dart';
import '../features/upload_image/upload_image_provider.dart';
import '../features/user_profile/user_profile_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyImagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageDetailsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PatientsImagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FeedbackHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserImagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyPatientsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        title: constants.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
        navigatorKey: NavigationService().navigationKey,
        initialRoute: '/splash',
        routes: RouteService.getRoutes(context),
      ),
    );
  }
}

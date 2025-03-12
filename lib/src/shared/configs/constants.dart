import 'package:flutter_dotenv/flutter_dotenv.dart';

// App constants
const String appName = 'PJAM App';

// API constants
final String apiDomain = dotenv.env['API_DOMAIN'] ?? '';

// Role constants
const String rolePatient = "user";
const String roleClinician = "clinician";

// Asset constants
//...

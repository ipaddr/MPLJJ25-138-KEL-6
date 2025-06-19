import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Tambahkan import dotenv

import 'firebase_options.dart';
import 'screens/initial/first_screen.dart';
import 'screens/user_flow/login_screen.dart';
import 'screens/user_flow/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/admin/admin_register_screen.dart';
import 'screens/health_checkup/page_health_checkup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi dotenv
  try {
    await dotenv.load(fileName: ".env");
    print("✅ Environment variables loaded successfully");
  } catch (e) {
    print("❌ Error loading .env file: $e");
  }

  // ✅ Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeHealthy',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFEFF6FF),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/admin_register': (context) => const AdminRegisterScreen(),
        '/health_checkup': (context) => const PageHealthCheckup(),
      },
    );
  }
}

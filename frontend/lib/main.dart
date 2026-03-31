import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/animal_list_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load saved user (from SharedPreferences)
  bool isLoggedIn = await AuthService.loadUser();
  String? userEmail = AuthService.getCurrentUserEmail();

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    currentUserEmail: userEmail,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? currentUserEmail;

  const MyApp({
    Key? key,
    required this.isLoggedIn,
    this.currentUserEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buffalo Dairy Farm',
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,

      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/dashboard': (context) =>
            DashboardScreen(currentUserEmail: currentUserEmail ?? ''),
        '/animals': (context) => AnimalListScreen(),
      },

      // ✅ Splash decides where to go
      home: SplashScreen(
        isLoggedIn: isLoggedIn,
        currentUserEmail: currentUserEmail,
      ),
    );
  }
}
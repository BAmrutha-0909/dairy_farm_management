import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  final String? currentUserEmail;
  SplashScreen({required this.isLoggedIn, this.currentUserEmail});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => widget.isLoggedIn && widget.currentUserEmail != null
              ? DashboardScreen(currentUserEmail: widget.currentUserEmail!)
              : LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFDE8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/welcome.png', width: 240, fit: BoxFit.contain),
              SizedBox(height: 20),
              Text('🐄 Smart Dairy Manager',
                  style: TextStyle(
                      color: Color(0xFF34553d),
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                  )),
              SizedBox(height: 10),
              Text('Track Milk • Manage Cattle • Boost Profits',
                  style: TextStyle(
                      color: Color(0xFF51784e),
                      fontSize: 18
                  ),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

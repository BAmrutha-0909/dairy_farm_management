import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _showForgetPasswordDialog() async {
    final forgetEmailController = TextEditingController();
    bool emailSent = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Forgot Password'),
          content: emailSent
              ? Text('An email has been sent to ${forgetEmailController.text}')
              : TextField(
                  controller: forgetEmailController,
                  decoration: InputDecoration(labelText: 'Enter your email'),
                ),
          actions: [
            if (!emailSent)
              TextButton(
                child: Text('Send'),
                onPressed: () {
                  // NOT CONNECTED TO BACKEND (still fake)
                  setState(() {
                    emailSent = true;
                  });
                },
              ),
            TextButton(
              child: Text(emailSent ? 'Close' : 'Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("LOGIN BUTTON CLICKED");
      print("EMAIL: $email");
      print("PASSWORD: $password");

      final response = await AuthService.login(email, password);

      print("RESPONSE: $response");

      if (response != null && response['token'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              currentUserEmail: response['email'] ?? email,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?['message'] ?? 'Login failed'),
          ),
        );
      }
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error. Check backend.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgetPasswordDialog,
                child: Text('Forgot Password?'),
              ),
            ),
            SizedBox(height: 12),

            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),

            TextButton(
              onPressed: _goToSignup,
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields required")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("SIGNUP BUTTON CLICKED");

      final response = await AuthService.register(name, email, password);

      print("SIGNUP RESPONSE: $response");

      if (response != null &&
          (response['message'] == "User registered successfully" ||
           response['token'] != null)) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful")),
        );

        Navigator.pop(context); // go back to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?['message'] ?? "Signup failed"),
          ),
        );
      }
    } catch (e) {
      print("SIGNUP ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),

            SizedBox(height: 20),

            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signup,
                    child: Text("Sign Up"),
                  ),

            SizedBox(height: 10),

            // 🔥 THIS WAS MISSING
            TextButton(
              onPressed: () {
                Navigator.pop(context); // back to login
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
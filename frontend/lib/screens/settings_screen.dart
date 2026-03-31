import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userEmail;
  final String? phoneNumber;
  final String? userName;

  const SettingsScreen({
    Key? key,
    required this.userEmail,
    this.phoneNumber,
    this.userName,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _profileExpanded = false;
  bool _editingProfile = false;

  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.userEmail);
    _phoneController = TextEditingController(text: widget.phoneNumber ?? '');
    _nameController = TextEditingController(text: widget.userName ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    setState(() {
      _profileExpanded = !_profileExpanded;
      if (!_profileExpanded) _editingProfile = false;
    });
  }

  void _toggleEditProfile() {
    setState(() {
      _editingProfile = !_editingProfile;
    });
  }

  final _phoneInputFormatter = [
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.digitsOnly,
  ];

  Future<void> _logout() async {
    await AuthService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Add actual delete logic here
      await AuthService.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildProfileDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            _editingProfile
                ? Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'UserName'),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        inputFormatters: _phoneInputFormatter,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              // TODO: Save profile update here
                              _toggleEditProfile();
                            },
                          ),
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: _toggleEditProfile,
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UserName: ${_nameController.text}'),
                      const SizedBox(height: 8),
                      Text('Email: ${_emailController.text}'),
                      const SizedBox(height: 8),
                      Text('Phone: ${_phoneController.text}'),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: _toggleEditProfile,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                        onTap: _deleteAccount,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('About the App'),
              content: const Text(
                  'This is a Dairy Farming app designed to help manage animals, track milk production, sales, expenses, and vaccinations efficiently.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'))
              ],
            ));
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsButton(
            icon: Icons.account_circle,
            label: 'Profile',
            onTap: _toggleProfile,
          ),
          if (_profileExpanded) _buildProfileDetails(),
          _buildSettingsButton(
            icon: Icons.info_outline,
            label: 'About the App',
            onTap: _showAboutDialog,
          ),
          _buildSettingsButton(
            icon: Icons.info,
            label: 'Version 1.0.0',
            onTap: () {},
          ),
          _buildSettingsButton(
            icon: Icons.logout,
            label: 'Logout',
            textColor: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}

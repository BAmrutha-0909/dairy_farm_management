import 'package:flutter/material.dart';
import '../screens/animal_list_screen.dart';
import '../screens/milk_entry_screen.dart';
import '../screens/sales_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/vaccination_screen.dart';
import 'package:diary_farming/screens/settings_screen.dart';

class AppNavigationDrawer extends StatelessWidget {
  final String currentUserEmail;

  const AppNavigationDrawer({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.brown),
            child: Text('Buffalo Dairy Farm App', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Animals'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AnimalListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_drink),
            title: Text('Milk Entry'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MilkEntryScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Sales'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SalesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Reports'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReportsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Vaccinations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VaccinationScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen(userEmail: currentUserEmail)),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';
import '../widgets/navigation_drawer.dart' as custom_drawer;

import '../models/animal.dart';
import '../models/milk_log.dart';
import '../models/sale.dart';
import '../models/vaccination.dart';
import '../services/db_service.dart';

import 'animal_list_screen.dart';
import 'milk_entry_screen.dart';
import 'sales_screen.dart';
import '../screens/vaccination_screen.dart';
import 'package:diary_farming/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String currentUserEmail;

  const DashboardScreen({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Animal> animals = [];
  List<MilkLog> milkLogs = [];
  List<Sale> sales = [];
  List<Vaccination> vaccinations = [];

  Future<void> fetchData() async {
    animals = await DBService.getAnimals();
    milkLogs = await DBService.getMilkLogs();
    sales = await DBService.getSales();
    vaccinations = await DBService.getVaccinations();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  int getTotalBuffaloes() => animals.length;

  double getMilkToday() {
    final today = DateTime.now();
    return milkLogs.where((log) =>
      log.date.year == today.year &&
      log.date.month == today.month &&
      log.date.day == today.day
    ).fold(0.0, (sum, log) => sum + log.liters);
  }

  double getProfitLoss() {
    final revenue = sales.fold(0.0, (sum, sale) => sum + sale.litersSold * sale.pricePerLiter);
    final cost = animals.fold(0.0, (sum, animal) => sum + (animal.purchasePrice ?? 0));
    return revenue - cost;
  }

  int getVaccinationsDue() {
    final today = DateTime.now();
    return vaccinations.where((v) => v.dueDate.isBefore(today) && v.completionDate == null).length;
  }

  Future<void> _navigateToAnimals(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnimalListScreen(onChange: fetchData)),
    );
  }

  Future<void> _navigateToVaccinations(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VaccinationScreen(onChange: fetchData)),
    );
  }

  Future<void> _navigateToMilkEntry(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MilkEntryScreen(onChange: fetchData)),
    );
  }

  Future<void> _navigateToSales(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SalesScreen(onChange: fetchData)),
    );
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen(userEmail: widget.currentUserEmail)),
    );
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final totalBuffaloes = getTotalBuffaloes();
    final milkToday = getMilkToday();
    final profitLoss = getProfitLoss();
    final vaccinationsDue = getVaccinationsDue();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: custom_drawer.AppNavigationDrawer(currentUserEmail: widget.currentUserEmail),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                SummaryCard(
                  title: 'Total Buffaloes',
                  value: '$totalBuffaloes',
                  icon: Icons.pets,
                  imageWidget: Image.asset(
  'assets/paw.png',
  height: 56,
  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 56)
),
                ),
                SummaryCard(
                  title: 'Milk Today',
                  value: '${milkToday.toStringAsFixed(1)} L',
                  icon: Icons.local_drink,
                  imageWidget: Image.asset('assets/milk.png', height: 56),
                ),
                SummaryCard(
                  title: 'Profit/Loss',
                  value: '${profitLoss >= 0 ? '+' : '-'}₹${profitLoss.abs().toStringAsFixed(0)}',
                  icon: Icons.account_balance_wallet,
                  imageWidget: Image.asset('assets/scale.png', height: 56),
                ),
                SummaryCard(
                  title: 'Vaccinations',
                  value: '$vaccinationsDue due',
                  icon: Icons.vaccines,
                  imageWidget: Image.asset('assets/vaccine.png', height: 56),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickButton(context, Icons.pets, 'Buffaloes', _navigateToAnimals),
                _quickButton(context, Icons.local_hospital, 'Vaccinations', _navigateToVaccinations),
                _quickButton(context, Icons.local_drink, 'Milk Entry', _navigateToMilkEntry),
                _quickButton(context, Icons.attach_money, 'Sales', _navigateToSales),
                _quickButton(context, Icons.settings, 'Settings', _navigateToSettings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickButton(BuildContext context, IconData icon, String label, void Function(BuildContext) onTap) {
    return Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            shape: const CircleBorder(),
          ),
          child: IconButton(icon: Icon(icon), iconSize: 32, onPressed: () => onTap(context)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

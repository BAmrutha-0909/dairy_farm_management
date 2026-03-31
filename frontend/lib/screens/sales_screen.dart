import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../models/animal.dart';
import '../models/milk_log.dart';
import '../services/db_service.dart';

class SalesScreen extends StatefulWidget {
  final VoidCallback? onChange;
  const SalesScreen({super.key, this.onChange});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _amountController = TextEditingController();
  final _milkController = TextEditingController();

  String? selectedAnimalId;
  double availableMilk = 0;

  List<Animal> animals = [];
  List<MilkLog> milkLogs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    animals = await DBService.getAnimals();
    milkLogs = await DBService.getMilkLogs();
    setState(() {});
  }

  // ✅ calculate remaining milk
  void _calculateAvailableMilk() {
    if (selectedAnimalId == null) return;

    final totalMilk = milkLogs
        .where((m) => m.animalId == selectedAnimalId)
        .fold(0.0, (sum, m) => sum + m.quantity);

    final totalSold = DBService.sales
        .where((s) => s.buffaloId == selectedAnimalId)
        .fold(0.0, (sum, s) => sum + s.milkSold);

    setState(() {
      availableMilk = totalMilk - totalSold;
      if (availableMilk < 0) availableMilk = 0;
    });
  }

  // ✅ log sale with validation
  void _logSale() {
    if (selectedAnimalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a buffalo")),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    final milkSold = double.tryParse(_milkController.text) ?? 0;

    // ❌ prevent overselling
    if (milkSold > availableMilk) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Not enough milk"),
          content: Text(
            "Only ${availableMilk.toStringAsFixed(2)} L available for this buffalo.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    final sale = Sale(
      buffaloId: selectedAnimalId!, // matches your Sale model
      date: DateTime.now(),
      amount: amount,
      milkSold: milkSold,
    );

    setState(() {
      DBService.sales.add(sale);
      _amountController.clear();
      _milkController.clear();
      _calculateAvailableMilk();
    });

    widget.onChange?.call();
  }

  @override
  Widget build(BuildContext context) {
    final sales = DBService.sales.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Buffalo dropdown
            DropdownButtonFormField<String>(
              value: selectedAnimalId,
              hint: const Text("Select Buffalo"),
              items: animals.map((animal) {
                return DropdownMenuItem<String>(
                  value: animal.id,
                  child: Text("${animal.name} (ID: ${animal.id})"),
                );
              }).toList(),
              onChanged: (value) {
                selectedAnimalId = value;
                _calculateAvailableMilk();
              },
            ),

            const SizedBox(height: 8),

            // ✅ available milk display
            if (selectedAnimalId != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Available Milk: ${availableMilk.toStringAsFixed(2)} L",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),

            TextField(
              controller: _milkController,
              decoration:
                  const InputDecoration(labelText: "Milk Sold (L)"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _logSale,
              child: const Text("Log Sale"),
            ),

            const SizedBox(height: 24),

            // ✅ sales list
            Expanded(
              child: sales.isEmpty
                  ? const Center(
                      child: Text(
                        "No sales logged yet.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sales.length,
                      itemBuilder: (context, index) {
                        final sale = sales[index];
                        return Card(
                          margin:
                              const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              '₹${sale.amount.toStringAsFixed(2)} - ${sale.milkSold.toStringAsFixed(2)} L',
                            ),
                            subtitle: Text(
                              'Buffalo ID: ${sale.buffaloId}\n'
                              '${sale.date.day}/${sale.date.month}/${sale.date.year} '
                              '${sale.date.hour}:${sale.date.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
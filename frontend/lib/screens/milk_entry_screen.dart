import 'package:flutter/material.dart';
import '../models/milk_log.dart';
import '../models/animal.dart';
import '../services/db_service.dart';

class MilkEntryScreen extends StatefulWidget {
  final VoidCallback? onChange;
  const MilkEntryScreen({Key? key, this.onChange}) : super(key: key);

  @override
  State<MilkEntryScreen> createState() => _MilkEntryScreenState();
}

class _MilkEntryScreenState extends State<MilkEntryScreen> {
  List<MilkLog> milkEntries = [];

  @override
  void initState() {
    super.initState();
    fetchMilkEntries();
  }

  Future<void> fetchMilkEntries() async {
    milkEntries = await DBService.getMilkLogs();
    setState(() {});
  }

  // ✅ Dialog with buffalo dropdown
  Future<void> _showAddDialog() async {
    final quantityController = TextEditingController();

    List<Animal> animals = await DBService.getAnimals();
    String? selectedAnimalId;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          title: const Text('Add Milk Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                  setLocalState(() {
                    selectedAnimalId = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              TextField(
                controller: quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: "Quantity (L)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                final quantity =
                    double.tryParse(quantityController.text.trim()) ?? 0;

                if (selectedAnimalId != null && quantity > 0) {
                  await DBService.addMilkLog(
                    MilkLog(
                      animalId: selectedAnimalId!,
                      date: DateTime.now(),
                      quantity: quantity,
                    ),
                  );

                  widget.onChange?.call();
                  await fetchMilkEntries();
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Please select buffalo and enter quantity"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Milk Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: milkEntries.isEmpty
            ? const Center(child: Text("No milk entries yet."))
            : ListView.builder(
                itemCount: milkEntries.length,
                itemBuilder: (context, index) {
                  final log = milkEntries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        "Buffalo ID: ${log.animalId}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Quantity: ${log.quantity.toStringAsFixed(1)} L\n"
                        "Date: ${_formatDate(log.date)}",
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add Milk"),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} "
        "${date.hour.toString().padLeft(2, "0")}:"
        "${date.minute.toString().padLeft(2, "0")}";
  }
}
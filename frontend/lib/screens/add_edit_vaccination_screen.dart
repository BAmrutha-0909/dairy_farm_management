import 'package:flutter/material.dart';
import '../models/vaccination.dart';
import '../models/animal.dart';
import '../services/db_service.dart';

class AddEditVaccinationScreen extends StatefulWidget {
  final VoidCallback? onSaved;

  const AddEditVaccinationScreen({Key? key, this.onSaved})
      : super(key: key);

  @override
  State<AddEditVaccinationScreen> createState() =>
      _AddEditVaccinationScreenState();
}

class _AddEditVaccinationScreenState
    extends State<AddEditVaccinationScreen> {
  final _vaccineController = TextEditingController();

  String? selectedAnimalId; // ✅ dropdown value
  DateTime? dueDate;
  DateTime? completionDate;

  List<Animal> animals = [];

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  // ✅ load buffalo list
  Future<void> _loadAnimals() async {
    animals = await DBService.getAnimals();
    setState(() {});
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  Future<void> _pickCompletionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: dueDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => completionDate = picked);
    }
  }

  Future<void> _save() async {
    if (selectedAnimalId == null ||
        _vaccineController.text.trim().isEmpty ||
        dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    final vaccination = Vaccination(
      animalId: selectedAnimalId!, // ✅ FIXED
      vaccine: _vaccineController.text.trim(),
      dueDate: dueDate!,
      completionDate: completionDate,
    );

    await DBService.addVaccination(vaccination);
    widget.onSaved?.call();
    Navigator.pop(context);
  }

  String _fmt(DateTime? d) =>
      d == null ? "Select Date" : "${d.day}/${d.month}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vaccination")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ DROPDOWN (same styling preserved)
            DropdownButtonFormField<String>(
              value: selectedAnimalId,
              decoration: const InputDecoration(labelText: "Animal ID"),
              items: animals.map((animal) {
                return DropdownMenuItem<String>(
                  value: animal.id,
                  child: Text(animal.id),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedAnimalId = value);
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _vaccineController,
              decoration:
                  const InputDecoration(labelText: "Vaccine Name"),
            ),

            const SizedBox(height: 16),

            Center(
  child: TextButton(
    onPressed: _pickDueDate,
    child: Text("Due Date: ${_fmt(dueDate)}"),
  ),
),

Center(
  child: TextButton(
    onPressed: _pickCompletionDate,
    child: Text(
      "Completion Date (optional): ${_fmt(completionDate)}",
    ),
  ),
),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
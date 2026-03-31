import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/db_service.dart';

class AddEditAnimalScreen extends StatefulWidget {
  final Animal? animal;
  final VoidCallback? onSaved;
  AddEditAnimalScreen({this.animal, this.onSaved});

  @override
  _AddEditAnimalScreenState createState() => _AddEditAnimalScreenState();
}

class _AddEditAnimalScreenState extends State<AddEditAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _breedController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  DateTime? _purchaseDate;

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      _idController.text = widget.animal!.id;
      _breedController.text = widget.animal!.name;
      if (widget.animal!.purchasePrice != null) {
        _purchasePriceController.text = widget.animal!.purchasePrice.toString();
      }
      _purchaseDate = widget.animal!.purchaseDate;
    }
  }

  Future<void> _selectPurchaseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final id = _idController.text.trim();
    final breed = _breedController.text.trim();
    final price = double.tryParse(_purchasePriceController.text.trim()) ?? 0;

    Animal animal = Animal(
      id: id,
      name: breed,
      purchasePrice: price,
      purchaseDate: _purchaseDate,
      dailyMilk: widget.animal?.dailyMilk ?? 0,
    );

    if (widget.animal != null) {
      await DBService.updateAnimal(animal);
    } else {
      await DBService.addAnimal(animal);
    }

    widget.onSaved?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.animal != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Buffalo' : 'Add Buffalo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter ID' : null,
                enabled: !isEditing,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter breed' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _purchasePriceController,
                decoration: InputDecoration(labelText: 'Purchase Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter price';
                  if (double.tryParse(value) == null) return 'Enter valid number';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: _selectPurchaseDate,
                child: Text(_purchaseDate == null
                    ? 'Select Purchase Date'
                    : 'Purchased: ${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(isEditing ? 'Update' : 'Save'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

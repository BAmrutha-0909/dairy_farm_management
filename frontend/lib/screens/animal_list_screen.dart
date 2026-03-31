import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/db_service.dart';
import 'add_edit_animal_screen.dart';

class AnimalListScreen extends StatefulWidget {
  final VoidCallback? onChange;

  AnimalListScreen({this.onChange});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> animals = [];

  Future<void> fetchAnimals() async {
    animals = await DBService.getAnimals();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  Future<void> _afterEditOrAdd() async {
    await fetchAnimals();
    if (widget.onChange != null) widget.onChange!();
  }

  Future<void> _deleteAnimal(String id) async {
    await DBService.deleteAnimal(id);
    await fetchAnimals();
    if (widget.onChange != null) widget.onChange!();
  }

  Future<void> _showDeleteDialog(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Buffalo'),
        content: Text('Are you sure you want to delete this buffalo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (result == true) {
      await _deleteAnimal(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buffalo List')),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 12, left: 6, right: 6),
        itemCount: animals.length,
        itemBuilder: (context, index) {
          final animal = animals[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple[100],
                child: Text(
                  animal.name.isNotEmpty ? animal.name[0].toUpperCase() : "?",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(animal.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${animal.id}'),
                  Text('Purchased: ${animal.purchaseDate != null ? "${animal.purchaseDate!.day}/${animal.purchaseDate!.month}/${animal.purchaseDate!.year}" : "N/A"}'),
                  Text('Price: ₹${(animal.purchasePrice ?? 0).toStringAsFixed(2)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddEditAnimalScreen(animal: animal, onSaved: _afterEditOrAdd)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _showDeleteDialog(animal.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditAnimalScreen(onSaved: _afterEditOrAdd)),
          );
        },
      ),
    );
  }
}

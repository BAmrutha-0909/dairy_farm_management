import 'package:flutter/material.dart';
import '../models/animal.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final VoidCallback onEdit;

  AnimalCard({required this.animal, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(animal.name),
        subtitle: Text("ID: ${animal.id}, Milk: ${animal.dailyMilk} L/day"),
        trailing: IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
      ),
    );
  }
}

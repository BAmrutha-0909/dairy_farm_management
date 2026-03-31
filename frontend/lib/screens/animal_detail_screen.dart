import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/vaccination.dart';
import '../services/db_service.dart';

// Helper function
Future<List<Vaccination>> fetchVaccinationsForAnimal(String animalId) async {
  return DBService.vaccinations.where((v) => v.animalId == animalId).toList();
}

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;
  AnimalDetailScreen({required this.animal});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${animal.name} Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Buffalo ID: ${animal.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Milk Output: ${animal.dailyMilk} L/day', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Purchase Price: ₹${animal.purchasePrice?.toStringAsFixed(2) ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Purchase Date: ${_formatDate(animal.purchaseDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Vaccinations:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            FutureBuilder<List<Vaccination>>(
              future: fetchVaccinationsForAnimal(animal.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading vaccinations...');
                } else if (snapshot.hasError) {
                  return Text('Error loading vaccinations');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No vaccinations found');
                }
                final vaccs = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: vaccs
                      .map((v) => Text('${v.vaccine} on ${_formatDate(v.dueDate)}'))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

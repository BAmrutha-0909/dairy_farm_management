import 'package:flutter/material.dart';
import '../models/vaccination.dart';
import '../services/db_service.dart';
import 'add_edit_vaccination_screen.dart';

class VaccinationScreen extends StatefulWidget {
  final VoidCallback? onChange;
  VaccinationScreen({this.onChange});

  @override
  _VaccinationScreenState createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  List<Vaccination> vaccinations = [];

  Future<void> fetchVaccinations() async {
    vaccinations = await DBService.getVaccinations();
    setState(() {});
    widget.onChange?.call();
  }

  @override
  void initState() {
    super.initState();
    fetchVaccinations();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vaccinations')),
      body: vaccinations.isEmpty
          ? Center(child: Text('No vaccinations found'))
          : ListView.builder(
              itemCount: vaccinations.length,
              itemBuilder: (context, index) {
                final v = vaccinations[index];
                return ListTile(
                  title: Text(v.vaccine),
                  subtitle: Text(
                    'Animal ID: ${v.animalId}\nDue Date: ${_formatDate(v.dueDate)}',
                  ),
                  trailing: v.completionDate == null
                      ? Text('Pending', style: TextStyle(color: Colors.red))
                      : Text('Completed', style: TextStyle(color: Colors.green)),
                  isThreeLine: true,
                  onTap: v.completionDate == null
                      ? () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: v.dueDate,
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            final updatedVaccination = Vaccination(
                              animalId: v.animalId,
                              vaccine: v.vaccine,
                              dueDate: v.dueDate,
                              completionDate: picked,
                            );
                            await DBService.updateVaccination(updatedVaccination);
                            await fetchVaccinations();
                          }
                        }
                      : null,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddEditVaccinationScreen(onSaved: fetchVaccinations),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Vaccination',
      ),
    );
  }
}

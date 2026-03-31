import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../services/ml_service.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // ✅ FIXED inclusive date filter
  bool _isInDateRange(DateTime date) {
    if (_startDate == null || _endDate == null) return true;

    final start =
        DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final end = DateTime(
        _endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);

    return !date.isBefore(start) && !date.isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final filterActive = _startDate != null && _endDate != null;

    // ✅ filtered data
    final filteredSales = filterActive
        ? DBService.sales.where((s) => _isInDateRange(s.date)).toList()
        : DBService.sales.toList();

    final filteredMilkLogs = filterActive
        ? DBService.milkLogs.where((m) => _isInDateRange(m.date)).toList()
        : DBService.milkLogs.toList();

    final filteredAnimals = filterActive
        ? DBService.animals
            .where((a) =>
                a.purchaseDate != null &&
                _isInDateRange(a.purchaseDate!))
            .toList()
        : DBService.animals.toList();

    // ✅ totals
    final totalBuffaloes =
        filterActive ? filteredAnimals.length : DBService.animals.length;

    final milkProduced =
        filteredMilkLogs.fold(0.0, (sum, m) => sum + m.liters);

    final totalSalesAmount =
        filteredSales.fold(0.0, (sum, s) => sum + s.amount);

    final totalLitersSold =
        filteredSales.fold(0.0, (sum, s) => sum + s.litersSold);

    final totalExpenses =
        filteredAnimals.fold(0.0, (sum, a) => sum + (a.purchasePrice ?? 0));

    final profitLoss = totalSalesAmount - totalExpenses;

    final mlPredictedProfit =
        MLService.predictProfit(totalSalesAmount, totalExpenses);

    // ✅ vaccinations
    final vaccinationsDue = DBService.vaccinations.where((v) {
      final inRange = filterActive ? _isInDateRange(v.dueDate) : true;
      return v.dueDate.isBefore(DateTime.now()) &&
          v.completionDate == null &&
          inRange;
    }).length;

    final vaccinationsCompleted = DBService.vaccinations.where((v) {
      if (v.completionDate == null) return false;
      return filterActive ? _isInDateRange(v.completionDate!) : true;
    }).length;

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ✅ date pickers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(_startDate == null
                          ? 'Select Start Date'
                          : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickDate(isStart: false),
                      child: Text(_endDate == null
                          ? 'Select End Date'
                          : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _buildInfoCard(
                    context, 'Total Buffaloes', totalBuffaloes.toString()),
                _buildInfoCard(context, 'Milk Produced',
                    '${milkProduced.toStringAsFixed(2)} L'),
                _buildInfoCard(context, 'Total Sales',
                    '₹${totalSalesAmount.toStringAsFixed(2)}'),
                _buildInfoCard(context, 'Liters Sold',
                    '${totalLitersSold.toStringAsFixed(2)} L'),
                _buildInfoCard(context, 'Total Expenses',
                    '₹${totalExpenses.toStringAsFixed(2)}'),
                _buildInfoCard(context, 'Profit/Loss',
                    '₹${profitLoss.toStringAsFixed(2)}'),
                _buildInfoCard(context, 'ML Predicted Profit',
                    '₹${mlPredictedProfit.toStringAsFixed(2)}'),
                _buildInfoCard(context, 'Vaccinations Due',
                    vaccinationsDue.toString()),
                _buildInfoCard(context, 'Vaccinations Completed',
                    vaccinationsCompleted.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value) {
    final width = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '$label\n$value',
          style: const TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
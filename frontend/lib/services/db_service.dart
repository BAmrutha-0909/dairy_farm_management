import '../models/animal.dart';
import '../models/vaccination.dart';
import '../models/milk_log.dart';
import '../models/sale.dart';
import '../models/expense.dart';

class DBService {
  // In-memory store example
  static List<Animal> animals = [];
  static List<Vaccination> vaccinations = [];
  static List<MilkLog> milkLogs = [];
  static List<Sale> sales = [];
  static List<Expense> expenses = [];

  // Animal operations
  static Future<List<Animal>> getAnimals() async => animals;

  static Future<void> addAnimal(Animal animal) async {
    animals.add(animal);
  }

  static Future<void> updateAnimal(Animal updated) async {
    animals = animals.map((a) => a.id == updated.id ? updated : a).toList();
  }

  static Future<void> deleteAnimal(String id) async {
    animals.removeWhere((a) => a.id == id);
  }

  // Vaccination operations
  static Future<List<Vaccination>> getVaccinations() async => vaccinations;

  static Future<void> addVaccination(Vaccination vaccination) async {
    vaccinations.add(vaccination);
  }

  static Future<void> updateVaccination(Vaccination updated) async {
    vaccinations = vaccinations.map((v) =>
        (v.animalId == updated.animalId && v.vaccine == updated.vaccine && v.dueDate == updated.dueDate)
            ? updated
            : v).toList();
  }

  static Future<void> deleteVaccination(String animalId) async {
    vaccinations.removeWhere((v) => v.animalId == animalId);
  }

  // MilkLog operations
  static Future<List<MilkLog>> getMilkLogs() async => milkLogs;

  static Future<void> addMilkLog(MilkLog log) async {
    milkLogs.add(log);
  }

  // Sale operations
  static Future<List<Sale>> getSales() async => sales;

  static Future<void> addSale(Sale sale) async {
    sales.add(sale);
  }

  // Expense operations
  static Future<List<Expense>> getExpenses() async => expenses;

  static Future<void> addExpense(Expense expense) async {
    expenses.add(expense);
  }
}

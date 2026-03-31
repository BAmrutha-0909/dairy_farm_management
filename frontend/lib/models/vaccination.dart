class Vaccination {
  final String animalId;
  final String vaccine;
  final DateTime dueDate;
  final DateTime? completionDate;

  Vaccination({
    required this.animalId,
    required this.vaccine,
    required this.dueDate,
    this.completionDate,
  });

  Map<String, dynamic> toJson() => {
        "animalId": animalId,
        "vaccine": vaccine,
        "dueDate": dueDate.toIso8601String(),
        "completionDate": completionDate?.toIso8601String(),
      };

  factory Vaccination.fromJson(Map<String, dynamic> json) => Vaccination(
        animalId: json["animalId"],
        vaccine: json["vaccine"],
        dueDate: DateTime.parse(json["dueDate"]),
        completionDate: json["completionDate"] != null &&
                json["completionDate"] != ""
            ? DateTime.parse(json["completionDate"])
            : null,
      );
}
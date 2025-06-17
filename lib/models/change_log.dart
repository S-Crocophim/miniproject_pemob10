// lib/models/change_log.dart
class ChangeLog {
  final String employeeId;
  final DateTime timestamp;
  final String description; // Contoh: "Slot A1 diubah menjadi Occupied"

  ChangeLog({
    required this.employeeId,
    required this.timestamp,
    required this.description,
  });
}
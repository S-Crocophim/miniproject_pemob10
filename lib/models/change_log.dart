// lib/models/change_log.dart
class ChangeLog {
  final String employeeId;
  final DateTime timestamp;
  final String description;

  ChangeLog({
    required this.employeeId,
    required this.timestamp,
    required this.description,
  });
}

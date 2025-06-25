// lib/models/slot_storage.dart

enum SlotStatus { available, occupied, inProcess }

class SlotStorage {
  final String id;
  final SlotStatus status;

  SlotStorage({
    required this.id,
    required this.status,
  });

  factory SlotStorage.fromMap(String id, Map<String, dynamic> data) {
    return SlotStorage(
      id: id,
      status: SlotStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => SlotStatus.available,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
    };
  }
}
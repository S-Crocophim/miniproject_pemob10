// lib/models/slot_storage.dart

// Let's use English terms as the standard to avoid confusion.
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
      // We need to be careful here if the database has mixed languages.
      // This code now expects "available", "occupied", or "inProcess" from Firestore.
      status: SlotStatus.values.firstWhere(
        (e) => e.name == data['status'],
        // Default to 'available' if the data from Firestore is invalid or in a different language.
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
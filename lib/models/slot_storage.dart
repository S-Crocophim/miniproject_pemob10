// lib/models/slot_storage.dart
enum SlotStatus { available, occupied, processing }

class SlotStorage {
  final String id;
  SlotStatus status;

  SlotStorage({required this.id, required this.status});
}
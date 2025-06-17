// lib/models/slot_storage.dart
enum SlotStatus { tersedia, terisi, dalamProses }

class SlotStorage {
  final String id;
  SlotStatus status;

  SlotStorage({required this.id, required this.status});
}

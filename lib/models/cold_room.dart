// lib/models/cold_room.dart
import 'package:miniproject_pemob10/models/slot_storage.dart';

enum RoomStatus { normal, alert, warning }

class ColdRoom {
  final String id;
  final String name;
  final String location;
  final double temperature;
  final double humidity;
  final bool isDoorOpen;
  final RoomStatus status;
  final List<SlotStorage> slots;
  final String cctvUrl;

  ColdRoom({
    required this.id,
    required this.name,
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.isDoorOpen,
    required this.status,
    required this.slots,
    required this.cctvUrl,
  });
}

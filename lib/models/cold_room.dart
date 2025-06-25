import '/models/slot_storage.dart';

enum RoomStatus { normal, alert, warning }

class ColdRoom {

  final String id;
  final String name;
  final String location;
  final double temperature;
  final double humidity;
  final bool isDoorOpen;
  final RoomStatus status;
  final String cctvUrl;
  final List<SlotStorage> slots;

  ColdRoom({
    required this.id,
    required this.name,
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.isDoorOpen,
    required this.status,
    required this.cctvUrl,
    required this.slots,
  });

  factory ColdRoom.fromMap(String id, Map<String, dynamic> data) {
    return ColdRoom(
      id: id,
      name: data['name'] ?? 'No Name',
      location: data['location'] ?? 'No Location',
      temperature: (data['temperature'] ?? 0.0).toDouble(),
      humidity: (data['humidity'] ?? 0.0).toDouble(),
      isDoorOpen: data['isDoorOpen'] ?? false,

      status: RoomStatus.values.firstWhere(
        (e) => e.name == data['status'], 
        orElse: () => RoomStatus.normal
      ),
      cctvUrl: data['cctvUrl'] ?? '',
      slots: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'temperature': temperature,
      'humidity': humidity,
      'isDoorOpen': isDoorOpen,
      'status': status.name,
      'cctvUrl': cctvUrl,
      // 'slots' bisa ditambahkan di sini jika diperlukan nanti
    };
  }
}
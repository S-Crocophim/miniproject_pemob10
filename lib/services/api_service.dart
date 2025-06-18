// lib/services/api_service.dart
import 'package:miniproject_pemob10/models/cold_room.dart';
import 'package:miniproject_pemob10/models/slot_storage.dart';

class ApiService {
  // Simulate login
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Real API logic would go here
    if (username == 'admin' && password == 'password') {
      return true;
    }
    return false;
  }

  // Simulate fetching all cold room data
  Future<List<ColdRoom>> fetchColdRooms() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Dummy data. In a real app, this would come from an HTTP request.
    return [
      ColdRoom(
        id: 'CR-001',
        name: 'Fresh Fruit Warehouse',
        location: 'Floor 1, Block A',
        temperature: 2.5,
        humidity: 85.0,
        isDoorOpen: false,
        status: RoomStatus.normal,
        cctvUrl:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        slots: List.generate(
          12,
          (index) => SlotStorage(
            id: 'A${index + 1}',
            status: index % 3 == 0 ? SlotStatus.occupied : SlotStatus.available,
          ),
        ),
      ),
      ColdRoom(
        id: 'CR-002',
        name: 'Vaccine Storage',
        location: 'Floor 2, Block B',
        temperature: -18.2,
        humidity: 40.0,
        isDoorOpen: false,
        status: RoomStatus.alert,
        cctvUrl:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        slots: List.generate(
          8,
          (index) =>
              SlotStorage(id: 'B${index + 1}', status: SlotStatus.occupied),
        ),
      ),
    ];
  }
}

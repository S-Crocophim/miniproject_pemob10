// lib/services/api_service.dart
import 'package:miniproject_pemob10/models/cold_room.dart';
import 'package:miniproject_pemob10/models/slot_storage.dart';

class ApiService {
  // Simulasi login
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Logika API sesungguhnya akan ada di sini
    if (username == 'admin' && password == 'password') {
      return true;
    }
    return false;
  }

  // Simulasi mengambil data semua cold room
  Future<List<ColdRoom>> fetchColdRooms() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Data dummy. Di aplikasi nyata, ini berasal dari HTTP request.
    return [
      ColdRoom(
        id: 'CR-001',
        name: 'Gudang Buah Segar',
        location: 'Lantai 1, Blok A',
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
            status: index % 3 == 0 ? SlotStatus.terisi : SlotStatus.tersedia,
          ),
        ),
      ),
      ColdRoom(
        id: 'CR-002',
        name: 'Gudang Vaksin',
        location: 'Lantai 2, Blok B',
        temperature: -18.2,
        humidity: 40.0,
        isDoorOpen: false,
        status: RoomStatus.alert,
        cctvUrl:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        slots: List.generate(
          8,
          (index) =>
              SlotStorage(id: 'B${index + 1}', status: SlotStatus.terisi),
        ),
      ),
    ];
  }
}

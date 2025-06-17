// lib/providers/cold_room_provider.dart
import 'package:flutter/material.dart';
import 'package:miniproject_pemob10/models/cold_room.dart';
import 'package:miniproject_pemob10/services/api_service.dart';

class ColdRoomProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<ColdRoom> _rooms = [];
  bool _isLoading = false;

  List<ColdRoom> get rooms => _rooms;
  bool get isLoading => _isLoading;

  Future<void> fetchColdRooms() async {
    _isLoading = true;
    notifyListeners();
    _rooms = await _apiService.fetchColdRooms();
    _isLoading = false;
    notifyListeners();
  }
}

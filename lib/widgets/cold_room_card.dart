// lib/widgets/cold_room_card.dart
import 'package:flutter/material.dart';
import 'package:miniproject_pemob10/models/cold_room.dart';
import 'package:miniproject_pemob10/screens/room_detail_screen.dart';
import 'package:miniproject_pemob10/utils/app_theme.dart';

class ColdRoomCard extends StatelessWidget {
  final ColdRoom room;

  const ColdRoomCard({super.key, required this.room});

  Color _getStatusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.alert:
        return AppTheme.accentColor;
      case RoomStatus.warning:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(room.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      room.status.name.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(room.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(room.location, style: TextStyle(color: Colors.grey[600])),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    Icons.thermostat,
                    '${room.temperature}°C',
                    'Suhu',
                  ),
                  _buildInfoItem(
                    Icons.water_drop_outlined,
                    '${room.humidity}%',
                    'Kelembaban',
                  ),
                  _buildInfoItem(
                    Icons.door_front_door_outlined,
                    room.isDoorOpen ? 'Terbuka' : 'Tertutup',
                    'Pintu',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

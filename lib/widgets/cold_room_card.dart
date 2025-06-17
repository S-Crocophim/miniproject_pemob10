// lib/widgets/cold_room_card.dart
import 'package:flutter/material.dart';
import '/models/cold_room.dart';
import '/screens/room_detail_screen.dart';
import '/utils/app_theme.dart';
import '/widgets/glassmorphic_container.dart';

class ColdRoomCard extends StatelessWidget {
  final ColdRoom room;

  const ColdRoomCard({super.key, required this.room});

  Color _getStatusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.alert:
        return AppTheme.statusAlert;
      case RoomStatus.warning:
        return AppTheme.primaryColor;
      default:
        return AppTheme.statusNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)));
      },
      child: GlassmorphicContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    room.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(room.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    room.status.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(room.location, style: TextStyle(color: AppTheme.textColor.withOpacity(0.7))),
            const Divider(height: 24, color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.thermostat, '${room.temperature}°C', 'Temp.'),
                _buildInfoItem(Icons.water_drop_outlined, '${room.humidity}%', 'Humidity'),
                _buildInfoItem(Icons.door_front_door_outlined, room.isDoorOpen ? 'Open' : 'Closed', 'Door'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.textColor, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textColor)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textColor.withOpacity(0.7))),
      ],
    );
  }
}
// lib/widgets/cold_room_card.dart
import '/models/cold_room.dart';
import '/screens/room_detail_screen.dart';
import '/utils/app_theme.dart';
import '/widgets/glassmorphic_container.dart';
import 'package:flutter/material.dart';

class ColdRoomCard extends StatelessWidget {
  final ColdRoom room;

  const ColdRoomCard({super.key, required this.room});

  Color _getStatusColor(RoomStatus status, bool isDarkMode) {
    if (isDarkMode) {
      switch (status) {
        case RoomStatus.alert: return AppTheme.darkStatusAlert;
        case RoomStatus.warning: return AppTheme.darkWarningColor;
        default: return AppTheme.darkStatusNormal;
      }
    } else {
      switch (status) {
        case RoomStatus.alert: return AppTheme.lightStatusAlert;
        case RoomStatus.warning: return AppTheme.lightWarningColor;
        default: return AppTheme.lightStatusNormal;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppTheme.darkTextColor : AppTheme.lightTextColor;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)),
        );
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(room.status, isDarkMode),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    room.status.name.toUpperCase(),
                    style: TextStyle(
                        color: isDarkMode ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              room.location,
              style: TextStyle(color: textColor.withOpacity(0.7)),
            ),
            const Divider(height: 24, color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.thermostat, '${room.temperature}°C', 'Temp.', textColor),
                _buildInfoItem(Icons.water_drop_outlined, '${room.humidity}%', 'Humidity', textColor),
                _buildInfoItem(Icons.door_front_door_outlined, room.isDoorOpen ? 'Open' : 'Closed', 'Door', textColor),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label, Color textColor) {
    return Column(
      children: [
        Icon(icon, color: textColor, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
        Text(label, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7))),
      ],
    );
  }
}
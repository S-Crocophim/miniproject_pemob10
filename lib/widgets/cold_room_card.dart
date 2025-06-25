// lib/widgets/cold_room_card.dart
import 'package:flutter/material.dart';
import '/models/cold_room.dart';
import '/screens/room_detail_screen.dart';
import '/widgets/glass_card.dart';
import 'package:provider/provider.dart';
import '/providers/theme_provider.dart';

class ColdRoomCard extends StatelessWidget {
  final ColdRoom room;

  const ColdRoomCard({super.key, required this.room});

  Color _getStatusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.alert:
        return Colors.red.shade400;
      case RoomStatus.warning:
        return Colors.orange.shade400;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeColor = themeProvider.isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)));
        },
        child: GlassmorphicCard(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStatusColor(room.status).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        room.status.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  room.location,
                  style: TextStyle(color: themeColor.withOpacity(0.7)),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(Icons.thermostat, '${room.temperature}°C', 'Suhu', themeColor),
                    _buildInfoItem(Icons.water_drop_outlined, '${room.humidity}%', 'Kelembaban', themeColor),
                    _buildInfoItem(Icons.door_front_door_outlined, room.isDoorOpen ? 'Terbuka' : 'Tertutup', 'Pintu', themeColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label, Color themeColor) {
    return Column(
      children: [
        Icon(icon, color: themeColor, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: themeColor)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: themeColor.withOpacity(0.7))),
      ],
    );
  }
}
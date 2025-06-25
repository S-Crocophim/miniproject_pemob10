// lib/screens/room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/models/cold_room.dart';
import '/screens/cctv_view_screen.dart';
import '/screens/slot_management_screen.dart';

class RoomDetailScreen extends StatefulWidget {
  final ColdRoom room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: theme.scaffoldBackgroundColor, // Samakan dengan background body
        elevation: 0,
        foregroundColor: theme.textTheme.bodyLarge?.color, // Warna ikon dan teks
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildKeyMetrics(theme),
              const SizedBox(height: 24),
              _buildChartCard(theme),
              const SizedBox(height: 24),
              
              // Ini bagian yang diperbaiki
              _buildActionButtons(context), 

              const SizedBox(height: 16),
              _buildSettingsCard(theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyMetrics(ThemeData theme) {
    return Row(
      children: [
        _buildMetricCard('Suhu', '${widget.room.temperature}°C', Icons.thermostat_outlined, Colors.orange),
        const SizedBox(width: 12),
        _buildMetricCard('Kelembaban', '${widget.room.humidity}%', Icons.water_drop_outlined, Colors.blue),
        const SizedBox(width: 12),
        _buildMetricCard('Pintu', widget.room.isDoorOpen ? 'Terbuka' : 'Tertutup', Icons.door_front_door_outlined, Colors.grey.shade600),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color.withOpacity(0.15),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme) {
    return Card(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       elevation: 0,
       color: theme.colorScheme.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tren Suhu (Contoh Statis)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: LineChart(_buildTemperatureChartData(theme)),
            ),
          ],
        ),
      ),
    );
  }

  // FIX UTAMA ADA DI SINI
  // Widget ini sekarang hanya berisi satu Row dengan dua tombol di dalamnya,
  // masing-masing dibungkus Expanded.
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Tombol 1: Kelola Slot
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.grid_on_outlined, size: 20),
            label: const Text('Kelola Slot'),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) =>
                SlotManagementScreen(room: widget.room), 
              ));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Theme.of(context).dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Tombol 2: Lihat CCTV
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.videocam_outlined, size: 20),
            label: const Text('Lihat CCTV'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                CCTVViewScreen(cctvUrl: widget.room.cctvUrl, roomName: widget.room.name),
              ));
            },
             style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Theme.of(context).dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: theme.colorScheme.primary.withOpacity(0.05),
      child: ListTile(
        leading: Icon(Icons.notifications_active_outlined, color: theme.colorScheme.primary),
        title: const Text('Aktifkan Notifikasi'),
        subtitle: const Text('Terima alert untuk ruangan ini'),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
      ),
    );
  }
  
  LineChartData _buildTemperatureChartData(ThemeData theme) {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0, maxX: 11, minY: -5, maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3), FlSpot(1, 1), FlSpot(2, 4), FlSpot(3, 2),
            FlSpot(4, 2.5), FlSpot(5, 1.5), FlSpot(6, 3), FlSpot(7, 2.8),
            FlSpot(8, 3.5), FlSpot(9, 3.2), FlSpot(10, 2.9), FlSpot(11, 3.1),
          ],
          isCurved: true,
          color: theme.colorScheme.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
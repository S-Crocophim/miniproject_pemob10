// lib/screens/room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/models/cold_room.dart';
import '/screens/cctv_view_screen.dart';
import '/screens/log_history_screen.dart'; // Import layar Log
import '/screens/slot_management_screen.dart';
import '/widgets/glass_card.dart'; // Import untuk desain modern

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
      extendBodyBehindAppBar: true, // Membuat body bisa berada di belakang AppBar
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0,
      ),
      body: Stack( // Gunakan Stack untuk background
        children: [
          Container(
             decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.brightness == Brightness.dark
                    ? [const Color(0xFF1E2A72), const Color(0xFF28338C)]
                    : [const Color(0xFFC2E9FB), const Color(0xFFa1c4fd)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _buildKeyMetrics(),
                    const SizedBox(height: 24),
                    _buildChartCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(context),
                    const SizedBox(height: 16),
                    _buildSettingsCard(),
                    // TOMBOL LOG HISTORY DITAMBAHKAN DI SINI
                    const SizedBox(height: 16),
                    _buildLogHistoryButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Row(
      children: [
        _buildMetricCard('Suhu', '${widget.room.temperature}°C', Icons.thermostat_outlined),
        const SizedBox(width: 12),
        _buildMetricCard('Kelembaban', '${widget.room.humidity}%', Icons.water_drop_outlined),
        const SizedBox(width: 12),
        _buildMetricCard('Pintu', widget.room.isDoorOpen ? 'Terbuka' : 'Tertutup', Icons.door_front_door_outlined),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Expanded(
      child: GlassmorphicCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tren Suhu (Contoh Statis)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: LineChart(_buildTemperatureChartData(Theme.of(context))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
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
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(width: 16),
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
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return GlassmorphicCard(
      child: ListTile(
        leading: Icon(Icons.notifications_active_outlined, color: Theme.of(context).colorScheme.primary),
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
  
  // WIDGET BARU UNTUK TOMBOL LOG HISTORY
  Widget _buildLogHistoryButton(BuildContext context) {
    return GlassmorphicCard(
      child: ListTile(
        onTap: () {
          // Navigasi ke LogHistoryScreen dengan membawa ID dan Nama ruangan
          Navigator.push(context, MaterialPageRoute(builder: (_) => 
            LogHistoryScreen(
              roomId: widget.room.id,
              roomName: widget.room.name
            ),
          ));
        },
        leading: Icon(Icons.history_edu_outlined, color: Theme.of(context).colorScheme.primary),
        title: const Text('Lihat Log Aktivitas Ruangan'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
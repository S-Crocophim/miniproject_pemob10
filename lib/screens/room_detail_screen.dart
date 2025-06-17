// lib/screens/room_detail_screen.dart
import '/screens/cctv_view_screen.dart';
import '/screens/slot_management_screen.dart';
import '/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/models/cold_room.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildKeyMetrics(),
              const SizedBox(height: 24),
              _buildChartCard(),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 16),
              _buildSettingsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricCard('Temperature', '${widget.room.temperature}°C', Icons.thermostat, Colors.orange),
        _buildMetricCard('Humidity', '${widget.room.humidity}%', Icons.water_drop, Colors.blue),
        _buildMetricCard('Door', widget.room.isDoorOpen ? 'Open' : 'Closed', Icons.door_front_door, Colors.red.shade300),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperature Trend (Last 24h)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: LineChart(_buildTemperatureChartData()),
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
          child: ElevatedButton.icon(
            icon: const Icon(Icons.videocam),
            label: const Text('View CCTV'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                CCTVViewScreen(cctvUrl: widget.room.cctvUrl, roomName: widget.room.name),
              ));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppTheme.secondaryColor
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.grid_on),
            label: const Text('Manage Slots'),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) =>
                SlotManagementScreen(slots: widget.room.slots, roomName: widget.room.name),
              ));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_active, color: AppTheme.primaryColor),
        title: const Text('Enable Notifications'),
        subtitle: const Text('Receive alerts for this room'),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notifications for ${widget.room.name} have been ${value ? 'enabled' : 'disabled'}'))
            );
          },
          activeColor: AppTheme.primaryColor,
        ),
      ),
    );
  }
  
  // Dummy data for chart
  LineChartData _buildTemperatureChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11,
      minY: -5,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3), FlSpot(1, 1), FlSpot(2, 4), FlSpot(3, 2),
            FlSpot(4, 2.5), FlSpot(5, 1.5), FlSpot(6, 3), FlSpot(7, 2.8),
            FlSpot(8, 3.5), FlSpot(9, 3.2), FlSpot(10, 2.9), FlSpot(11, 3.1),
          ],
          isCurved: true,
          color: AppTheme.primaryColor,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.secondaryColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
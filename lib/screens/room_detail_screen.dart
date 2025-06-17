// lib/screens/room_detail_screen.dart
import '/models/cold_room.dart';
import '/screens/cctv_view_screen.dart';
import '/screens/slot_management_screen.dart';
import '/utils/app_theme.dart';
import '/widgets/glassmorphic_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.room.name, style: const TextStyle(fontWeight: FontWeight.normal)),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const Text("Current Conditions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetricItem('Temp', '${widget.room.temperature}°C', Icons.thermostat, AppTheme.primaryColor),
                          _buildMetricItem('Humidity', '${widget.room.humidity}%', Icons.water_drop, AppTheme.secondaryColor),
                          _buildMetricItem('Door', widget.room.isDoorOpen ? 'Open' : 'Closed', Icons.door_front_door, AppTheme.statusAlert),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildChartCard(),
                const SizedBox(height: 16),
                _buildActionButtons(context),
                const SizedBox(height: 16),
                GlassmorphicContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  margin: EdgeInsets.zero,
                  child: SwitchListTile(
                    title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
                    subtitle: Text('Receive alerts for this room', style: TextStyle(color: AppTheme.textColor.withOpacity(0.7))),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                    },
                    activeColor: AppTheme.primaryColor,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.9),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textColor.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildChartCard() {
    return GlassmorphicContainer(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Temperature Trend (Last 24h)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(_buildTemperatureChartData()),
          ),
        ],
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
          ),
        ),
      ],
    );
  }

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
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
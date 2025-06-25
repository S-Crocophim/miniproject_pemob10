// lib/screens/room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/models/cold_room.dart';
import '/screens/cctv_view_screen.dart';
import '/screens/log_history_screen.dart';
import '/screens/slot_management_screen.dart';
import '/widgets/glass_card.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
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
        _buildMetricCard('Temperature', '${widget.room.temperature}°C', Icons.thermostat_outlined),
        const SizedBox(width: 12),
        _buildMetricCard('Humidity', '${widget.room.humidity}%', Icons.water_drop_outlined),
        const SizedBox(width: 12),
        _buildMetricCard('Door', widget.room.isDoorOpen ? 'Open' : 'Closed', Icons.door_front_door_outlined),
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

  // This widget contains the chart. No changes needed here.
  Widget _buildChartCard() {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 20, 16), // Adjust padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperature Trend (24h Example)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: LineChart(_buildTemperatureChartData(Theme.of(context))),
            ),
          ],
        ),
      ),
    );
  }

  // The primary fix is in this method.
  LineChartData _buildTemperatureChartData(ThemeData theme) {
    // A sample list of data points (x, y). x is time, y is temperature.
    final List<FlSpot> spots = [
      const FlSpot(0, 3), const FlSpot(1, 4), const FlSpot(2, 3.5),
      const FlSpot(3, 5), const FlSpot(4, 4), const FlSpot(5, 6),
      const FlSpot(6, 6.5), const FlSpot(7, 6), const FlSpot(8, 4),
      const FlSpot(9, 5), const FlSpot(10, 5.5), const FlSpot(11, 7),
    ];
    
    // Gradient colors for the line and area below it
    final List<Color> gradientColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
    ];

    return LineChartData(
      // 1. GRID DATA: Hide the grid for a cleaner look
      gridData: const FlGridData(show: false),

      // 2. TITLES DATA: Hide all titles (axis labels)
      titlesData: const FlTitlesData(
        show: true,
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),

      // 3. BORDER DATA: Hide the chart border for a modern look
      borderData: FlBorderData(show: false),
      
      // 4. AXIS LIMITS: Ensure the axis limits can contain the data
      minX: 0,  // Corresponds to the first x-value in spots (0)
      maxX: 11, // Corresponds to the last x-value in spots (11)
      minY: 0,  // A reasonable minimum temperature
      maxY: 10, // A reasonable maximum temperature that is higher than the max spot value (7)
      
      // 5. LINE BARS DATA: This is where we define the actual line
      lineBarsData: [
        LineChartBarData(
          spots: spots, // Use the data defined above
          isCurved: true, // Make the line smooth
          // Apply a gradient color to the line
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5, // Line thickness
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false), // Hide the dots on the line
          // The area below the line
          belowBarData: BarAreaData(
            show: true,
            // Apply a gradient to the area, but with more transparency
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.grid_on_outlined, size: 20),
            label: const Text('Manage Slots'),
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
            label: const Text('View CCTV'),
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
        title: const Text('Enable Notifications'),
        subtitle: const Text('Receive alerts for this room'),
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
  
  Widget _buildLogHistoryButton(BuildContext context) {
    return GlassmorphicCard(
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => 
            LogHistoryScreen(
              roomId: widget.room.id,
              roomName: widget.room.name
            ),
          ));
        },
        leading: Icon(Icons.history_edu_outlined, color: Theme.of(context).colorScheme.primary),
        title: const Text('View Room Activity Log'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
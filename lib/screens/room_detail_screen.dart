// lib/screens/room_detail_screen.dart
import 'package:intl/intl.dart';

import '/models/change_log.dart';
import '/models/cold_room.dart';
import '/providers/theme_provider.dart';
import '/screens/cctv_view_screen.dart';
import '/screens/slot_management_screen.dart';
import '/utils/app_theme.dart';
import '/widgets/glassmorphic_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final ColdRoom room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _notificationsEnabled = true;
  List<ChangeLog> _changeLogs = [];

  @override
  void initState() {
    super.initState();
    _changeLogs = [
      ChangeLog(
        employeeId: 'EMP-112',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Slot A3 changed to Occupied.',
      ),
      ChangeLog(
        employeeId: 'EMP-078',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        description: 'Slot B2 changed to Available.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? AppTheme.darkTextColor : AppTheme.lightTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.room.name, style: const TextStyle(fontWeight: FontWeight.normal)),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: isDarkMode ? AppTheme.darkBackgroundGradient : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMetricSection(textColor),
                const SizedBox(height: 16),
                _buildActionButtons(context),
                const SizedBox(height: 16),
                _buildNotificationSwitch(isDarkMode, textColor),
                const SizedBox(height: 24),
                _buildChangeLogSection(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricSection(Color textColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GlassmorphicContainer(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Text("Current Conditions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Temp', '${widget.room.temperature}°C', Icons.thermostat, isDarkMode ? AppTheme.darkWarningColor : AppTheme.lightWarningColor, textColor),
              _buildMetricItem('Humidity', '${widget.room.humidity}%', Icons.water_drop, isDarkMode ? AppTheme.darkSecondaryColor : AppTheme.lightSecondaryColor, textColor),
              _buildMetricItem('Door', widget.room.isDoorOpen ? 'Open' : 'Closed', Icons.door_front_door, isDarkMode ? AppTheme.darkStatusAlert : AppTheme.lightStatusAlert, textColor),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          _buildChartCard(isDarkMode, textColor),
        ],
      ),
    );
  }

  Widget _buildChangeLogSection(Color textColor) {
    return GlassmorphicContainer(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: textColor, size: 22),
              const SizedBox(width: 8),
              Text(
                "Slot Change History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_changeLogs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "No recent changes.",
                  style: TextStyle(color: textColor.withOpacity(0.7), fontStyle: FontStyle.italic),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _changeLogs.length,
              itemBuilder: (context, index) {
                final log = _changeLogs[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    child: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary),
                  ),
                  title: Text(log.description, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    "${log.employeeId} • ${DateFormat.yMMMd().add_jms().format(log.timestamp)}",
                    style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(color: Colors.white24, height: 1),
            ),
        ],
      ),
    );
  }

  void _navigateToSlotManagement() async {
    final result = await Navigator.push<ChangeLog>(
      context,
      MaterialPageRoute(
        builder: (_) => SlotManagementScreen(
          slots: widget.room.slots,
          roomName: widget.room.name,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _changeLogs.insert(0, result);
      });
    }
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
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.grid_on),
            label: const Text('Manage Slots'),
            onPressed: _navigateToSlotManagement,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSwitch(bool isDarkMode, Color textColor) {
    return GlassmorphicContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      margin: EdgeInsets.zero,
      child: SwitchListTile(
        title: Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text('Receive alerts for this room', style: TextStyle(color: textColor.withOpacity(0.7))),
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() => _notificationsEnabled = value);
        },
        activeColor: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.lightPrimaryColor,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildChartCard(bool isDarkMode, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Temperature Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 20),
        SizedBox(
          height: 120,
          child: LineChart(_buildTemperatureChartData(isDarkMode)),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color, Color textColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.9),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        Text(label, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7))),
      ],
    );
  }

  LineChartData _buildTemperatureChartData(bool isDarkMode) {
    final primaryColor = isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.lightPrimaryColor;
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
          color: primaryColor,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: primaryColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
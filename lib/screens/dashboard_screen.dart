// lib/screens/dashboard_screen.dart
import '/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cold_room_provider.dart';
import '/utils/app_theme.dart';
import '/widgets/cold_room_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ColdRoomProvider>(context, listen: false).fetchColdRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<ColdRoomProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows content to go behind AppBar
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 28),
            tooltip: 'Logout',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: roomProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : RefreshIndicator(
                  onRefresh: () => roomProvider.fetchColdRooms(),
                  color: AppTheme.primaryColor,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    itemCount: roomProvider.rooms.length,
                    itemBuilder: (context, index) {
                      return ColdRoomCard(room: roomProvider.rooms[index]);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
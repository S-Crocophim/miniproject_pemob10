// lib/screens/dashboard_screen.dart
import '/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cold_room_provider.dart';
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
    // Fetch data when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ColdRoomProvider>(context, listen: false).fetchColdRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<ColdRoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () { /* TODO: Implement Notifications Page */ },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: roomProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => roomProvider.fetchColdRooms(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: roomProvider.rooms.length,
                itemBuilder: (context, index) {
                  return ColdRoomCard(room: roomProvider.rooms[index]);
                },
              ),
            ),
    );
  }
}
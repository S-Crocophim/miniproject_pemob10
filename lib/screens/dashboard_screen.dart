// lib/screens/dashboard_screen.dart
import 'package:miniproject_pemob10/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miniproject_pemob10/providers/cold_room_provider.dart';
import 'package:miniproject_pemob10/widgets/cold_room_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fetch data saat screen pertama kali dibuka
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
            onPressed: () {
              /* Halaman Notifikasi */
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
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

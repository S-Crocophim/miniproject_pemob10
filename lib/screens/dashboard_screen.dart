import 'package:flutter/material.dart';
import 'package:miniproject_pemob10/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '/providers/cold_room_provider.dart';
import '/models/cold_room.dart';
import '/widgets/cold_room_card.dart';
import '/screens/add_room_screen.dart'; // import layar baru

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<ColdRoomProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      // Gunakan StreamBuilder untuk mendengarkan perubahan data Firestore secara real-time
      body: StreamBuilder<List<ColdRoom>>(
        stream: roomProvider.getColdRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data Cold Room.'));
          }

          final rooms = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return ColdRoomCard(room: rooms[index]);
            },
          );
        },
      ),
      // Tombol untuk menambah data baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddRoomScreen()));
        },
        tooltip: 'Tambah Ruangan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
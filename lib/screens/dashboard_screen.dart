// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/providers/cold_room_provider.dart';
import '/providers/theme_provider.dart';
import '/models/cold_room.dart';
import '/widgets/cold_room_card.dart';
import '/screens/add_room_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<ColdRoomProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // Kita gunakan Stack untuk menumpuk background dan konten utama
      body: Stack(
        children: [
          // Lapis 1: Background Gradient & Blur
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.isDarkMode
                    ? [const Color(0xFF1E2A72), const Color(0xFF28338C)]
                    : [const Color(0xFFC2E9FB), const Color(0xFFa1c4fd)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Lapis 2: Konten aplikasi
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar Kustom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                            ),
                      ),
                      // Tombol Switch Tema
                      Row(
                        children: [
                          Icon(
                            themeProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                            color: themeProvider.isDarkMode ? Colors.yellow.shade700 : Colors.orange,
                          ),
                          Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
                            onPressed: () => authProvider.logout(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                // Konten List
                Expanded(
                  child: StreamBuilder<List<ColdRoom>>(
                    stream: roomProvider.getColdRooms(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Terjadi error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Belum ada data Cold Room.'),
                            );
                      }
                      final rooms = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return ColdRoomCard(room: rooms[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddRoomScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Tambah Ruangan',
      ),
    );
  }
}
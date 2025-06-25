// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/providers/cold_room_provider.dart';
import '/providers/theme_provider.dart';
import '/models/cold_room.dart';
import '/widgets/cold_room_card.dart';
import '/screens/log_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<ColdRoomProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard',
                        style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.history_edu_outlined,
                                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LogHistoryScreen()),
                              );
                            },
                            tooltip: 'Activity Log',
                          ),
                          Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.logout,
                                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
                            onPressed: () => authProvider.logout(),
                            tooltip: 'Logout',
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<ColdRoom>>(
                    stream: roomProvider.getColdRooms(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('An error occurred: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No cold rooms found.\nClick the + button to add one.'),
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
          // You might want to create and translate add_room_screen as well
          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddRoomScreen()));
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Room',
      ),
    );
  }
}
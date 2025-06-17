// lib/screens/dashboard_screen.dart
import '/providers/auth_provider.dart';
import '/providers/cold_room_provider.dart';
import '/providers/theme_provider.dart';
import '/utils/app_theme.dart';
import '/widgets/cold_room_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.nightlight_round
                  : Icons.wb_sunny_rounded,
              size: 24,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeProvider.setDarkTheme(!themeProvider.isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 26),
            tooltip: 'Logout',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Container(
        decoration: themeProvider.isDarkMode
            ? AppTheme.darkBackgroundGradient
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: roomProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : RefreshIndicator(
                  onRefresh: () => roomProvider.fetchColdRooms(),
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surface,
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
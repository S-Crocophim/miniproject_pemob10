// lib/screens/log_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/models/activity_log.dart';
import '/providers/cold_room_provider.dart';
import '/widgets/glass_card.dart';

class LogHistoryScreen extends StatelessWidget {
  const LogHistoryScreen({super.key});

  // Helper untuk memformat timestamp
  String _formatTimestamp(DateTime? dt) {
    if (dt == null) return "No date";
    // Format: 24 Okt 2023, 14:30
    return DateFormat('d MMM yyyy, HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColdRoomProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Aktivitas'),
      ),
      body: Stack(
        children: [
           // Background yang konsisten
           Container(
             decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF1E2A72), const Color(0xFF28338C)]
                    : [const Color(0xFFC2E9FB), const Color(0xFFa1c4fd)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // StreamBuilder untuk menampilkan log
          StreamBuilder<List<ActivityLog>>(
            stream: provider.getActivityLogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Belum ada aktivitas tercatat.'));
              }

              final logs = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  // Tampilan untuk setiap entri log
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassmorphicCard(
                       color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          child: Icon(
                            Icons.history,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          log.activity,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _formatTimestamp(log.timestamp.toDate()), // Ubah Timestamp ke DateTime
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
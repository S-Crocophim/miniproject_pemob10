// lib/screens/slot_management_screen.dart
import 'package:flutter/material.dart';
import 'package:miniproject_pemob10/models/slot_storage.dart';
import 'package:miniproject_pemob10/utils/app_theme.dart';

class SlotManagementScreen extends StatefulWidget {
  final List<SlotStorage> slots;
  final String roomName;

  const SlotManagementScreen({
    super.key,
    required this.slots,
    required this.roomName,
  });

  @override
  _SlotManagementScreenState createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  late List<SlotStorage> _currentSlots;

  @override
  void initState() {
    super.initState();
    // Buat salinan lokal agar perubahan tidak langsung mempengaruhi state sebelumnya
    _currentSlots = widget.slots
        .map((s) => SlotStorage(id: s.id, status: s.status))
        .toList();
  }

  Color _getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.terisi:
        return Colors.red.shade400;
      case SlotStatus.dalamProses:
        return AppTheme.accentColor;
      case SlotStatus.tersedia:
        return Colors.green.shade400;
    }
  }

  void _showStatusChangeDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Status Slot ${_currentSlots[index].id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: SlotStatus.values.map((status) {
              return ListTile(
                title: Text(
                  status.name
                      .replaceAllMapped(
                        RegExp(r'([A-Z])'),
                        (match) => ' ${match.group(1)}',
                      )
                      .trim()
                      .capitalize(),
                ),
                leading: Icon(Icons.circle, color: _getColorForStatus(status)),
                onTap: () {
                  setState(() {
                    _currentSlots[index].status = status;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Slot - ${widget.roomName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Di aplikasi nyata, panggil API untuk menyimpan perubahan.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perubahan slot disimpan! (simulasi)'),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _currentSlots.length,
          itemBuilder: (context, index) {
            final slot = _currentSlots[index];
            return InkWell(
              onTap: () => _showStatusChangeDialog(index),
              child: Card(
                color: _getColorForStatus(slot.status),
                child: Center(
                  child: Text(
                    slot.id,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

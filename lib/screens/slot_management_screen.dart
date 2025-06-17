// lib/screens/slot_management_screen.dart
import '/models/slot_storage.dart';
import '/utils/app_theme.dart';
import 'package:flutter/material.dart';

class SlotManagementScreen extends StatefulWidget {
  final List<SlotStorage> slots;
  final String roomName;

  const SlotManagementScreen({super.key, required this.slots, required this.roomName});

  @override
  _SlotManagementScreenState createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  late List<SlotStorage> _currentSlots;

  @override
  void initState() {
    super.initState();
    _currentSlots = widget.slots.map((s) => SlotStorage(id: s.id, status: s.status)).toList();
  }

  Color _getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.occupied:
        return AppTheme.statusAlert;
      case SlotStatus.processing:
        return AppTheme.primaryColor;
      case SlotStatus.available:
        return AppTheme.statusNormal;
      }
  }

  void _showStatusChangeDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Change Status for Slot ${_currentSlots[index].id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: SlotStatus.values.map((status) {
              return ListTile(
                title: Text(status.name.capitalize()),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: AppTheme.secondaryColor)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Slot Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Changes',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slot changes saved! (simulation)')),
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _currentSlots.length,
              itemBuilder: (context, index) {
                final slot = _currentSlots[index];
                return GestureDetector(
                  onTap: () => _showStatusChangeDialog(index),
                  child: Card(
                    color: _getColorForStatus(slot.status).withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Center(
                      child: Text(
                        slot.id,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
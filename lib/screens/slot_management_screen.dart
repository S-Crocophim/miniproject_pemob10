// lib/screens/slot_management_screen.dart
import 'package:flutter/material.dart';
import '/models/slot_storage.dart';
import '/utils/app_theme.dart';

class SlotManagementScreen extends StatefulWidget {
  final List<SlotStorage> slots;
  final String roomName;

  const SlotManagementScreen({super.key, required this.slots, required this.roomName});

  @override
  // ignore: library_private_types_in_public_api
  _SlotManagementScreenState createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  late List<SlotStorage> _currentSlots;

  @override
  void initState() {
    super.initState();
    // Create a local copy to avoid modifying the original state directly
    _currentSlots = widget.slots.map((s) => SlotStorage(id: s.id, status: s.status)).toList();
  }

  Color _getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.occupied:
        return Colors.red.shade400;
      case SlotStatus.processing:
        return AppTheme.accentColor;
      case SlotStatus.available:
        return Colors.green.shade400;
      }
  }

  void _showStatusChangeDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
          actions: [TextButton(onPressed: ()=> Navigator.of(context).pop(), child: const Text("Cancel"))],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Management - ${widget.roomName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Changes',
            onPressed: () {
              // In a real app, call an API to save the changes.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slot changes saved! (simulation)')),
              );
              Navigator.pop(context);
            },
          )
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
      if (isEmpty) return this;
      return "${this[0].toUpperCase()}${substring(1)}";
    }
}
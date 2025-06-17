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

  // FIXED: This function now accepts the current theme brightness to select the correct color.
  Color _getColorForStatus(SlotStatus status, Brightness brightness) {
    final bool isDarkMode = brightness == Brightness.dark;
    
    switch (status) {
      case SlotStatus.occupied:
        return isDarkMode ? AppTheme.darkStatusAlert : AppTheme.lightStatusAlert;
      case SlotStatus.processing:
        return isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.lightPrimaryColor;
      case SlotStatus.available:
        return isDarkMode ? AppTheme.darkStatusNormal : AppTheme.lightStatusNormal;
    }
  }

  void _showStatusChangeDialog(int index) {
    // Determine theme inside the method to ensure dialogs are also theme-aware.
    final brightness = Theme.of(context).brightness;

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
                leading: Icon(Icons.circle, color: _getColorForStatus(status, brightness)),
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
              // FIXED: Get the secondary color from the current theme's colorScheme.
              child: Text(
                "Cancel",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current brightness to determine which gradient to use.
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Slot Management'),
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
      // FIXED: Choose the correct gradient based on the current theme.
      body: Container(
        decoration: isDarkMode ? AppTheme.darkBackgroundGradient : AppTheme.lightBackgroundGradient,
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
                    // FIXED: Pass the current theme brightness to the color function.
                    color: _getColorForStatus(slot.status, brightness).withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Center(
                      child: Text(
                        slot.id,
                        style: TextStyle(
                          // Determine text color for contrast.
                          color: isDarkMode ? Colors.black87 : Colors.white,
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
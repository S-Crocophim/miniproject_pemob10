// lib/screens/slot_management_screen.dart
import '/models/change_log.dart';
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
  late List<SlotStorage> _originalSlots;
  late List<SlotStorage> _currentSlots;
  final TextEditingController _employeeIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _originalSlots = widget.slots.map((s) => SlotStorage(id: s.id, status: s.status)).toList();
    _currentSlots = widget.slots.map((s) => SlotStorage(id: s.id, status: s.status)).toList();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

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

  bool _isChanged() {
    for (int i = 0; i < _currentSlots.length; i++) {
      if (_originalSlots[i].status != _currentSlots[i].status) {
        return true;
      }
    }
    return false;
  }

  void _showVerificationDialog() {
    if (!_isChanged()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No changes to save.'),
            behavior: SnackBarBehavior.floating),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Verification Required"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please enter your Employee ID to confirm the changes."),
              const SizedBox(height: 16),
              TextField(
                controller: _employeeIdController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Employee ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              onPressed: () {
                _employeeIdController.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Confirm & Save"),
              onPressed: () {
                if (_employeeIdController.text.isNotEmpty) {
                  _saveChanges(_employeeIdController.text);
                  _employeeIdController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Employee ID cannot be empty!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            )
          ],
        );
      },
    );
  }

  String _generateLogDescription() {
    String description = '';
    for (int i = 0; i < _currentSlots.length; i++) {
      if (_originalSlots[i].status != _currentSlots[i].status) {
        description += 'Slot ${_currentSlots[i].id} from ${_originalSlots[i].status.name.capitalize()} to ${_currentSlots[i].status.name.capitalize()}. ';
      }
    }
    return description.trim();
  }

  void _saveChanges(String employeeId) {
    final String logDescription = _generateLogDescription();
    final newLog = ChangeLog(
      employeeId: employeeId,
      timestamp: DateTime.now(),
      description: logDescription,
    );

    // Close the verification dialog first
    Navigator.of(context).pop(); 
    // Then close the management screen, returning the log data
    Navigator.of(context).pop(newLog); 
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: _showVerificationDialog,
          )
        ],
      ),
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
                    color: _getColorForStatus(slot.status, brightness).withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Center(
                      child: Text(
                        slot.id,
                        style: TextStyle(
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
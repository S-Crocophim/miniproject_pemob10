// lib/screens/slot_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/cold_room.dart';
import '/models/slot_storage.dart';
import '/providers/cold_room_provider.dart';
import '/widgets/glass_card.dart';

class SlotManagementScreen extends StatelessWidget {
  final ColdRoom room;

  const SlotManagementScreen({super.key, required this.room});

  Color _getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.occupied:
        return Colors.red.shade400;
      case SlotStatus.inProcess:
        return Colors.orange.shade400;
      case SlotStatus.available:
        return Colors.green.shade400;
    }
  }

  void _showUpdateDialog(BuildContext context, SlotStorage slot) {
    SlotStatus selectedStatus = slot.status;
    final employeeIdController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isVerifying = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Update Slot ${slot.id}'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<SlotStatus>(
                      value: selectedStatus,
                      items: SlotStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.name.capitalize()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            selectedStatus = newValue;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'New Status'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Employee ID (for verification)',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Employee ID is required.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isVerifying
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final provider = Provider.of<ColdRoomProvider>(context, listen: false);

                              setDialogState(() => isVerifying = true);

                              final employeeId = employeeIdController.text.trim().toUpperCase();
                              final bool isEmployeeValid = await provider.verifyEmployeeId(employeeId);

                              setDialogState(() => isVerifying = false);

                              if (isEmployeeValid) {
                                try {
                                  await provider.updateSlotStatus(
                                    roomId: room.id,
                                    slotId: slot.id,
                                    newStatus: selectedStatus,
                                    employeeId: employeeId,
                                  );
                                  Navigator.of(dialogContext).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Slot status updated successfully!'), backgroundColor: Colors.green),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to update: $e'), backgroundColor: Colors.red),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid or unrecognized Employee ID.'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                          child: const Text('Save'),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColdRoomProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Management - ${room.name}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
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
          SafeArea(
            child: StreamBuilder<List<SlotStorage>>(
              stream: provider.getSlotsForRoom(room.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No slots found for this room.'));
                }

                final slots = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      return GestureDetector(
                        onTap: () => _showUpdateDialog(context, slot),
                        child: GlassmorphicCard(
                          color: _getColorForStatus(slot.status),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slot.id,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    shadows: [Shadow(blurRadius: 2, color: Colors.black26)]
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  slot.status.name.capitalize(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')}";
  }
}
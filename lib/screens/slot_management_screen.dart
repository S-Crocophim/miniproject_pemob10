// lib/screens/slot_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/cold_room.dart';
import '/models/slot_storage.dart';
import '/providers/cold_room_provider.dart';

class SlotManagementScreen extends StatelessWidget {
  final ColdRoom room;

  const SlotManagementScreen({super.key, required this.room});

  // FIX: The switch statement now handles every case from the standardized enum.
  Color _getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.occupied: // Replaces 'terisi'
        return Colors.red.shade400;
      case SlotStatus.inProcess: // Replaces 'dalamProses'
        return Colors.orange.shade400;
      case SlotStatus.available: // Replaces 'tersedia'
        return Colors.green.shade400;
    }
  }

  void _showUpdateDialog(BuildContext context, SlotStorage slot) {
    SlotStatus selectedStatus = slot.status;
    final employeeIdController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Update Status Slot ${slot.id}'),
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
                          // Make the display text more readable
                          child: Text(status.name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim().capitalize()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            selectedStatus = newValue;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Status Baru'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'ID Karyawan (Verifikasi)',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ID Karyawan tidak boleh kosong.';
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
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final provider = Provider.of<ColdRoomProvider>(context, listen: false);
                      try {
                        await provider.updateSlotStatus(
                          roomId: room.id,
                          slotId: slot.id,
                          newStatus: selectedStatus,
                          employeeId: employeeIdController.text.trim(),
                        );
                        Navigator.of(dialogContext).pop(); 
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Status slot berhasil diperbarui!'), backgroundColor: Colors.green)
                        );
                      } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('Gagal memperbarui: $e'), backgroundColor: Colors.red)
                        );
                      }
                    }
                  },
                  child: const Text('Simpan'),
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
        title: Text('Manajemen Slot - ${room.name}'),
      ),
      body: StreamBuilder<List<SlotStorage>>(
        stream: provider.getSlotsForRoom(room.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada slot ditemukan untuk ruangan ini.'));
          }
          
          final slots = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];
                return InkWell(
                  onTap: () => _showUpdateDialog(context, slot),
                  child: Card(
                    color: _getColorForStatus(slot.status),
                    elevation: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            slot.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            // Capitalize for display
                            slot.status.name.toUpperCase(),
                             style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
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
    );
  }
}

// Add this helper extension at the bottom of the file or in a separate utils file
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
// lib/screens/add_room_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/cold_room.dart'; // Make sure this and SlotStatus are in English
import '/providers/cold_room_provider.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newRoom = ColdRoom(
        id: '', // Firestore will generate the ID
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        temperature: 2.0, // Default value
        humidity: 80.0, // Default value
        isDoorOpen: false,
        status: RoomStatus.normal,
        cctvUrl: '',
        slots: [],
      );

      try {
        await Provider.of<ColdRoomProvider>(context, listen: false).addColdRoom(newRoom);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to add room: $e'), backgroundColor: Colors.red));
        }
      }

      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Cold Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Room Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Name cannot be empty.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Location cannot be empty.';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Save Room'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
// lib/providers/cold_room_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/activity_log.dart';
import '/models/cold_room.dart';
import '/models/slot_storage.dart';

class ColdRoomProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ColdRoom>> getColdRooms() {
    return _firestore.collection('cold_rooms').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ColdRoom.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<List<SlotStorage>> getSlotsForRoom(String roomId) {
    return _firestore
        .collection('cold_rooms')
        .doc(roomId)
        .collection('slots')
        .orderBy(FieldPath.documentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SlotStorage.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
  
  // Method BARU: Mengambil semua log aktivitas, diurutkan dari yang terbaru
  Stream<List<ActivityLog>> getActivityLogs() {
    return _firestore
        .collection('activity_logs')
        .orderBy('timestamp', descending: true)
        .limit(100) // Batasi hingga 100 log terbaru untuk efisiensi
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => ActivityLog.fromFirestore(doc)).toList();
        });
  }

  Future<bool> verifyEmployeeId(String employeeId) async {
    try {
      final doc = await _firestore.collection('employees').doc(employeeId).get();
      return doc.exists;
    } catch (e) {
      print("Error verifying employee ID: $e");
      return false;
    }
  }

  Future<void> updateSlotStatus({
    required String roomId,
    required String slotId,
    required SlotStatus newStatus,
    required String employeeId,
  }) async {
    final slotRef = _firestore
        .collection('cold_rooms')
        .doc(roomId)
        .collection('slots')
        .doc(slotId);
    
    final logRef = _firestore.collection('activity_logs').doc();
    
    WriteBatch batch = _firestore.batch();
    
    batch.update(slotRef, {'status': newStatus.name});
    
    batch.set(logRef, {
      'timestamp': FieldValue.serverTimestamp(),
      'employeeId': employeeId,
      'roomId': roomId,
      'slotId': slotId,
      'newStatus': newStatus.name,
      'activity': 'Slot $slotId ($roomId) diubah ke ${newStatus.name} oleh $employeeId',
    });
    
    await batch.commit();
  }

  Future<void> addColdRoom(ColdRoom room) async {
    try {
      await _firestore.collection('cold_rooms').add(room.toMap());
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
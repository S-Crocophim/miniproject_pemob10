// lib/providers/cold_room_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  
  // Method BARU: Mengambil stream data slot untuk satu ruangan tertentu
  Stream<List<SlotStorage>> getSlotsForRoom(String roomId) {
    return _firestore
        .collection('cold_rooms')
        .doc(roomId)
        .collection('slots')
        .orderBy(FieldPath.documentId) // Mengurutkan berdasarkan ID slot (A1, A2, A3, dst)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SlotStorage.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Method BARU: Memperbarui status slot
  Future<void> updateSlotStatus({
    required String roomId,
    required String slotId,
    required SlotStatus newStatus,
    required String employeeId, // Untuk verifikasi dan logging
  }) async {
    final slotRef = _firestore
        .collection('cold_rooms')
        .doc(roomId)
        .collection('slots')
        .doc(slotId);
    
    final logRef = _firestore.collection('activity_logs').doc();

    // Gunakan "Write Batch" untuk memastikan kedua operasi berhasil atau keduanya gagal
    WriteBatch batch = _firestore.batch();
    
    // Operasi 1: Update status slot
    batch.update(slotRef, {'status': newStatus.name});
    
    // Operasi 2: Tambahkan catatan log
    batch.set(logRef, {
      'timestamp': FieldValue.serverTimestamp(),
      'employeeId': employeeId,
      'roomId': roomId,
      'slotId': slotId,
      'newStatus': newStatus.name,
      'activity': 'Status slot $slotId di ruangan $roomId diubah menjadi ${newStatus.name} oleh $employeeId',
    });
    
    // Jalankan batch write
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
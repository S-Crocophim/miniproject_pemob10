// lib/models/activity_log.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String id;
  final String activity;
  final String employeeId;
  final String roomId;
  final String slotId;
  final String newStatus;
  final Timestamp timestamp;

  ActivityLog({
    required this.id,
    required this.activity,
    required this.employeeId,
    required this.roomId,
    required this.slotId,
    required this.newStatus,
    required this.timestamp,
  });

  // Factory constructor untuk membuat objek dari data Firestore
  factory ActivityLog.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ActivityLog(
      id: doc.id,
      activity: data['activity'] ?? 'Aktivitas tidak diketahui',
      employeeId: data['employeeId'] ?? 'N/A',
      roomId: data['roomId'] ?? 'N/A',
      slotId: data['slotId'] ?? 'N/A',
      newStatus: data['newStatus'] ?? 'N/A',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
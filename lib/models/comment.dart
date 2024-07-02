import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  final String carId;
  final String userId;
  final String pesan;
  Timestamp? timestamp;

  Comment({
    this.id,
    required this.carId,
    required this.userId,
    required this.pesan,
    this.timestamp,
  });
}

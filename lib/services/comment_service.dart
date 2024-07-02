import 'package:car_find/models/car.dart';
import 'package:car_find/models/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CommentService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _commentCollection =
      _database.collection('comments');
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final currentUser = FirebaseAuth.instance.currentUser;

  static Stream<List<Comment>> getComments(Car car) {
    return _commentCollection
        .where('carId', isEqualTo: car.id!)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Comment(
          carId: data['carId'],
          userId: data['userId'],
          pesan: data['pesan'],
        );
      }).toList();
    });
  }

  static Future<void> addComment(String carId, String pesan) async {
    Map<String, dynamic> newComment = {
      'carId': carId,
      'userId': currentUser!.email,
      'pesan': pesan,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _commentCollection.add(newComment);
  }
}
